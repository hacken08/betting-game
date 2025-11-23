use axum::{
    body::Bytes,
    extract::{rejection::JsonRejection, FromRequest, Request},
    Json,
};
use regex::Regex;
use serde::de::DeserializeOwned;
use validator::Validate;

use super::error::LibsError;

#[derive(Debug, Clone, Copy, Default)]
pub struct ValidatePayload<T>(pub T);

#[async_trait::async_trait]
impl<T, S> FromRequest<S> for ValidatePayload<T>
where
    T: DeserializeOwned + Validate,
    S: Send + Sync,
    Json<T>: FromRequest<S, Rejection = JsonRejection>,
{
    type Rejection = LibsError;

    async fn from_request(req: Request, _state: &S) -> Result<Self, Self::Rejection> {
        let re = Regex::new(r"missing field `(\w+)`")?;
        // Extract the raw bytes from the request body
        let bytes = Bytes::from_request(req, &()).await?;

        // Convert the bytes to a string
        let raw_json = String::from_utf8(bytes.to_vec())?;

        let value: Result<T, serde_json::Error> = serde_json::from_str(&raw_json);

        match value {
            Ok(val) => {
                val.validate()?;
                Ok(ValidatePayload(val))
            }
            Err(e) => {
                let error = e.to_string();

                if let Some(caps) = re.captures(&error) {
                    if let Some(missing_field) = caps.get(1) {
                        Err(LibsError::MissingFieldError(
                            missing_field.as_str().to_string(),
                        ))
                    } else {
                        log::error!("{error}");
                        Err(LibsError::DeserializationError("Invalid JSON".to_string()))
                    }
                } else {
                    log::error!("{error} 12");
                    // log::error!("{caps} 12");
                    Err(LibsError::DeserializationError("Invalid JSON".to_string()))
                }
            }
        }
    }
}
