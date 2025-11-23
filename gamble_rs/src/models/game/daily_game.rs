use chrono::{NaiveDate, NaiveDateTime};
use serde::{Deserialize, Serialize};
use sqlx::prelude::FromRow;
use validator::{Validate, ValidationError};

use super::games::Game;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct DailyGame {
    pub id: i32,
    pub game_id: i32,
    pub result: Option<String>,
    pub status: String,
    pub created_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct SearchDailyGamePayload {
    pub id: Option<i32>,
    pub game_id: Option<i32>,
    pub result: Option<String>,
    pub status: Option<String>,
    pub created_by: Option<i32>,
    pub created_at: Option<NaiveDate>,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDate>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDate>,
    pub limit: Option<i32>,
    pub offset: Option<i32>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct UpdateDailyGamePayload {
    #[validate(custom(function = "validate_result"))]
    pub result: Option<String>,
    pub status: Option<String>,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDateTime>,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct DailyGameWithGame {
    pub daily_game: DailyGame,
    pub game: Game,
}

#[derive(Debug, FromRow, Deserialize, Serialize)]
pub struct DailyGameRelatedGame {
    // Fields from `daily_game` table
    pub id: i32,
    pub status: String,
    pub created_by: i32,

    // Fields from `games` table
    pub uid: Option<String>,
    pub name: Option<String>,
    pub start_time: Option<NaiveDateTime>,
    pub end_time: Option<NaiveDateTime>,
    pub result: Option<String>,
    pub max_number: Option<i32>,
    pub max_price: Option<String>,
}

fn validate_result(result: &str) -> Result<(), ValidationError> {
    if let Ok(value) = result.parse::<i32>() {
        if value <= 99 {
            Ok(())
        } else {
            Err(ValidationError::new("Result must be in two digits number"))
        }
    } else {
        Err(ValidationError::new("Result must be number"))
    }
}
