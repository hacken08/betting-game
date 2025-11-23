use crate::controller::database_model::{delete_by_id, get_all, get_count};
use crate::controller::game::game::create_game;
use crate::libs::custom_validation::ValidatePayload;
use crate::models::game::games::{DeleteGameStruct, Game};
use crate::models::utils::{ApiResponse, LimitSearch};
use crate::models::{app_state::AppState, game::games::CreateGamePayload};
use crate::routers::error::Result;
use axum::extract::Query;
use axum::{
    extract::{Path, State},
    response::IntoResponse,
    routing::{get, post},
    Json, Router,
};
use chrono::Duration;
use chrono::Utc;
use hyper::StatusCode;
use serde_json::json;
use sqlx::{MySql, Pool};

// get to get data
// post to create data
// delete to delete data
// patch to update single data
// put to update multipal data

pub fn routes(db: Pool<MySql>) -> Router {
    let app_state = AppState { db };
    Router::new()
        .route("/", post(create_data).get(getall))
        .route("/:id", get(getbyid).delete(delete_data).patch(update_data))
        .route("/search", get(search_data))
        .with_state(app_state)
}

async fn create_data(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateGamePayload>,
) -> Result<impl IntoResponse> {
    let data = create_game(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Game Created Succesfull".to_string(),
        data: Some(json!(data)),
        status: true,
    };
    Ok(Json(response))
}

async fn getbyid(State(db): State<AppState>, Path(id): Path<i32>) -> Result<impl IntoResponse> {
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "get by id".to_string(),
        data: None,
        status: true,
    };
    Ok(Json(response))
}

async fn getall(
    State(db): State<AppState>,
    Query(payload): Query<LimitSearch>,
) -> Result<impl IntoResponse> {
    let data: Vec<Game> = get_all(db.db.clone(), "games".to_string(), payload.clone()).await?;
    let count = get_count::<Game>(db.db.clone(), "games".to_string()).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Get all".to_string(),
        data: Some(json!({
            "count":count,
            "take":payload.take,
            "skip":payload.skip,
            "result":data
        })),
        status: true,
    };

    Ok(Json(response))
}

async fn update_data(State(db): State<AppState>, Path(id): Path<i32>) -> Result<impl IntoResponse> {
    log::error!("{id}");

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "update".to_string(),
        data: None,
        status: true,
    };

    Ok(Json(response))
}

async fn delete_data(
    State(db): State<AppState>,
    Query(payload): Query<DeleteGameStruct>,
) -> Result<impl IntoResponse> {
    println!("\n\n payloads {:?} \n\n", payload);
    let mut ist_time = Utc::now();
    ist_time = ist_time + Duration::hours(5) + Duration::minutes(30);

    sqlx::query(
        "
        UPDATE games 
        SET deleted_by = ?, deleted_at = ? WHERE id = ?;
    ",
    )
    .bind(payload.deleted_by)
    .bind(ist_time)
    .execute(&db.db)
    .await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Data deleted successfully".to_string(),
        data: Some(json!(true)),
        status: true,
    };
    Ok(Json(response))
}

async fn search_data(State(db): State<AppState>) -> Result<impl IntoResponse> {
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "search".to_string(),
        data: None,
        status: true,
    };

    Ok(Json(response))
}
