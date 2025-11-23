use crate::controller::{database_model::create_data, error::Result};
use crate::models::game::user_bet::SearUserBetPayload;
use crate::models::payment_model::tranistion::{Transition, TransitionPayload};
use crate::models::statments::{
    CreateStatementPayload, SearchStatmentPayload, StatementWithRelations,
};
use chrono::Utc;
use sqlx::{query_as, MySql, Pool};
use std::collections::HashMap;
use uuid::Uuid;

use crate::models::statments::Statement;

pub async fn create_transition(db: Pool<MySql>, payload: TransitionPayload) -> Result<Transition> {
    let mut data_to_insert: HashMap<String, String> = HashMap::new();

    // Required fields
    data_to_insert.insert("user_id".to_string(), payload.user_id.to_string());
    data_to_insert.insert("admin_id".to_string(), payload.admin_id.to_string());
    data_to_insert.insert("amount".to_string(), payload.amount.clone());
    data_to_insert.insert(
        "tranisition_type".to_string(),
        format!("{:?}", payload.tranisition_type),
    );
    data_to_insert.insert("created_by".to_string(), payload.created_by.to_string());
    // Insert data into the `transition` table using a helper function
    let create: Transition = create_data(db, "transition".to_string(), data_to_insert).await?;
    return Ok(create);
}

pub async fn get_transistion(
    db: Pool<MySql>,
    payload: SearchStatmentPayload,
) -> Result<Vec<StatementWithRelations>> {
    let mut query = String::from("SELECT * FROM statement WHERE 1=1 ");
    let mut params: Vec<(String, String)> = Vec::new();

    // Dynamically build query based on non-null fields in the payload
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

    query.push_str(" LIMIT ? OFFSET ?;");
    print!("\n\n sqlx query => {} \n\n", query);

    // Bind all parameters dynamically
    let mut query_builder = sqlx::query_as::<_, Statement>(&query);
    for (_, value) in params {
        query_builder = query_builder.bind(value);
    }

    query_builder = query_builder.bind(payload.take).bind(payload.skip);

    // Execute the query
    let result: Vec<Statement> = query_builder.fetch_all(&db).await?;
    let mut related_result: Vec<StatementWithRelations> = Vec::new();

    for statment in result {
        related_result.push(statment.get_statement_with_relations(db.clone()).await?);
    }

    Ok(related_result)
}
