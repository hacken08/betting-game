use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use std::cmp::Ordering;
use sqlx::{
    mysql::{MySql, MySqlRow},
    FromRow, Row,
};
use sqlx::Decode;
use validator::{Validate, ValidationError};

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct WithdrawalRequest {
    pub id: i32,
    pub user_id: i32,
    pub worker_id: i32,
    pub amount: String,
    pub bank_name: String,
    pub account_holder: String,
    pub ifsc_code: String,
    pub account_number: String,
    pub payment_status: String,
    pub status: String,
    pub created_at: NaiveDateTime,
    pub updated_at: NaiveDateTime,
    pub deleted_at: Option<NaiveDateTime>,
}


#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct WorkersWithdrawalRequestData {
    pub id: i32,
    pub user_id: Option<i32>,
    pub user_email: Option<String>,
    pub user_mobile: Option<String>,
    pub user_username: Option<String>,
    pub bank_name: String,
    pub account_holder: String,
    pub account_number: String,
    pub ifsc_code: String,
    pub amount: String,
    pub created_at: Option<NaiveDateTime>,
}


#[derive(Deserialize, Debug, Validate, Serialize)]
pub struct CreateWithdrawalRequestPayload {
    #[validate(range(min = 0))]
    pub user_id: i32,

    #[validate(range(min = 0.0))]
    pub amount: f32,

    #[validate(length(min = 3, message = "account number is required"))]
    pub account_number: String,

    #[validate(length(min = 3, message = "Bank name is required"))]
    pub bank_name: String,

    #[validate(length(min = 3, message = "Account holder is required"))]
    pub account_holder: String,

    #[validate(length(min = 3, message = "IFSC is required"))]
    pub ifsc_code: String,

    #[validate(custom(function = "validate_status"))]
    pub status: String,
}


pub fn validate_status(status: &str) -> Result<(), ValidationError> {
    if Status::is_valid(status) {
        Ok(())
    } else {
        Err(ValidationError::new(
            "Invalid status: must be one of ACTIVE, INACTIVE or NONE",
        ))
    }
}

#[derive(Debug, Serialize, Deserialize, FromRow, PartialEq, PartialOrd)]
pub struct AssignedWorkerRequests {
    pub id: Option<i32>,
    pub worker_email: Option<String>,
    pub role: Option<String>,
    pub total_withdrwal_request_have: Option<i32>,
    // withrawal_request: Option<WithdrawalRequest>,
}

#[derive(Debug, Deserialize, Serialize)]
pub enum Status {
    ACTIVE,
    INACTIVE,
    NONE,
}

impl Status {
    fn is_valid(role: &str) -> bool {
        matches!(role.to_uppercase().as_str(), "ACTIVE" | "INACTIVE" | "NONE")
    }
}

impl Default for Status {
    fn default() -> Self {
        Status::NONE
    }
}

// impl<'r> FromRow<'r, MySqlRow> for WithdrawalRequest {
//     fn from_row(row: &MySqlRow) -> Result<Self, sqlx::Error> {
//         Ok(WithdrawalRequest {
//             id: row.get::<_, usize>(0)?,
//             account_number: row.get(1)?,
//             amount: row.get(2)?,
//             user_id: row.get(3)?,
//             bank_name: row.get(4)?,
//             account_holder: row.get(5)?,
//             ifsc_code: row.get(6)?,
//             status: row.get(7)?,
//             created_at: row.get(8)?,
//             updated_at: row.get(9)?,
//             deleted_at: row.get(10),
//         })
//     }
// }
