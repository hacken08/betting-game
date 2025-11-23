use axum::{
    extract::rejection::{JsonRejection, RawPathParamsRejection},
    http::StatusCode,
    response::IntoResponse,
    Json,
};
use chrono::ParseError;
use serde_json::json;
use thiserror::Error;
use validator::{ValidationError, ValidationErrors};

use crate::models::utils::ApiResponse;

pub type Result<T> = core::result::Result<T, RouterError>;

#[derive(Debug, strum_macros::AsRefStr, Error)]
pub enum RouterError {
    #[error("Invalid Url")]
    PathError(#[from] RawPathParamsRejection),

    #[error("UnexpectedError: {0}")]
    UnexcpectedError(String),

    #[error("Path not Fount")]
    PathNotFound,

    #[error("Invalid path parameter: `{0}`")]
    InvalidPathParameter(String),

    #[error(transparent)]
    AxumJsonRejection(#[from] JsonRejection),

    #[error("Invalid date from param")]
    DateParseError(#[from] ParseError),

    #[error(transparent)]
    ValidationError(#[from] ValidationErrors),

    #[error(transparent)]
    BADPARAMS(#[from] ValidationError),

    #[error("No active workers found")]
    NoWorkersFound,

    #[error("Deserialization error: {0}")]
    DeserializationError(String),

    #[error("Field `{0}` is required")]
    MissingFieldError(String),

    #[error(transparent)]
    SerdeError(#[from] serde_json::Error),

    #[error(transparent)]
    SqlxError(#[from] sqlx::Error),

    #[error(transparent)]
    ControlError(#[from] crate::controller::error::ControllerError),

    #[error(transparent)]
    JwtError(#[from] jsonwebtoken::errors::Error),

    #[error(transparent)]
    AnyHowError(#[from] anyhow::Error),

    #[error(transparent)]
    AxumHttpError(#[from] axum::http::Error),

    // #[error(transparent)]
    // BadParamsError(#[from] ValidationErrors),

    #[error("User is not authorized")]
    UnauthorizedUser,
}

impl IntoResponse for RouterError {
    fn into_response(self) -> axum::response::Response {
        println!("-->  router error");

        let (status_code, message): (StatusCode, String) = match self {
            RouterError::ControlError(error) => {
                (StatusCode::BAD_REQUEST, format!("controller: {}", error))
            }
            RouterError::UnexcpectedError(value) => {
                (StatusCode::EXPECTATION_FAILED, format!("Error: {}", value))
            }
            RouterError::SqlxError(field) => (StatusCode::BAD_REQUEST, format!("sqlx: {}", field)),
            RouterError::SerdeError(field) => {
                (StatusCode::BAD_REQUEST, format!("serde: {}", field))
            }
            RouterError::JwtError(field) => (StatusCode::BAD_REQUEST, format!("jwt: {}", field)),
            RouterError::DateParseError(field) => {
                (StatusCode::BAD_REQUEST, format!("Date Parser: {}", field))
            }
            RouterError::UnauthorizedUser => {
                (StatusCode::BAD_REQUEST, format!("User Is Not authorized"))
            }
            RouterError::PathError(field) => (StatusCode::BAD_REQUEST, format!("Invalid Url")),
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

        (status_code, Json(response)).into_response()

        // match self {
        //     RouterError::ValidationError(_) => {
        //         println!("{}", self);
        //         let message = format!("Input Validaton error: [{self}]").replace("\n", ",");
        //         (StatusCode::INTERNAL_SERVER_ERROR, message).into_response()
        //     }
        //     RouterError::AxumJsonRejection(_) => {
        //         let message = format!("another axum error: {}", self);
        //         (StatusCode::INTERNAL_SERVER_ERROR, message).into_response()
        //     }
        //     RouterError::MissingFieldError(field) => {
        //         let message = format!("Field `{}` is required", field);
        //         (StatusCode::BAD_REQUEST, message).into_response()
        //     }
        //     _ => {
        //         // create a placeholder Axum response.
        //         let response = (
        //             StatusCode::INTERNAL_SERVER_ERROR,
        //             "Something want wrong.Try Again",
        //         )
        //             .into_response();

        //         response
        //     }
        // }
    }
}
