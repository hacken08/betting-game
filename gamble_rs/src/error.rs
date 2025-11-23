use axum::{http::StatusCode, response::IntoResponse, Json};
use serde_json::json;
use thiserror::Error;

use crate::models::utils::ApiResponse;

pub type Result<T> = core::result::Result<T, AppError>;

#[derive(Debug, strum_macros::AsRefStr, Error)]
pub enum AppError {
    #[error("Failed to login user")]
    LoginFail,

    #[error("Auth fail")]
    AuthFailNoAuthTokenCookie,

    #[error("Token is Invalid")]
    AuthTokenIsNOtValid,

    #[error("Request is not from original user")]
    MismatchedIpAddresses,

    #[error("Token is is expire")]
    AuthTokenIsExp,

    #[error("Unable to delete user")]
    TicketDeleteFailIdNotFound { id: u64 },

    #[error("Unable to upload the file")]
    UploadError(String),

    #[error(transparent)]
    JwtError(#[from] jsonwebtoken::errors::Error),
}

impl IntoResponse for AppError {
    fn into_response(self) -> axum::response::Response {
        println!("-->  app error");
        let (status_code, message): (StatusCode, String) = match self {
            AppError::UploadError(value) => (StatusCode::BAD_REQUEST, value),
            AppError::JwtError(val) => (StatusCode::BAD_REQUEST, format!("{}", val)),
            AppError::LoginFail => (StatusCode::BAD_REQUEST, "Failed to login user".to_string()),
            AppError::AuthFailNoAuthTokenCookie => {
                (StatusCode::BAD_REQUEST, "Auth fail".to_string())
            }
            AppError::AuthTokenIsNOtValid => {
                (StatusCode::BAD_REQUEST, "Token is Invalid".to_string())
            }
            AppError::MismatchedIpAddresses => (
                StatusCode::BAD_REQUEST,
                "Request is not from original user".to_string(),
            ),
            AppError::AuthTokenIsExp => (StatusCode::BAD_REQUEST, "Token is is expire".to_string()),
            _ => (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Something want wrong.Try Again".to_string(),
            ),
        };

        let response: ApiResponse = ApiResponse {
            message: message,
            code: status_code.as_u16(),
            status: false,
            data: Some(json!({})),
        };
        (StatusCode::INTERNAL_SERVER_ERROR, Json(response)).into_response()
    }
}
