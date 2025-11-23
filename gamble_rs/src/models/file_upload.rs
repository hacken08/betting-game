use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(FromRow, Serialize, Deserialize, Debug)]
pub struct FileUpload {
    pub id: i32,
    pub userid: i32,
    pub file_type: String, // Changed `type` to `file_type` since `type` is a reserved keyword in Rust
    pub path: String,
    pub name: String,
    pub status: String,
    pub created_at: NaiveDateTime,
    pub created_by: Option<i32>,
    pub updated_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
}
