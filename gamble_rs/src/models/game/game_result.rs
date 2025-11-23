use chrono::{DateTime, NaiveDateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::prelude::FromRow;
use validator::{Validate, ValidationError};

use crate::models::user::User;

use super::{daily_game::DailyGame, games::Game, user_bet::UserBet};

#[derive(Debug, Serialize, Deserialize, Clone, FromRow)]
pub struct GameResult {
    pub id: i32,
    pub game_id: i32,
    pub user_id: i32,
    pub daily_game_id: i32,
    pub result: String, // Enum type for result
    pub status: String, // Enum type for status
    pub amount: String, // Optional amount field
    pub created_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
}
#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct UserGameResult {
    pub id: i32,
    pub game_id: i32,
    pub user_id: i32,
    pub daily_game_id: i32,
    pub result: String, // Enum type for result
    pub status: String, // Enum type for status
    pub amount: String, // Optional amount field
    pub created_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
    pub game: Game,
    pub daily_game: DailyGame,
    pub user_bet: UserBet,
}


#[derive(Debug, Serialize, Deserialize, Clone, Validate)]
pub struct GameResultSearchPayload {
    pub id: Option<i32>,                   // Filter by exact ID
    pub game_id: Option<i32>,              // Filter by game ID
    pub user_id: Option<i32>,              // Filter by user ID
    pub daily_game_id: Option<i32>,        // Filter by daily game ID
    pub result: Option<String>,            // Filter by result
    pub status: Option<String>,            // Filter by status
    pub amount: Option<String>,            // Filter by amount
    pub created_by: Option<i32>,           // Filter by created_by
    pub created_at_start: Option<NaiveDateTime>, // Filter by creation date range (start)
    pub created_at_end: Option<NaiveDateTime>,   // Filter by creation date range (end)
    pub updated_by: Option<i32>,           // Filter by updated_by
    pub updated_at_start: Option<NaiveDateTime>, // Filter by update date range (start)
    pub updated_at_end: Option<NaiveDateTime>,   // Filter by update date range (end)
    pub deleted_by: Option<i32>,           // Filter by deleted_by
    pub deleted_at_start: Option<NaiveDateTime>, // Filter by deletion date range (start)
    pub deleted_at_end: Option<NaiveDateTime>,   // Filter by deletion date range (end)
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct CreateGameResultPayload {
    #[validate(range(min = 1, message = "Game ID must be a positive integer"))]
    pub game_id: i32,

    #[validate(range(min = 1, message = "User ID must be a positive integer"))]
    pub user_id: i32,

    // #[validate]
    // pub game_type: GameType,
    pub result: GameResultType,
    pub daily_game_id: i32,

    // #[validate]
    // pub result: GameResultStatus,
    #[validate(range(min = 1, message = "transistion ID must be a positive integer"))]
    pub transition_id: i32,

    // #[validate]
    #[validate(custom(function = "validate_amount"))]
    pub amount: Option<String>,

    #[validate(range(min = 1, message = "Created by must be a positive integer"))]
    pub created_by: i32,
}

// Custom validator function for `amount`
fn validate_amount(amount: &str) -> Result<(), ValidationError> {
    if let Ok(value) = amount.parse::<f64>() {
        if value > 0.0 {
            Ok(())
        } else {
            Err(ValidationError::new("amount must be a positive number"))
        }
    } else {
        Err(ValidationError::new("amount must be a valid number"))
    }
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::Type)]
#[sqlx(type_name = "game_type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum GameType {
    JODI,
    ANDER,
    BAHER,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "game_result_type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum GameResultType {
    WIN,
    LOSS,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "game_status", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum GameStatus {
    ACTIVE,
    INACTIVE,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "result_status", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ResultStatus {
    Pending,
    Active,
    Completed,
    Cancelled,
}
