use std::net::SocketAddr;

use crate::{
    config::config, libs::custom_validation::ValidatePayload, models::app_state::AppState,
};
use axum::{
    extract::{ConnectInfo, Path, State},
    http::StatusCode,
    routing::post,
    Json, Router,
};

use crate::models::auth::AccessTokenClaims;
use crate::{
    controller::auth::{gen_jwt_token, login_user, register_user},
    models::{
        auth::{LoginPayload, RegisterPayload},
        user::User,
    },
    routers::error::Result,
};
use axum::{
    response::{IntoResponse, Response},
    routing::get,
};
use jsonwebtoken::{decode, Algorithm, DecodingKey, Validation};
use serde_json::json;
use sqlx::{MySql, Pool};
use tower_cookies::CookieManagerLayer;

use crate::models::utils::ApiResponse;

pub fn routes(db: Pool<MySql>) -> Router {
    let app_state = AppState { db };

    Router::new()
        .route("/login", post(auth_login))
        .route("/register", post(auth_register))
        .route("/verify-token/:token", get(verify_token))
        .layer(CookieManagerLayer::new())
        .with_state(app_state)
}

async fn auth_login(
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<LoginPayload>,
) -> Result<impl IntoResponse> {
    println!("-----------------Auth login api-----------");

    let data: User = login_user(db.db.clone(), payload.clone()).await?;
    let (access_token, refresh_token) = gen_jwt_token(&data, addr, db.db).await?;

    println!("working");

    let body: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Login Succesufll".to_string(),
        data: Some(json!( {
            "id": data.id,
            "role": data.role,
            "access_token": access_token,
            "refresh_token": refresh_token,
        })),
        status: true,
    };

    let response = Response::builder()
        .status(200)
        .header(
            "set-cookie",
            format!("x-refresh_token = {} ", refresh_token),
        )
        .body(Json(body).into_response())?;

    Ok(response)
}

async fn auth_register(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<RegisterPayload>,
) -> Result<Json<ApiResponse>> {
    println!("-----------------Auth Register api-----------");

    let data: User = register_user(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Register Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };

    Ok(Json(response))
}

async fn verify_token(
    State(_): State<AppState>,
    Path(token): Path<String>,
) -> Result<impl IntoResponse> {
    println!("-----------------Verify token api-----------");

    let jwt_secret = config::CONFIG.jwt_secret.as_str();
    let validator: Validation = Validation::new(Algorithm::HS256);

    let _token: jsonwebtoken::TokenData<AccessTokenClaims> = decode::<AccessTokenClaims>(
        &token,
        &DecodingKey::from_secret(jwt_secret.as_ref()),
        &validator,
    )?;

    Ok(Json(ApiResponse {
        code: 200,
        message: "Verify Token Succesufll".to_string(),
        data: Some(json!({"status": true})),
        status: true,
    })
    .into_response())
}
