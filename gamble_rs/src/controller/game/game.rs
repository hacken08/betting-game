use crate::{
    controller::database_model::{create_data, get_all_data},
    models::game::games::CreateGamePayload,
};
use sqlx::{MySql, Pool};
use std::collections::HashMap;
use uuid::Uuid;

use crate::{controller::error::Result, models::game::games::Game};

pub async fn create_game(db: Pool<MySql>, payload: CreateGamePayload) -> Result<Game> {
    let mut data_to_insert: HashMap<String, String> = HashMap::new();

    let start_time = payload.start_time.format("%Y-%m-%d %H:%M:%S").to_string();
    let end_time = payload.end_time.format("%Y-%m-%d %H:%M:%S").to_string();

    data_to_insert.insert("start_time".to_string(), start_time);
    data_to_insert.insert("end_time".to_string(), end_time);
    data_to_insert.insert("created_by".to_string(), payload.created_by.to_string());
    data_to_insert.insert("uid".to_string(), Uuid::new_v4().to_string());
    data_to_insert.insert("name".to_string(), payload.name);

    // Conditionally insert optional fields
    if let Some(max_number) = payload.max_number {
        data_to_insert.insert("max_number".to_string(), max_number.to_string());
    }
    if let Some(max_price) = payload.max_price {
        data_to_insert.insert("max_price".to_string(), max_price);
    }

    let created_game: Game = create_data(db, "games".to_string(), data_to_insert).await?;
    return Ok(created_game);
}

pub async fn get_all_game(db: Pool<MySql>) -> Result<Vec<Game>> {
    let all_game: Vec<Game> = get_all_data(db, "games".to_string()).await?;
    return Ok(all_game);
}
