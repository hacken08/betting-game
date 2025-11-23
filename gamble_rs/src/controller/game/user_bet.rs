use crate::controller;
use crate::controller::error::ControllerError;
use crate::controller::error::Result;
use crate::models::game::games::Game;
use crate::models::game::user_bet::SearchUserBetPayload;
use crate::models::game::user_bet::{GameType, UserBetWithDailyGame};
use crate::models::payment_model::payments::Status;
use crate::models::statments::CreateStatementPayload;
use crate::models::statments::StatmentType;
use crate::models::user::User;
use crate::{
    controller::database_model::{create_data, get_by_id},
    models::game::{
        daily_game::DailyGame,
        user_bet::{CreateUserBetPayload, SearUserBetPayload, UserBet},
    },
};
// use anyhow::Ok;
use chrono::{NaiveDate, Utc};
use sqlx::mysql::MySqlPool;
use sqlx::{query, query_as, MySql, Pool};
use std::collections::HashMap;
use std::time::Instant;

use super::statment::create_statement;

pub async fn create_user_bet(db: Pool<MySql>, payload: CreateUserBetPayload) -> Result<UserBet> {
    // Step 1: Fetch the game_id using the daily_game_id
    let daily_game: DailyGame =
        get_by_id::<DailyGame>(db.clone(), payload.daily_game_id, "daily_game".to_string()).await?;
    let game = get_by_id::<Game>(db.clone(), daily_game.game_id, "games".to_string()).await?;
    let user = get_by_id::<User>(db.clone(), payload.user_id, "users".to_string()).await?;

    if daily_game.status != "ACTIVE".to_string() {
        return Err(ControllerError::DataBase(
            "Game is not available to play".to_string(),
        ));
    }

    if let Some(amount_str) = &payload.amount {
        let wallet_balance = user.wallet.parse::<i32>().unwrap_or(0);
        let bet_amount = amount_str.parse::<i32>().unwrap_or(0);

        if wallet_balance < bet_amount {
            let error = format!(
                "Cannot place bet: you currently have only {}rs in wallet.",
                user.wallet
            );
            return Err(ControllerError::DataBase(error));
        }
    } else {
        // Handle the case where `payload.amount` is `None`
        return Err(ControllerError::DataBase(
            "Cannot place bet: amount is required.".to_string(),
        ));
    }

    let user_bets: Vec<UserBet> = query_as::<_, UserBet>(
        r#"
        SELECT * FROM user_bet 
        WHERE status = 'ACTIVE' AND user_id = ? AND game_id = ? AND daily_game_id = ? AND DATE(created_at) = ?;
        "#,
    )
        .bind(payload.user_id)
        .bind(game.id)
        .bind(daily_game.id)
        .bind(Utc::now().date_naive())
        .fetch_all(&db)
        .await?;

    let mut Jodi_number_total: HashMap<String, f32> = HashMap::new();
    let mut harup1_number_totals: HashMap<String, f32> = HashMap::new();
    let mut harup2_number_totals: HashMap<String, f32> = HashMap::new();

    for bet in user_bets {
        if bet.game_type.clone().unwrap_or("".to_string()) == String::from("JODI") {
            Jodi_number_total.entry(bet.bid_number).or_insert(0.0);
        } else if bet.game_type.unwrap_or("".to_string()) == String::from("ANDER") {
            harup1_number_totals.entry(bet.bid_number).or_insert(0.0);
        } else {
            harup2_number_totals.entry(bet.bid_number).or_insert(0.0);
        }
    }
    // let is_repeate_in_a = harup1_number_totals.contains_key(&payload.bid_number);
    // if payload.game_type == GameType::ANDER  {
    //     let error = format!(
    //         "Cannot place bet: you already bet on {} number",
    //         payload.bid_number
    //     );
    //     return Err(ControllerError::DataBase(error));
    // }
    // let is_repeate_in_b = harup2_number_totals.contains_key(&payload.bid_number);
    // if payload.game_type == GameType::BAHER && is_repeate_in_b {
    //     let error = format!(
    //         "Cannot place bet: you already bet on {} number",
    //         payload.bid_number
    //     );
    //     return Err(ControllerError::DataBase(error));
    // }

    // Step 2: Check constraints only if game type is JODI
    if payload.game_type == GameType::JODI {
        // let is_new_number = !Jodi_number_total.contains_key(&payload.bid_number);
        // if !is_new_number {
        //     let error = format!(
        //         "Cannot place bet: you already bet on {} number",
        //         payload.bid_number
        //     );
        //     return Err(ControllerError::DataBase(error));
        // }

        // Check `max_number` constraint
        if let Some(max_number) = game.max_number {
            let distinct_number_count = Jodi_number_total.len();

            // Convert `distinct_number_count` to `i32` safely
            let distinct_number_count_i32 = distinct_number_count as i32;
            let remaining_numbers = max_number - distinct_number_count_i32;

            println!(
                "\n max_number = {}, noOfBetsOfUser = {:?} \n",
                max_number, Jodi_number_total
            );

            // If a new number would exceed the max, inform the user
            if remaining_numbers <= 0 {
                let error = format!(
                    "Cannot place bet: you can only bet on {} unique number(s).",
                    max_number
                );
                return Err(ControllerError::DataBase(error));
            }
        }

        // Check `max_price` constraint for the specific number
        if let Some(max_price_str) = game.max_price {
            // Parse max_price if it's present, otherwise default to 0
            let max_price = max_price_str.parse::<f32>().unwrap_or(0.0);
            let current_total = Jodi_number_total
                .get(&payload.bid_number)
                .cloned()
                .unwrap_or(0.0);
            let remaining_amount = max_price - current_total;

            // Parse payload.amount if present, otherwise default to 0
            let bet_amount = payload
                .amount
                .as_deref()
                .unwrap_or("0")
                .parse::<f32>()
                .unwrap_or(0.0);

            // If the new bet amount exceeds the allowed limit, reject it with a message
            if bet_amount > remaining_amount {
                let error = format!(
                    "Cannot place bet: you can only bet up to {} more on number {}",
                    remaining_amount, payload.bid_number
                );
                return Err(ControllerError::DataBase(error));
            }
        }
    }

    // Step 2: Construct data_to_insert HashMap
    let mut data_to_insert: HashMap<String, String> = HashMap::new();

    // Insert values into the HashMap for required fields
    data_to_insert.insert("game_id".to_string(), daily_game.game_id.to_string()); // Get game_id from the query
    data_to_insert.insert(
        "daily_game_id".to_string(),
        payload.daily_game_id.to_string(),
    );
    data_to_insert.insert("user_id".to_string(), payload.user_id.to_string());
    data_to_insert.insert("game_type".to_string(), format!("{:?}", payload.game_type)); // Enum to string
    data_to_insert.insert("bid_number".to_string(), payload.bid_number.to_string());
    data_to_insert.insert("status".to_string(), "ACTIVE".to_string()); // Default status is ACTIVE
    data_to_insert.insert(
        "amount".to_string(),
        payload.amount.clone().unwrap_or("0".to_string()),
    ); // Default to "0" if None
    data_to_insert.insert("created_by".to_string(), payload.created_by.to_string());

    //  deducting balance from user wallet
    let bet_amount = payload
        .amount
        .as_deref()
        .unwrap_or("0")
        .parse::<f32>()
        .unwrap_or(0.0);
    //  deducting balance from user wallet
    let wallet = user.wallet.parse::<f32>().unwrap_or(0.0);
    let deducted_amount: f32 = wallet - bet_amount;

    let _ = query(
        "UPDATE users
        SET wallet = ?
        WHERE id = ?",
    )
    .bind(deducted_amount)
    .bind(user.id)
    .execute(&db)
    .await?;

    // Step 3: Insert the data into the user_bet table
    let created_user_bet: UserBet =
        create_data(db.clone(), "user_bet".to_string(), data_to_insert).await?;

    let statment_payload = CreateStatementPayload {
        user_id: payload.user_id,
        game_id: Some(created_user_bet.game_id),
        user_bet_id: Some(created_user_bet.id),
        game_result_id: None,
        money_deposite_id: None,
        withdraw_request_id: None,
        daily_game_id: Some(payload.daily_game_id),
        created_by: payload.user_id,
        statement_type: StatmentType::PLAY,
    };

    create_statement(db, statment_payload).await?;
    Ok(created_user_bet)
}

