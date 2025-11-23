use std::string::FromUtf8Error;

use axum::{
    extract::rejection::{BytesRejection, JsonRejection},
    response::IntoResponse,
    Json,
};
use hyper::StatusCode;
use serde_json::json;
use thiserror::Error;
use validator::ValidationErrors;

use crate::models::utils::ApiResponse;

pub type Result<T> = core::result::Result<T, LibsError>;

#[derive(Debug, strum_macros::AsRefStr, Error)]
pub enum LibsError {
    #[error("{0}")]
    DataBase(String),

    #[error("Auth Error")]
    AuthError,

    #[error("config error")]
    ConfigWrongFormat,

    #[error("password hash error")]
    PasswordHashError(#[from] argon2::password_hash::Error),

    #[error(transparent)]
    AxumJsonRejection(#[from] JsonRejection),

    #[error(transparent)]
    ValidationError(#[from] ValidationErrors),

    #[error("Deserialization error: {0}")]
    DeserializationError(String),

    // #[error("Missing field `{0}` at line {1} column {2}")]
    #[error("Field `{0}` is required")]
    MissingFieldError(String),

    #[error(transparent)]
    RegexError(#[from] regex::Error),

    #[error(transparent)]
    BytesError(#[from] BytesRejection),

    #[error(transparent)]
    Utf8Error(#[from] FromUtf8Error),

    #[error(transparent)]
    H2Error(#[from] sha2::digest::InvalidLength),
}

impl IntoResponse for LibsError {
    fn into_response(self) -> axum::response::Response {
        log::info!("{}", self);
        log::info!("---> Lib Error");
        // #[warn(unreachable_patterns)]
        let (status_code, message): (StatusCode, String) = match self {
            LibsError::MissingFieldError(field) => (
                StatusCode::BAD_REQUEST,
                format!("Field `{}` is required", field),
            ),
            LibsError::DataBase(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            LibsError::AuthError => (StatusCode::BAD_REQUEST, format!("Auth Error")),
            LibsError::ConfigWrongFormat => (StatusCode::BAD_REQUEST, format!("Config Error")),
            LibsError::PasswordHashError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            LibsError::AxumJsonRejection(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            LibsError::ValidationError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            LibsError::DeserializationError(error) => {
                (StatusCode::BAD_REQUEST, format!("{}", error))
            }
            LibsError::RegexError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            LibsError::BytesError(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            LibsError::Utf8Error(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            LibsError::H2Error(error) => (StatusCode::BAD_REQUEST, format!("{}", error)),
            // LibsError::MissingFieldError(field) => (
            //     StatusCode::BAD_REQUEST,
            //     format!("Field `{}` is required", field),
            // ),
            // _ => (
            //     StatusCode::INTERNAL_SERVER_ERROR,
            //     "Something want wrong.Try Again".to_string(),
            // ),
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
