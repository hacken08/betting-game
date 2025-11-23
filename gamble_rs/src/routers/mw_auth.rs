use axum::extract::{FromRequestParts, Request};
use axum::http::request::Parts;
use axum::middleware::Next;
use axum::response::Response;
use axum::RequestPartsExt;
use hyper::header::AUTHORIZATION;
use hyper::HeaderMap as HyperHeaderMap;
use hyper::Uri;
use jsonwebtoken::{decode, DecodingKey, Validation};
use tower_cookies::Cookies;

use crate::config;
use crate::ctx::user_ctx::Ctx;
use crate::error::{AppError, Result};
use crate::libs::custom_auth::MyCustomBearerAuth;
use crate::models::auth::AccessTokenClaims;
use crate::routers::AUTH_TOEKN;

// #[axum::debug_handler]
pub async fn mw_require_auth(
    _: Result<Ctx>,
    MyCustomBearerAuth(token): MyCustomBearerAuth,
    mut req: Request,
    next: Next,
) -> Result<Response> {
    let jwt_secret = config::config::CONFIG.jwt_secret.as_str();
    let tokendata = decode::<AccessTokenClaims>(
        &token,
        &DecodingKey::from_secret(jwt_secret.as_ref()),
        &Validation::default(),
    );

    match tokendata {
        Ok(token_data) => {
            let current_time = chrono::Utc::now().timestamp() as usize;

            if token_data.claims.exp < current_time {
                return Err(AppError::AuthTokenIsExp);
            }

            req.extensions_mut().insert(token_data.claims.clone());
            return Ok(next.run(req).await);
        }
        Err(_) => Err(AppError::AuthTokenIsNOtValid),
    }
}

#[async_trait::async_trait]
impl<S: Send + Sync> FromRequestParts<S> for Ctx {
    type Rejection = AppError;

    async fn from_request_parts(parts: &mut Parts, _state: &S) -> Result<Self> {
        // Extract the headers from `Parts`
        let headers: &HyperHeaderMap = &parts.headers;

        // Attempt to retrieve the `Authorization` header
        let token = headers
            .get(AUTHORIZATION)
            .and_then(|header| header.to_str().ok()) // Convert the header to a string
            .and_then(|header_value| {
                if header_value.starts_with("Bearer ") {
                    Some(header_value.trim_start_matches("Bearer ")) // Strip the "Bearer " part
                } else {
                    None
                }
            })
            .ok_or(AppError::AuthFailNoAuthTokenCookie)?;

        // Now you can validate and decode the token
        let jwt_secret = config::config::CONFIG.jwt_secret.as_str(); // Return an error if no valid token is found

        let tokendata = decode::<AccessTokenClaims>(
            &token,
            &DecodingKey::from_secret(jwt_secret.as_ref()),
            &Validation::default(),
        );

        match tokendata {
            Ok(token_data) => {
                let current_time = chrono::Utc::now().timestamp() as usize;

                if token_data.claims.exp < current_time {
                    return Err(AppError::AuthTokenIsExp);
                }

                return Ok(Ctx::new(token_data.claims.id, token_data.claims.role));
            }
            Err(_) => Err(AppError::AuthTokenIsNOtValid),
        }
        // return Ok(Ctx::new(5, "ADMIN".to_string()));
    }
}
