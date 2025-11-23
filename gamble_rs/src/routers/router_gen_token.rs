use std::net::SocketAddr;

use crate::config;
use crate::controller::auth::gen_jwt_token;
use crate::models::{auth::RefreshTokenClaims, user::User, utils::ApiResponse};
use crate::routers::error::Result;

use axum::Json;
use axum::{
    extract::{ConnectInfo, Path, State},
    response::IntoResponse,
    routing::post,
    Router,
};
use jsonwebtoken::{decode, DecodingKey, Validation};
use serde_json::json;
use sqlx::{MySql, Pool};

#[derive(Debug, Clone)]
struct AppState {
    db: Pool<MySql>,
}

pub fn routes(db: Pool<MySql>) -> Router {
    let db_state = AppState { db };

    Router::new()
        .route("/:token", post(refresh_access_token))
        .with_state(db_state)
}

async fn refresh_access_token(
    State(db): State<AppState>,
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    Path(refresh_tokn): Path<String>,
) -> Result<impl IntoResponse> {
    println!("----------- gen new token api -----------");

    let jwt_secret = config::config::CONFIG.jwt_secret.as_str();
    let token_data = decode::<RefreshTokenClaims>(
        &refresh_tokn,
        &DecodingKey::from_secret(jwt_secret.as_ref()),
        &Validation::default(),
    )?;

    // Verifying expiry date of tokens
    let current_time = chrono::Utc::now().timestamp() as usize;
    if token_data.claims.exp < current_time {
        let res = ApiResponse {
            message: String::from("Refrsh token is expired"),
            code: 404,
            status: false,
            data: None,
        };
        return Ok(Json(res));
    }

    // Verifying ip address of request and removing token from db s
    let req_addr: String = addr.to_string().split(":").next().unwrap().to_string();
    if req_addr != token_data.claims.ip_addr {
        let _ = sqlx::query("UPDATE users SET refresh_token = NULL WHERE id = ?;")
            .bind(&token_data.claims.id)
            .execute(&db.db)
            .await;

        return Ok(Json(ApiResponse {
            message: String::from("Unaothorizated sender"),
            code: 404,
            status: false,
            data: None,
        }));
    }

    // verifying token with token store in db
    let db_user: Option<User> = sqlx::query_as("SELECT * FROM users WHERE id = ?;")
        .bind(token_data.claims.id)
        .fetch_optional(&db.db)
        .await?;

    match db_user {
        Some(user) => {
            if user.refresh_token.clone().unwrap() != refresh_tokn {
                return Ok(Json(ApiResponse {
                    message: String::from("Your token is not correct for this user"),
                    code: 405,
                    status: false,
                    data: None,
                }));
            }

            // Finally generating a new access token
            let (acces_token, refresh_token) = gen_jwt_token(&user, addr, db.db).await?;

            return Ok(Json(ApiResponse {
                message: String::from("New token generated in success"),
                code: 200,
                status: true,
                data: Some(json!({
                    "access_token": acces_token,
                    "refresh_token": refresh_token,
                })),
            }));
        }
        None => {
            return Ok(Json(ApiResponse {
                message: String::from("User's data is not avaliable"),
                code: 405,
                status: false,
                data: None,
            }));
        }
    }
}
