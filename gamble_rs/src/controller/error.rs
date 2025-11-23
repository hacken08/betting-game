use axum::{extract::multipart::MultipartError, http::StatusCode, response::IntoResponse, Json};
use serde_json::json;
use thiserror::Error;

use crate::{libs::error::LibsError, models::utils::ApiResponse};
pub type Result<T> = core::result::Result<T, ControllerError>;

#[derive(Debug, strum_macros::AsRefStr, Error, )]
pub enum ControllerError {
    #[error(transparent)]
    SqlxError(#[from] sqlx::Error),

    #[error("{0} not found in table")]
    DataNotFound(String),

    #[error("No active account found")]
    NoWorkersFound,

    #[error(transparent)]
    JwtError(#[from] jsonwebtoken::errors::Error),

    #[error(transparent)]
    JSON_Error(#[from] serde_json::Error),

    #[error("Invalid jwt token")]
    InvalidJWtToken,

    #[error("jwt token is expired")]
    ExpireJwtToken,

    #[error("Trying to parse un-parsable str to NaiveDate")]
    ParseDateError(#[from]chrono::ParseError),

    #[error("{0}")]
    DataBase(String),

    #[error("{0}")]
    BcryptError(String),

    #[error("{0}")]
    JwtTokenNotvalid(String),

    #[error(transparent)]
    UploadError(#[from] MultipartError),

    #[error(transparent)]
    FileError(#[from] std::io::Error),

    #[error(transparent)]
    LibError(#[from] LibsError),
}

impl IntoResponse for ControllerError {
    fn into_response(self) -> axum::response::Response {
        log::info!("---> Controller Error");

        let (status_code, message): (StatusCode, String) = match self {
            ControllerError::SqlxError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::JSON_Error(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::DataNotFound(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::ParseDateError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::JwtTokenNotvalid(error) => {
                (StatusCode::BAD_REQUEST, format!("{}", error))
            }
            ControllerError::ExpireJwtToken => {
                (StatusCode::BAD_REQUEST, format!("jwt token is expired"))
            }
            ControllerError::DataBase(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::BcryptError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::UploadError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::FileError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            ControllerError::LibError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
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
