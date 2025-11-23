use crate::controller::game::statment::get_statement;
use crate::libs::custom_validation::ValidatePayload;
use crate::models::statments::StatementWithRelations;
use crate::{
    controller::game::statment::create_statement,
    models::{
        app_state::AppState,
        statments::{CreateStatementPayload, SearchStatmentPayload, Statement},
        utils::ApiResponse,
    },
    routers::error::Result,
};
use axum::extract::Query;
use axum::{
    extract::State,
    response::IntoResponse,
    routing::{get, post},
    Json, Router,
};
use hyper::StatusCode;
use serde_json::json;
use sqlx::{MySql, Pool, Value};

pub fn routes(pool: Pool<MySql>) -> Router {
    let app_state = AppState { db: pool };

    Router::new()
        .route("/", post(create).get(get_statements))
        // .route("/get_by_date", get(get_statements))
        .with_state(app_state)
}

pub async fn create(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateStatementPayload>,
) -> Result<impl IntoResponse> {
    let data: Statement = create_statement(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "statement Created Succesfull".to_string(),
        data: Some(json!(data)),
        status: true,
    };
    Ok(Json(response))
}

pub async fn get_statements(
    State(db): State<AppState>,
    Query(payload): Query<SearchStatmentPayload>,
) -> Result<impl IntoResponse> {
    let searched_statments: Vec<StatementWithRelations> = get_statement(db.db, payload).await?;
    let refactor_data: Vec<serde_json::Value> = Vec::new();

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Statment get successfully".to_string(),
        data: Some(json!(searched_statments)),
        status: true,
    };
    Ok(Json(response))
}
