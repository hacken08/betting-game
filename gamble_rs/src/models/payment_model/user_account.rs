use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::Validate;

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct UsersAccount {
    pub id: i32,
    pub user_id: i32,
    pub bank_name: Option<String>,
    pub account_holder: Option<String>,
    pub ifsc_code: Option<String>,
    pub account_number: Option<String>,
    pub status: String,
    pub created_at: chrono::NaiveDateTime,
    pub created_by: Option<i32>,
    pub updated_at: chrono::NaiveDateTime,
    pub updated_by: Option<i32>,
    pub deleted_at: Option<chrono::NaiveDateTime>,
    pub deleted_by: Option<i32>,
}


#[derive(Debug, Deserialize, Validate)]
pub struct CreateAccountPayload {
    pub user_id: i32,

    #[validate(length(min = 1, message = "Bank name is required"))]
    pub bank_name: Option<String>,

    #[validate(length(min = 1, message = "Account holder name is required"))]
    pub account_holder: Option<String>,

    #[validate(length(min = 11, message = "Invalid IFSC code"))]
    pub ifsc_code: Option<String>,

    #[validate(length(min = 10, message = "Account number is required"))]
    pub account_number: Option<String>,

    #[validate(range(min = 0))]
    pub created_by: Option<i32>,
}
