use chrono::{NaiveDate, NaiveDateTime};
use rand::distributions::Open01;
use regex::Regex;
use serde::{Deserialize, Serialize};
use sqlx::{prelude::FromRow, MySql, MySqlPool, Pool};
use strum_macros::EnumString;
use validator::{Validate, ValidationError};

use super::{daily_game::DailyGame, games::Game};

#[derive(Debug, Serialize, Deserialize, Clone, FromRow)]
pub struct UserBet {
    pub id: i32,
    pub game_id: i32,
    pub daily_game_id: i32,
    pub user_id: i32,
    pub game_type: Option<String>, 
    pub bid_number: String,
    pub status: String,         
    pub amount: String, 
    pub created_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
}

#[derive(Debug, Serialize, Deserialize, Clone, FromRow)]
pub struct UserBetWithDailyGame {
    pub id: i32,
    pub game_id: i32,
    pub game: Option<Game>,
    pub daily_game_id: i32,
    pub daily_game: Option<DailyGame>,
    pub user_id: i32,
    pub game_type: Option<String>, 
    pub bid_number: String,
    pub status: String,         
    pub amount: String, 
    pub created_by: i32,
    pub created_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub updated_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct SearchUserBetPayload {
    pub id: Option<i32>,                    
    pub game_id: Option<i32>,               
    pub daily_game_id: Option<i32>,         
    pub user_id: Option<i32>,               
    pub game_type: Option<String>,          
    pub bid_number: Option<String>,         
    pub status: Option<String>,               
    pub created_by: Option<i32>,            
    pub created_at: Option<NaiveDate>,  
    pub updated_by: Option<i32>,            
    pub limit: Option<u32>,                 
    pub offset: Option<u32>,                
}

impl UserBet {
    pub async fn to_user_bet_with_daily_game(
        self,
        pool: &Pool<MySql>,
    ) -> Result<UserBetWithDailyGame, String> {
        
        let mut user_bet_with_daily_game = UserBetWithDailyGame {
            id: self.id,
            game_id: self.game_id,
            daily_game_id: self.daily_game_id,
            user_id: self.user_id,
            game_type: self.game_type,
            bid_number: self.bid_number,
            status: self.status,
            amount: self.amount,
            created_by: self.created_by,
            created_at: self.created_at,
            updated_by: self.updated_by,
            updated_at: self.updated_at,
            deleted_by: self.deleted_by,
            deleted_at: self.deleted_at,
            daily_game: None, 
            game: None,
        };

        
        user_bet_with_daily_game.include_daily_game(pool).await?;
        user_bet_with_daily_game.include_game(pool).await?;

        Ok(user_bet_with_daily_game)
    }
}

impl UserBetWithDailyGame {
    pub async fn include_daily_game(&mut self, pool: &Pool<MySql>) -> Result<bool, String> {
        match sqlx::query_as::<_, DailyGame>("SELECT * FROM daily_game WHERE id = ?")
            .bind(self.daily_game_id)
            .fetch_one(pool)
            .await
        {
            Ok(daily_game) => {
                self.daily_game = Some(daily_game);
                Ok(true)
            }
            Err(e) => Err(format!("Failed to load DailyGame: {}", e)),
        }
    }
    pub async fn include_game(&mut self, pool: &Pool<MySql>) -> Result<bool, String> {
        match sqlx::query_as::<_, Game>("SELECT * FROM games WHERE id = ?")
            .bind(self.game_id)
            .fetch_one(pool)
            .await
        {
            Ok(game) => {
                self.game = Some(game);
                Ok(true)
            }
            Err(e) => Err(format!("Failed to load game: {}", e)),
        }
    }
}


















#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct CreateUserBetPayload {
    #[validate(range(min = 1, message = "Game ID must be a positive integer"))]
    pub daily_game_id: i32,

    #[validate(range(min = 1, message = "User ID must be a positive integer"))]
    pub user_id: i32,

    #[validate(custom(function = "validate_game_type"))]
    pub game_type: GameType,

    #[validate(custom(function = "validate_parse"))]
    pub bid_number: String,

    #[validate(custom(function = "validate_amount"))]
    pub amount: Option<String>,

    #[validate(range(min = 1, message = "Created by must be a positive integer"))]
    pub created_by: i32,
}

#[derive(Debug, Deserialize, Validate)]
pub struct SearUserBetPayload {
    pub user_id: i32,
    pub date: Option<NaiveDate>,
}


fn validate_game_type(game_type: &GameType) -> Result<(), ValidationError> {
    match game_type {
        GameType::JODI | GameType::ANDER | GameType::BAHER => Ok(()),
        _ => Err(ValidationError::new("Invalid game type")),
    }
}

fn validate_parse(value: &String) -> Result<(), ValidationError> {
    if value.parse::<i64>().is_ok() {
        Ok(())
    } else {
        Err(ValidationError::new("Value cannot be parsed"))
    }
}

fn validate_amount(amount: &str) -> Result<(), ValidationError> {
    let re = Regex::new(r"^\d+(\.\d{1,2})?$").unwrap(); 
    if re.is_match(amount) {
        let amount_value: f64 = amount.parse().unwrap_or(0.0);
        if amount_value == 0.0 {
            return Err(ValidationError::new("Amount must be greater than 0"));
        }
        Ok(())
    } else {
        Err(ValidationError::new(
            "Amount must be a valid number (e.g., 100, 99.99)",
        ))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::Type, PartialEq)]
#[sqlx(type_name = "game_type", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum GameType {
    JODI,
    ANDER,
    BAHER,
}
