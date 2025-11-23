use sqlx::FromRow;
use serde::{Deserialize, Serialize};
use chrono::NaiveDateTime;

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct Transition {
    pub id: i32,
    pub user_id: i32,
    pub admin_id: i32,
    pub amount: String, // VARCHAR(255) in SQL translates to String in Rust
    pub tranisition_type: String, // Enum field mapped to a custom type
    pub created_by: i32,
    pub created_at: NaiveDateTime, // DATETIME field
    pub updated_by: Option<i32>, // NULLABLE field
    pub updated_at: NaiveDateTime, // DATETIME with ON UPDATE
    pub deleted_by: Option<i32>, // NULLABLE field
    pub status: String, // Another enum field
    pub deleted_at: Option<NaiveDateTime>, // NULLABLE DATETIME
}

#[derive(Debug, Serialize, Deserialize)]
pub struct TransitionPayload {
    pub user_id: i32,
    pub admin_id: i32,
    pub amount: String, // VARCHAR(255) as String
    pub tranisition_type: TransitionType, // Enum for "DEBIT" or "CREDIT"
    pub created_by: i32,
}

// Enum for `type` column
#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "ENUM")] // Matches SQL enum type
#[sqlx(rename_all = "UPPERCASE")] // Matches SQL enum casing
pub enum TransitionType {
    DEBIT,
    CREDIT,
}

