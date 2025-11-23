use bytes::Bytes;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use validator::{Validate, ValidationError};

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ApiResponse {
    pub status: bool,
    pub code: u16,
    pub data: Option<Value>,
    pub message: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct UploadFile {
    #[serde(skip_serializing, skip_deserializing)]
    pub file: Option<Bytes>,
    pub f_type: String,
    pub userid: i32,
    pub original_file_name: Option<String>,
}

#[derive(Clone, Debug, Serialize, Deserialize, Validate)]
pub struct LimitSearch {
    #[validate(range(min = 0))]
    pub skip: i32,
    #[validate(range(min = 0, max = 200))]
    pub take: i32,
}

#[derive(Debug, Deserialize, Serialize)]
enum Status {
    NONE,
    ACTIVE,
    INACTIVE,
}

impl Status {
    // Function to check if the string matches any variant of the enum
    pub fn is_valid(role: &str) -> bool {
        matches!(role.to_uppercase().as_str(), "ACTIVE" | "INACTIVE")
    }
}

#[derive(Clone, Debug, Serialize, Deserialize, Validate)]
pub struct StatusUpdate {
    #[validate(range(min = 1))]
    pub id: i32,
    #[validate(custom(function = "validate_status"))]
    pub status: String,
    #[validate(range(min = 0))]
    pub updated_by: i32,
}

// Validate that the role is one of the enum variants as a string
pub fn validate_status(role: &str) -> Result<(), ValidationError> {
    if Status::is_valid(role) {
        Ok(())
    } else {
        Err(ValidationError::new(
            "Invalid role: must be one of ACTIVE, INACTIVE or NONE",
        ))
    }
}
