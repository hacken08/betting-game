use crate::controller::{database_model::create_data, error::Result};
use crate::models::game::user_bet::SearUserBetPayload;
use crate::models::statments::{
    CreateStatementPayload, SearchStatmentPayload, StatementWithRelations,
};
use chrono::Utc;
use sqlx::{query_as, MySql, Pool};
use std::collections::HashMap;
use uuid::Uuid;

use crate::models::statments::Statement;

pub async fn create_statement(
    db: Pool<MySql>,
    payload: CreateStatementPayload,
) -> Result<Statement> {
    let mut data_to_insert: HashMap<String, String> = HashMap::new();

    // Required fields
    data_to_insert.insert("created_by".to_string(), payload.created_by.to_string());
    data_to_insert.insert(
        "statement_type".to_string(),
        format!("{:?}", payload.statement_type),
    );

    // Optional fields
    data_to_insert.insert("user_id".to_string(), payload.user_id.to_string());

    if let Some(game_id) = payload.game_id {
        data_to_insert.insert("game_id".to_string(), game_id.to_string());
    }
    if let Some(user_bet_id) = payload.user_bet_id {
        data_to_insert.insert("user_bet_id".to_string(), user_bet_id.to_string());
    }
    if let Some(game_result_id) = payload.game_result_id {
        data_to_insert.insert("game_result_id".to_string(), game_result_id.to_string());
    }
    if let Some(money_deposite_id) = payload.money_deposite_id {
        data_to_insert.insert(
            "money_deposite_id".to_string(),
            money_deposite_id.to_string(),
        );
    }
    if let Some(withdraw_request_id) = payload.withdraw_request_id {
        data_to_insert.insert(
            "withdraw_request_id".to_string(),
            withdraw_request_id.to_string(),
        );
    }
    if let Some(daily_game_id) = payload.daily_game_id {
        data_to_insert.insert("daily_game_id".to_string(), daily_game_id.to_string());
    }

    // Call a helper function to insert the data
    let created_statement = create_data(db, "statement".to_string(), data_to_insert).await?;
    Ok(created_statement)
}

pub async fn get_statement(
    db: Pool<MySql>,
    payload: SearchStatmentPayload,
) -> Result<Vec<StatementWithRelations>> {
    let mut query = String::from("SELECT * FROM statement WHERE 1=1 ");
    let mut params: Vec<(String, String)> = Vec::new();

    // Dynamically build query based on non-null fields in the payload
    if let Some(id) = payload.id {
        query.push_str(" AND id = ?");
        params.push(("id".to_string(), id.to_string()));
    }
    if let Some(user_id) = payload.user_id {
        query.push_str(" AND user_id = ?");
        params.push(("user_id".to_string(), user_id.to_string()));
    }
    if let Some(game_id) = payload.game_id {
        query.push_str(" AND game_id = ?");
        params.push(("game_id".to_string(), game_id.to_string()));
    }
    if let Some(statement_type) = payload.statement_type {
        query.push_str(" AND statement_type = ?");
        params.push(("statement_type".to_string(), statement_type));
    }
    if let Some(status) = payload.status {
        query.push_str(" AND status = ?");
        params.push(("status".to_string(), status));
    }
    if let Some(date) = payload.created_at {
        query.push_str(" AND DATE(created_at) = ?");
        params.push(("DATE(created_at)".to_string(), date.to_string()));
    }

    query.push_str(" LIMIT ? OFFSET ?;");
    print!("\n\n sqlx query => {} \n\n", query);

    // Bind all parameters dynamically
    let mut query_builder = sqlx::query_as::<_, Statement>(&query);
    for (_, value) in params.clone() {
        query_builder = query_builder.bind(value);
    }

    println!("\n\n statment search query  - {} \n", query);
    println!(" statment search params  - {:?} \n\n", params);

    query_builder = query_builder.bind(payload.take).bind(payload.skip);

    // Execute the query
    let result: Vec<Statement> = query_builder.fetch_all(&db).await?;
    let mut related_result: Vec<StatementWithRelations> = Vec::new();

    for statment in result {
        related_result.push(statment.get_statement_with_relations(db.clone()).await?);
    }

    Ok(related_result)
}
