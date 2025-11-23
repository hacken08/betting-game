use crate::models::{payment_model::payments::validate_type, utils::validate_status};
use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::Validate;

#[derive(Deserialize, Clone, Serialize, Debug, FromRow)]
pub struct WorkersAccount {
    pub id: i32,
    pub worker_id: i32,
    pub gateway_id: i32,
    pub upi_address: String,
    pub contact: String,
    pub qr_image: String,
    pub worker_email: String,
    pub bank_name: String,
    pub account_holder: String,
    pub ifsc_code: String,
    pub account_number: String,
    pub payment_type: String,
    pub status: String,
    pub created_at: NaiveDateTime,
    pub created_by: i32,
    pub updated_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
}

#[derive(Deserialize, Debug, Validate, Serialize)]
pub struct CreateAccountPayload {
    #[validate(range(min = 0))]
    pub worker_id: i32,

    #[validate(range(min = 0))]
    pub gateway_id: i32,

    pub upi_address: Option<String>,

    pub qr_image: Option<String>,

    pub worker_email: Option<String>,

    pub bank_name: Option<String>,

    pub account_holder: Option<String>,

    pub ifsc_code: Option<String>,

    pub account_number: Option<String>,

    #[validate(custom(function = "validate_type"))]
    pub payment_type: String,

    // #[validate(custom(function = "validate_status"))]
    pub status: Option<String>,

    #[validate(range(min = 0))]
    pub created_by: i32,
}

#[derive(Deserialize, Debug, Validate, Serialize)]
pub struct UpdatedAccountStatusPayload {
    #[validate(range(min = 0))]
    pub worker_id: i32,

    #[validate(range(min = 0))]
    pub gateway_id: i32,

    pub id: Option<i32>,

    #[validate(custom(function = "validate_status"))]
    pub status: String,
}
