use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use strum_macros::EnumString;
use validator::Validate;

use crate::models::user::User;

use super::{account::WorkersAccount, payments::PaymentGateway};

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct MoneyDeposite {
    pub id: i32,
    pub user_id: i32,
    pub worker_id: i32,
    pub amount: String,
    pub txn_id: String,
    pub payment_gateway_id: i32,
    pub worker_account_id: i32,
    pub payment_screen_shot: String,
    pub status: String,
    pub payment_status: String,
    pub creteded_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: NaiveDateTime,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct MoneyDepositeWithRelations {
    pub id: i32,
    pub user_id: i32,
    pub worker_id: i32,
    pub amount: String,
    pub txn_id: String,
    pub payment_gateway_id: i32,
    pub worker_account_id: i32,
    pub payment_screen_shot: String,
    pub status: String,
    pub payment_status: String,
    pub creteded_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: NaiveDateTime,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
    pub payment_gateway: PaymentGateway,
    pub worker_account: WorkersAccount,
    pub worker: User,
    pub user: User,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct CreateMoneyDepositePayload {
    pub user_id: i32,
    pub worker_id: i32,
    pub amount: String,
    pub txn_id: String,
    pub payment_gateway_id: i32,
    pub worker_account_id: i32,
    pub payment_screen_shot: String,
}

#[derive(Debug, Deserialize, Validate)]
pub struct MoneyDepositeSearchPayload {
    pub user_id: Option<i32>,
    pub worker_id: Option<i32>,
    pub status: Option<String>,
    pub payment_status: Option<String>,
    pub created_at_start: Option<NaiveDateTime>,
    pub created_at_end: Option<NaiveDateTime>,
}

#[derive(Debug, Deserialize, Validate)]
pub struct UpdateMoneyDeposite {
    pub id: i32,
    pub status: Option<String>,
    pub payment_status: Option<PaymentStatus>,
    pub updated_by: Option<i32>,
    pub deleted_by: Option<i32>,
    pub worker_id: Option<i32>,
}

#[derive(Debug, Clone, Validate)]
pub struct PaginationSearch {
    pub user_id: Option<i32>,
    pub worker_id: Option<i32>,
    pub payment_status: Option<String>,
    pub status: Option<String>,
    pub take: i32,
    pub skip: i32,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "ENUM")]
pub enum MoneyDepositeStatus {
    ACTIVE,
    INACTIVE,
    NONE,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type, EnumString)]
#[sqlx(type_name = "ENUM")]
pub enum PaymentStatus {
    ACCEPT,
    REJECT,
    PROCESSING,
    PENDING,
    REFUNDED,
}

impl PaymentStatus {
    pub fn to_string(self) -> String {
        match self {
            Self::ACCEPT => "ACCEPT".to_string(),
            Self::REJECT => "REJECT".to_string(),
            Self::PROCESSING => "PROCESSING".to_string(),
            Self::PENDING => "PENDING".to_string(),
            Self::REFUNDED => "REFUNDED".to_string(),
            _ => "".to_string(),
        }
    }
}
