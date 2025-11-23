use chrono::{DateTime, NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow, MySql, Pool};
use validator::Validate;

use super::{
    game::{daily_game::DailyGame, game_result::GameResult, games::Game, user_bet::UserBet},
    payment_model::{payments::Status, withdraw_request::WithdrawalRequest},
    user::User,
};

#[derive(Serialize, Debug, Deserialize, FromRow)]
pub struct Statement {
    pub id: i32,
    pub user_id: Option<i32>,
    pub game_id: Option<i32>,
    pub user_bet_id: Option<i32>,
    pub game_result_id: Option<i32>,
    pub money_deposite_id: Option<i32>,
    pub withdraw_request_id: Option<i32>,
    pub daily_game_id: Option<i32>,
    pub created_by: i32,
    pub created_at: DateTime<Utc>,
    pub updated_by: Option<i32>,
    pub updated_at: Option<DateTime<Utc>>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<DateTime<Utc>>,
    pub statement_type: String,
    pub status: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StatementWithRelations {
    pub id: i32,
    pub user_id: Option<i32>,
    pub game_id: Option<i32>,
    pub user_bet_id: Option<i32>,
    pub game_result_id: Option<i32>,
    pub money_deposite_id: Option<i32>,
    pub withdraw_request_id: Option<i32>,
    pub daily_game_id: Option<i32>,
    pub created_by: i32,
    pub created_at: DateTime<Utc>,
    pub updated_by: Option<i32>,
    pub updated_at: Option<DateTime<Utc>>,
    pub deleted_by: Option<i32>,
    pub deleted_at: Option<DateTime<Utc>>,
    pub statement_type: String,
    pub status: String,
    pub user: Option<User>,
    pub game: Option<Game>,
    pub user_bet: Option<UserBet>,
    pub game_result: Option<GameResult>,
    pub withdraw_request: Option<WithdrawalRequest>,
    pub daily_game: Option<DailyGame>,
}

impl Statement {
    pub async fn get_statement_with_relations(
        self,
        db: Pool<MySql>,
    ) -> Result<StatementWithRelations, sqlx::Error> {
        // Step 1: Fetch the main `Statement`
        let statement = self;

        // Step 2: Conditionally fetch related data based on IDs in `statement`
        let user: Option<User> = if let Some(user_id) = statement.user_id {
            let fetch_user = query_as("SELECT * FROM users WHERE id = ?")
                .bind(user_id)
                .fetch_one(&db)
                .await?;
            Some(fetch_user)
        } else {
            None
        };

        let game = if let Some(game_id) = statement.game_id {
            Some(
                sqlx::query_as!(Game, r#"SELECT * FROM games WHERE id = ? "#, game_id)
                    .fetch_one(&db)
                    .await?,
            )
        } else {
            None
        };

        let user_bet = if let Some(user_bet_id) = statement.user_bet_id {
            Some(
                query_as(
                    r#" SELECT * FROM user_bet WHERE id = ? "#,
                )
                .bind(user_bet_id)
                .fetch_one(&db)
                .await?,
            )
        } else {
            None
        };

        let withdraw_req: Option<WithdrawalRequest> =
            if let Some(game_result_id) = statement.withdraw_request_id {
                Some(
                    query_as(r#" SELECT * FROM withdrawal_request WHERE id = ? "#)
                        .bind(game_result_id)
                        .fetch_one(&db)
                        .await?,
                )
            } else {
                None
            };
        let daily_game: Option<DailyGame> = if let Some(game_result_id) = statement.daily_game_id {
            Some(
                query_as(r#" SELECT * FROM daily_game WHERE id = ? "#)
                    .bind(game_result_id)
                    .fetch_one(&db)
                    .await?,
            )
        } else {
            None
        };
        let game_result: Option<GameResult> = if let Some(game_result_id) = statement.game_result_id
        {
            Some(
                query_as(r#" SELECT * FROM game_result WHERE id = ? "#)
                    .bind(game_result_id)
                    .fetch_one(&db)
                    .await?,
            )
        } else {
            None
        };

        // Step 3: Combine into the `StatementWithRelations` struct
        let statement_with_relations = StatementWithRelations {
            id: statement.id,         
            user_id: statement.user_id, 
            game_id: statement.game_id,
            user_bet_id: statement.user_bet_id, 
            game_result_id: statement.game_result_id,
            money_deposite_id: statement.money_deposite_id,
            withdraw_request_id: statement.withdraw_request_id,
            daily_game_id: statement.daily_game_id,     
            statement_type: statement.statement_type,
            status: statement.status,
            created_by: statement.created_by, 
            created_at: statement.created_at, 
            updated_by: statement.updated_by, 
            updated_at: statement.updated_at, 
            deleted_by: statement.deleted_by, 
            deleted_at: statement.deleted_at, 
            user,
            game,
            user_bet,
            game_result,
            withdraw_request: withdraw_req,
            daily_game,
        };

        Ok(statement_with_relations)
    }
}

#[derive(Deserialize, Validate)]
pub struct CreateStatementPayload {
    pub user_id: i32,
    pub game_id: Option<i32>,
    pub user_bet_id: Option<i32>,
    pub game_result_id: Option<i32>,
    pub money_deposite_id: Option<i32>,
    pub withdraw_request_id: Option<i32>,
    pub daily_game_id: Option<i32>,
    pub created_by: i32,
    pub statement_type: StatmentType,
}

#[derive(Deserialize, Debug, Validate)]
pub struct SearchStatmentPayload {
    pub id: Option<i32>,
    pub user_id: Option<i32>,
    pub game_id: Option<i32>,
    pub take: i32,
    pub skip: i32,
    pub statement_type: Option<String>,
    pub status: Option<String>,
    pub created_at: Option<NaiveDate>,
}

#[derive(Debug, Deserialize, Serialize)]
pub enum StatmentType {
    WITHDRAW,
    ADD,
    GAME,
    PLAY,
    CASH,
}
