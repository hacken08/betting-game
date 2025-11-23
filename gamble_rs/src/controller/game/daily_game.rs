use super::game::get_all_game;
use crate::controller::database_model::{create_multipal_data, get_all_data};
use crate::controller::user;
use crate::models::game::daily_game::{
    DailyGame, DailyGameRelatedGame, DailyGameWithGame, SearchDailyGamePayload,
    UpdateDailyGamePayload,
};
use crate::models::game::user_bet::UserBet;
use crate::{controller::error::Result, models::game::games::Game};
use crate::{
    controller::{database_model::create_data, error::ControllerError},
    models::game::games::CreateGamePayload,
};
use chrono::{Days, NaiveDate, NaiveDateTime, Utc};
use sqlx::query::Query;
use sqlx::{query_as, MySql, Pool};
use std::collections::HashMap;

pub async fn create_daily_game_from_games(db: Pool<MySql>) -> Result<Vec<DailyGame>> {
    let all_games: Vec<Game> = query_as(
        r#"
    SELECT * FROM games WHERE status = "ACTIVE" AND deleted_at is NULL;
    "#,
    )
    .fetch_all(&db)
    .await?;

    if all_games.len() == 0 {
        return Err(ControllerError::DataBase(
            "There is no games in games table".to_string(),
        ));
    }

    // Prepare data for inserting into `daily_game` for each game
    let mut data_list_to_insert = Vec::new();
    for game in all_games {
        let mut data = HashMap::new();
        data.insert("game_id".to_string(), game.id.to_string());
        data.insert("created_by".to_string(), game.created_by.to_string());

        let current_time_utc = Utc::now();
        let current_time_ist: chrono::DateTime<Utc> =
            current_time_utc + chrono::Duration::hours(5) + chrono::Duration::minutes(30);

        let status = if game.start_time.time() > current_time_ist.naive_utc().time() {
            "UPCOMING".to_string()
        } else if game.start_time.time() <= current_time_ist.naive_utc().time()
            && game.end_time.time() > current_time_ist.naive_utc().time()
        {
            "ACTIVE".to_string()
        } else {
            "COMPLETED".to_string()
        };

        data.insert("status".to_string(), status);
        data_list_to_insert.push(data);
    }
    println!("\n data list -> {:?}\n", data_list_to_insert);

    // Insert multiple entries into the `daily_game` table using `create_multiple_data`
    let inserted_daily_games: Vec<DailyGame> =
        create_multipal_data(db, "daily_game", data_list_to_insert).await?;

    Ok(inserted_daily_games)
}

pub async fn get_daily_active_games(db: Pool<MySql>) -> Result<Vec<DailyGameWithGame>> {
    // Step 1: Fetch active daily games
    let daily_games: Vec<DailyGame> = sqlx::query_as(
        r#"
        SELECT 
            id,
            game_id,
            status,
            result,
            created_by,
            created_at,
            updated_by,
            updated_at,
            deleted_by,
            deleted_at
        FROM daily_game
        WHERE status = 'ACTIVE';
        "#,
    )
    .fetch_all(&db)
    .await?;

    if daily_games.is_empty() {
        return Err(ControllerError::DataBase(
            "No active daily games found.".to_string(),
        ));
    }

    // Step 2: Fetch games corresponding to the game_id from the daily games
    let game_ids: Vec<i32> = daily_games.iter().map(|dg| dg.game_id).collect();

    if game_ids.is_empty() {
        return Ok(vec![]); // Return empty result if no game ids are available
    }

    // Step 3: Create a dynamic number of placeholders for the `IN` clause
    let placeholders = game_ids
        .iter()
        .map(|_| "?")
        .collect::<Vec<&str>>()
        .join(", ");

    // Fetch the games corresponding to the game_ids using the `IN` clause
    let query = format!(
        r#"
        SELECT 
            id,
            uid,
            name,
            start_time,
            end_time,
            max_number,
            max_price,
            created_by,
            created_at,
            updated_by,
            updated_at,
            deleted_by,
            status,
            deleted_at
        FROM games
        WHERE id IN ({}); 
        "#,
        placeholders
    );

    // Prepare the query and bind the individual game ids
    let mut query_builder = sqlx::query_as::<_, Game>(&query);

    for game_id in &game_ids {
        query_builder = query_builder.bind(game_id);
    }

    // Execute the query to fetch all games
    let games: Vec<Game> = query_builder.fetch_all(&db).await?;

    // Step 4: Combine the results into DailyGameWithGame structs
    let result: Vec<DailyGameWithGame> = daily_games
        .into_iter()
        .filter_map(|daily_game| {
            // Find the corresponding game for this daily game
            if let Some(game) = games.iter().find(|g| g.id == daily_game.game_id) {
                Some(DailyGameWithGame {
                    daily_game,
                    game: game.clone(), // Clone the game to avoid borrowing issues
                })
            } else {
                None
            }
        })
        .collect();

    Ok(result)
}

