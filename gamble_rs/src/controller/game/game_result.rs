use super::statment::create_statement;
use crate::controller::error::Result;
use crate::{
    controller::database_model::create_data,
    models::{
        game::{
            daily_game::DailyGame,
            game_result::{
                CreateGameResultPayload, GameResult, GameResultSearchPayload, UserGameResult,
            },
            games::Game,
            user_bet::UserBet,
        },
        statments::{CreateStatementPayload, StatmentType},
        utils::LimitSearch,
    },
};
use sqlx::{query_as, MySql, Pool};
use std::collections::HashMap;

pub async fn get_user_game_result(
    db: Pool<MySql>,
    userid: i32,
    limit_search: LimitSearch,
) -> Result<Vec<UserGameResult>> {
    // Fetch `game_result` data first

    let game_results: Vec<GameResult> =
        query_as::<_, GameResult>("SELECT * FROM game_result WHERE user_id = ? LIMIT ? OFFSET ?;")
            .bind(userid)
            .bind(limit_search.take)
            .bind(limit_search.skip)
            .fetch_all(&db)
            .await?;

    let mut results: Vec<UserGameResult> = Vec::new();

    // Fetch related data for each `game_result`
    for game_result in game_results {
        // Fetch related `daily_game`
        let daily_game: DailyGame =
            query_as::<_, DailyGame>("SELECT * FROM daily_game WHERE id = ?")
                .bind(game_result.daily_game_id) // Assuming game_id is the correct linking field
                .fetch_one(&db)
                .await?;

        // Fetch related `game`
        let game: Game = query_as::<_, Game>("SELECT * FROM games WHERE id = ?")
            .bind(daily_game.game_id)
            .fetch_one(&db)
            .await?;

        // Fetch related `user_bet`
        let user_bet: UserBet = query_as::<_, UserBet>(
            "SELECT *
                FROM user_bet
                WHERE daily_game_id = ? AND user_id = ?
                ORDER BY created_at DESC
                LIMIT 1;",
        )
        .bind(daily_game.id)
        .bind(userid)
        .fetch_one(&db)
        .await?;

        // Add to results
        results.push(UserGameResult {
            id: game_result.id,
            game_id: game_result.game_id,
            user_id: game_result.user_id,
            daily_game_id: game_result.daily_game_id,
            result: game_result.result,
            status: game_result.status,
            amount: game_result.amount,
            created_by: game_result.created_by,
            created_at: game_result.created_at,
            updated_by: game_result.updated_by,
            updated_at: game_result.updated_at,
            deleted_by: game_result.deleted_by,
            deleted_at: game_result.deleted_at,
            game,
            user_bet,
            daily_game,
        });
    }
    Ok(results)
}

pub async fn create_game_result(
    db: Pool<MySql>,
    payload: CreateGameResultPayload,
) -> Result<GameResult> {
    // Create a HashMap to insert the data
    let mut data_to_insert: HashMap<String, String> = HashMap::new();

    // Convert fields of CreateGameResultPayload into the HashMap
    data_to_insert.insert("game_id".to_string(), payload.game_id.to_string());
    data_to_insert.insert("user_id".to_string(), payload.user_id.to_string()); // Assuming `GameType` implements `Debug`
    data_to_insert.insert(
        "transition_id".to_string(),
        payload.transition_id.to_string(),
    ); // Assuming `GameType` implements `Debug`
    data_to_insert.insert("result".to_string(), format!("{:?}", payload.result)); // Assuming `GameResultType` implements `Debug`
    data_to_insert.insert(
        "daily_game_id".to_string(),
        format!("{:?}", payload.daily_game_id),
    ); // Assuming `GameResultType` implements `Debug`

    if let Some(amount) = payload.amount {
        data_to_insert.insert("amount".to_string(), amount);
    }

    data_to_insert.insert("created_by".to_string(), payload.created_by.to_string());

    // Serialize data_to_insert to JSON value (for insertion)
    let created_game: GameResult =
        create_data(db.clone(), "game_result".to_string(), data_to_insert).await?;

    let statment_payload = CreateStatementPayload {
        user_id: created_game.user_id,
        game_id: Some(created_game.game_id),
        user_bet_id: None,
        game_result_id: Some(created_game.id),
        money_deposite_id: None,
        withdraw_request_id: None,
        daily_game_id: None,
        created_by: created_game.user_id,
        statement_type: StatmentType::GAME,
    };

    // Insert the statement
    create_statement(db, statment_payload).await?;

    // Return the created game result
    return Ok(created_game);
}