pub async fn get_user_bet_by_date(
    payload: SearUserBetPayload,
    db: MySqlPool,
) -> Result<Vec<UserBetWithDailyGame>> {
    let mut query = format!(
        "SELECT ub.*
         FROM user_bet ub
            JOIN daily_game dg ON ub.daily_game_id = dg.id
            WHERE dg.status = 'ACTIVE'
            AND ub.user_id = {}
        ",
        payload.user_id,
    );

    if let Some(date) = payload.date {
        println!("\n created ata data  -> {}\n", date);
        query.push_str(format!("AND DATE(ub.created_at) = '{}'", date).as_str());
    }

    let user_bets: Vec<UserBet> = query_as(&query).fetch_all(&db).await?;
    let mut user_bet_with_game: Vec<UserBetWithDailyGame> = Vec::new();

    for bets in user_bets {
        user_bet_with_game.insert(0, bets.to_user_bet_with_daily_game(&db).await.unwrap());
    }

    Ok(user_bet_with_game)
}

pub async fn get_user_bet_game_id(db: Pool<MySql>, daily_game_id: i32) -> Result<Vec<UserBet>> {
    let user_bet: Vec<UserBet> = query_as(
        r#"
        SELECT *
        FROM user_bet ub
        WHERE ub.daily_game_id = ?;
        "#,
    )
    .bind(daily_game_id)
    .fetch_all(&db)
    .await?;

    return Ok(user_bet);
}

pub async fn search_bet_controller(
    db: Pool<MySql>,
    payload: SearchUserBetPayload,
) -> Result<Vec<UserBet>> {
    let mut sql = String::from("SELECT * FROM user_bet WHERE 1=1");

    if let Some(id) = payload.id {
        sql.push_str(&format!(" AND id = {}", id));
    }
    if let Some(game_id) = payload.game_id {
        sql.push_str(&format!(" AND game_id = {}", game_id));
    }
    if let Some(user_id) = payload.user_id {
        sql.push_str(&format!(" AND user_id = {}", user_id));
    }
    if let Some(game_type) = payload.game_type {
        sql.push_str(&format!(" AND game_type = '{}'", game_type));
    }
    if let Some(bid_number) = payload.bid_number {
        sql.push_str(&format!(" AND bid_number = {}", bid_number));
    }
    if let Some(status) = payload.status {
        sql.push_str(&format!(" AND status = {}", status));
    }
    if let Some(created_at_after) = payload.created_at {
        sql.push_str(&format!(" AND DATE(created_at) = '{}'", created_at_after));
    }

    if let Some(limit) = payload.limit {
        sql.push_str(&format!(" LIMIT {}", limit));
    }
    if let Some(offset) = payload.offset {
        sql.push_str(&format!(" OFFSET {}", offset));
    }

    println!("\n \n {} \n\n", sql);

    let searched_data: Vec<UserBet> = query_as::<_, UserBet>(&sql).fetch_all(&db).await?;
    Ok(searched_data)
}
