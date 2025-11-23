// use validator::Validate;

use chrono::{DateTime, NaiveDateTime, Utc};
use clone::Clone;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use std::clone;
use struct_iterable::Iterable;
use validator::{Validate, ValidationError};

fn validate_start_time(start_time: &DateTime<Utc>) -> Result<(), ValidationError> {
    let now = Utc::now();
    if *start_time < now {
        return Err(ValidationError::new("start_time must be in the future"));
    }
    Ok(())
}
// Validator to check if `end_time` is in the future
fn validate_end_time(end_time: &DateTime<Utc>) -> Result<(), ValidationError> {
    if *end_time <= Utc::now() {
        return Err(ValidationError::new("end_time must be in the future"));
    }
    Ok(())
}

#[derive(Debug, Clone, Validate, Deserialize, Iterable, Serialize)]
pub struct CreateGamePayload {
    #[validate(custom(
        function = "validate_start_time",
        message = "start_time must be in the future"
    ))]
    pub start_time: DateTime<Utc>,

    #[validate(custom(
        function = "validate_end_time",
        message = "end_time must be after start_time"
    ))]
    pub end_time: DateTime<Utc>,

    #[validate(length(min = 1, message = "Enter the game name"))]
    pub name: String,

    #[validate(range(min = 1, message = "Game Max Number must be at least 1"))]
    pub max_number: Option<i32>,

    #[validate(length(min = 1, message = "Enter Game Max price"))]
    pub max_price: Option<String>,

    #[validate(range(min = 0, message = "created by cannot be empty"))]
    pub created_by: i32,
}
#[derive(Debug, Serialize, Deserialize, FromRow, Clone)]
pub struct Game {
    pub id: i32,
    pub uid: String,
    pub name: String,
    pub start_time: NaiveDateTime,
    pub end_time: NaiveDateTime,
    pub max_number: Option<i32>,
    pub max_price: Option<String>,
    pub created_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
    pub status: String,
    pub deleted_at: Option<NaiveDateTime>,
}

#[derive(Serialize, Debug, Clone, Deserialize, sqlx::Decode)]
pub enum GameStatus {
    Pending,
    Active,
    Completed,
    Canceled,
}


#[derive(Debug, Clone, Validate, Deserialize, Iterable, Serialize)]
pub struct  DeleteGameStruct {
    pub deleted_by: i32,
    pub game_id: i32
}

