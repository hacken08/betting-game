use async_trait::async_trait;
use axum::{extract::FromRequestParts, http::request::Parts};
use axum_auth::AuthBearerCustom;
use hyper::StatusCode;

use super::error::LibsError;
// use http::{request::Parts, StatusCode};

/// Your custom bearer auth returning a fun 418 for errors
pub struct MyCustomBearerAuth(pub String);

// this is where you define your custom options
impl AuthBearerCustom for MyCustomBearerAuth {
    const ERROR_CODE: StatusCode = StatusCode::UNAUTHORIZED; // <-- define custom status code here
    const ERROR_OVERWRITE: Option<&'static str> = None; // <-- define overwriting message here

    fn from_header(contents: &str) -> Self {
        Self(contents.to_string())
    }
}

// this is just boilerplate, copy-paste this
#[async_trait]
impl<B> FromRequestParts<B> for MyCustomBearerAuth
where
    B: Send + Sync,
{
    type Rejection = LibsError;

    async fn from_request_parts(parts: &mut Parts, _: &B) -> Result<Self, Self::Rejection> {
        match Self::decode_request_parts(parts) {
            Ok(val) => Ok(val),
            Err(e) => Err(LibsError::AuthError),
        }
    }
}