pub async fn get_daily_game_by_date(
    fetch_date: NaiveDate,
    db: Pool<MySql>,
) -> Result<Vec<DailyGameRelatedGame>> {
    // Step 1: Fetch active daily games

    println!("\nfetch_date input ->  {}\n", fetch_date);
    let one_day_before = fetch_date.checked_sub_days(Days::new(1)).unwrap();

    // println!("")

    let daily_games: Vec<DailyGameRelatedGame> = sqlx::query_as(
        r#"
        SELECT 
            dlg.id,
            dlg.status,
            dlg.created_by,
            g.uid,
            g.name,
            g.start_time,
            g.end_time,
            g.max_number,
            dlg.result,
            g.max_price
        FROM daily_game dlg
        LEFT JOIN games g ON g.id = dlg.game_id
        WHERE  DATE(dlg.created_at) = ?;
        "#,
        // OR DATE(dlg.created_at) = ?;
    )
    .bind(fetch_date)
    // .bind(one_day_before)
    .fetch_all(&db)
    .await?;

    // if daily_games.is_empty() {
    //     return Err(ControllerError::DataBase(
    //         format!("No active games found for {}.", fetch_date),
    //     ));
    // }

    Ok(daily_games)
}

pub async fn update_daily_game_result(
    db: Pool<MySql>,
    game_id: i32,
    payload: UpdateDailyGamePayload,
) -> Result<DailyGame> {
    if let Some(result) = payload.result.clone() {
        let updated_result = sqlx::query("UPDATE daily_game SET result = ? WHERE id = ?;")
            .bind(result)
            .bind(game_id)
            .execute(&db)
            .await?;
        let fetch_updated_result: DailyGame =
            sqlx::query_as("SELECT * FROM daily_game WHERE id = ?")
                .bind(game_id)
                .fetch_one(&db)
                .await?;
        Ok(fetch_updated_result)
    } else {
        Err(ControllerError::DataNotFound(String::from(
            "Your forget to provide result",
        )))
    }
}

pub async fn cancel_daily_game_result(
    db: Pool<MySql>,
    game_id: i32,
    payload: UpdateDailyGamePayload,
) -> Result<DailyGame> {
    let updated_result = sqlx::query("UPDATE daily_game SET result = ? WHERE id = ?;")
        .bind(None::<String>)
        .bind(game_id)
        .execute(&db)
        .await?;
    let fetch_updated_result: DailyGame = sqlx::query_as("SELECT * FROM daily_game WHERE id = ?")
        .bind(game_id)
        .fetch_one(&db)
        .await?;
    Ok(fetch_updated_result)
}

pub async fn search_daily_game(
    db: Pool<MySql>,
    payload: SearchDailyGamePayload,
) -> Result<Vec<DailyGame>> {
    let mut sql = String::from("SELECT * FROM daily_game WHERE 1=1");

    if let Some(id) = payload.id {
        sql.push_str(&format!(" AND id = {}", id));
    }
    if let Some(game_id) = payload.game_id {
        sql.push_str(&format!(" AND game_id = {}", game_id));
    }
    if let Some(user_id) = payload.result {
        sql.push_str(&format!(" AND user_id = {}", user_id));
    }
    if let Some(game_type) = payload.status {
        sql.push_str(&format!(" AND game_type = '{}'", game_type));
    }
    if let Some(status) = payload.created_by {
        sql.push_str(&format!(" AND status = {}", status));
    }
    if let Some(created_at_after) = payload.created_at {
        sql.push_str(&format!(" AND DATE(created_at) >= {}", created_at_after));
    }

    if let Some(limit) = payload.limit {
        sql.push_str(&format!(" LIMIT {}", limit));
    }
    if let Some(offset) = payload.offset {
        sql.push_str(&format!(" OFFSET {}", offset));
    }

    println!("\n \n {} \n\n", sql);

    let searched_data: Vec<DailyGame> = query_as::<_, DailyGame>(&sql).fetch_all(&db).await?;
    Ok(searched_data)
}
