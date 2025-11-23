use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::prelude::FromRow;
use validator::{Validate, ValidationError};

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct PaymentGateway {
    pub id: i32,
    pub name: String,
    pub image: String,
    pub short_image: Option<String>,
    pub payment_type: String,
    pub status: String,
    pub created_at: NaiveDateTime,
    pub created_by: Option<i32>,
    pub updated_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
}

#[derive(Debug, Deserialize, Serialize)]
pub enum Status {
    ACTIVE,
    INACTIVE,
    NONE,
}

impl Status {
    // Function to check if the string matches any variant of the enum
    pub fn is_valid(role: &str) -> bool {
        matches!(role.to_uppercase().as_str(), "ACTIVE" | "INACTIVE" | "NONE")
    }
}

#[derive(Debug, Deserialize, Clone, Copy, Serialize)]
pub enum PaymentType {
    UPI,    
    QR,
    BANK,
    NONE,
}

impl PaymentType {
    // Function to check if the string matches any variant of the enum
    pub fn is_valid(role: &str) -> bool {
        matches!(role.to_uppercase().as_str(), "UPI" | "QR" | "BANK" | "NONE")
    }

    pub fn to_string(&self) -> String {
        match self {
            Self::UPI => "UPI".to_string(),
            Self::QR => "QR".to_string(),
            Self::BANK => "BANK".to_string(),
            Self::NONE => "NONE".to_string(),
        }
    }
}

#[derive(Deserialize, Debug, Validate, Serialize)]
pub struct PaymentGatewayCreate {
    #[validate(length(min = 3, message = "Name is required"))]
    pub name: String,

    #[validate(length(min = 3, message = "Image Path is required"))]
    pub image: String,

    // #[validate(length())]
    pub short_image: Option<String>,

    #[validate(custom(function = "validate_type"))]
    pub payment_type: String,

    #[validate(custom(function = "validate_status"))]
    pub status: String,

    #[validate(range(min = 0))]
    pub created_by: i32,
}

// Validate that the role is one of the enum variants as a string
fn validate_status(status: &str) -> Result<(), ValidationError> {
    if Status::is_valid(status) {
        Ok(())
    } else {
        Err(ValidationError::new(
            "Invalid status: must be one of ACTIVE, INACTIVE or NONE",
        ))
    }
}

// Validate that the role is one of the enum variants as a string
pub fn validate_type(status: &str) -> Result<(), ValidationError> {
    if PaymentType::is_valid(status) {
        Ok(())
    } else {
        Err(ValidationError::new(
            "Invalid payment type: must be one of UPI, QR, BANK or NONE",
        ))
    }
}