pub async fn search_game_result(
    db: Pool<MySql>,
    payload: GameResultSearchPayload,
) -> Result<Vec<UserGameResult>> {
    // Start with the base query
    let mut query = String::from("SELECT * FROM game_result WHERE 1=1");

    // Dynamically append filters to the query
    if let Some(id) = payload.id {
        query = format!("{} AND id = {}", query, id);
    }
    if let Some(game_id) = payload.game_id {
        query = format!("{} AND game_id = {}", query, game_id);
    }
    if let Some(user_id) = payload.user_id {
        query = format!("{} AND user_id = {}", query, user_id);
    }
    if let Some(daily_game_id) = payload.daily_game_id {
        query = format!("{} AND daily_game_id = {}", query, daily_game_id);
    }
    if let Some(result) = payload.result {
        query = format!("{} AND result = '{}'", query, result);
    }
    if let Some(status) = payload.status {
        query = format!("{} AND status = '{}'", query, status);
    }
    if let Some(amount) = payload.amount {
        query = format!("{} AND amount = '{}'", query, amount);
    }
    if let Some(created_by) = payload.created_by {
        query = format!("{} AND created_by = {}", query, created_by);
    }
    if let Some(start_date) = payload.created_at_start {
        query = format!("{} AND created_at >= '{}'", query, start_date);
    }
    if let Some(end_date) = payload.created_at_end {
        query = format!("{} AND created_at <= '{}'", query, end_date);
    }
    if let Some(updated_by) = payload.updated_by {
        query = format!("{} AND updated_by = {}", query, updated_by);
    }
    if let Some(start_date) = payload.updated_at_start {
        query = format!("{} AND updated_at >= '{}'", query, start_date);
    }
    if let Some(end_date) = payload.updated_at_end {
        query = format!("{} AND updated_at <= '{}'", query, end_date);
    }
    if let Some(deleted_by) = payload.deleted_by {
        query = format!("{} AND deleted_by = {}", query, deleted_by);
    }
    if let Some(start_date) = payload.deleted_at_start {
        query = format!("{} AND deleted_at >= '{}'", query, start_date);
    }
    if let Some(end_date) = payload.deleted_at_end {
        query = format!("{} AND deleted_at <= '{}'", query, end_date);
    }

    println!("\n\n search game_result query => {} \n\n", query);

    // Execute the dynamically built query
    let game_results = sqlx::query_as::<_, GameResult>(&query)
        .fetch_all(&db)
        .await?;

    let mut results: Vec<UserGameResult> = Vec::new();

    // Fetch related data for each `game_result`
    for game_result in game_results {
        // Fetch related `daily_game`
        let daily_game: DailyGame =
            query_as::<_, DailyGame>("SELECT * FROM daily_game WHERE id = ?")
                .bind(game_result.daily_game_id) // Assuming game_id is the correct linking field
                .fetch_one(&db)
                .await?;

        // Fetch related `game`
        let game: Game = query_as::<_, Game>("SELECT * FROM games WHERE id = ?")
            .bind(daily_game.game_id)
            .fetch_one(&db)
            .await?;

        // Fetch related `user_bet`
        let user_bet: UserBet = query_as::<_, UserBet>(
            "SELECT *
                    FROM user_bet
                    WHERE daily_game_id = ? AND user_id = ?
                    ORDER BY created_at DESC
                    LIMIT 1;",
        )
        .bind(daily_game.id)
        .bind(game_result.user_id)
        .fetch_one(&db)
        .await?;

        // Add to results
        results.push(UserGameResult {
            id: game_result.id,
            game_id: game_result.game_id,
            user_id: game_result.user_id,
            daily_game_id: game_result.daily_game_id,
            result: game_result.result,
            status: game_result.status,
            amount: game_result.amount,
            created_by: game_result.created_by,
            created_at: game_result.created_at,
            updated_by: game_result.updated_by,
            updated_at: game_result.updated_at,
            deleted_by: game_result.deleted_by,
            deleted_at: game_result.deleted_at,
            game,
            user_bet,
            daily_game,
        });
    }
    
    Ok(results)
    // Ok(results)
}
