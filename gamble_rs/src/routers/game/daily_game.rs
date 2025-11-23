use crate::controller::game::daily_game::{
    cancel_daily_game_result, create_daily_game_from_games, get_daily_active_games,
    get_daily_game_by_date, search_daily_game, update_daily_game_result,
};
use crate::libs::custom_validation::ValidatePayload;
use crate::models::app_state::AppState;
use crate::models::game::daily_game::{
    DailyGame, DailyGameRelatedGame, SearchDailyGamePayload, UpdateDailyGamePayload,
};
use crate::models::utils::ApiResponse;
use crate::routers::error::Result;
use axum::extract::Query;
use axum::{
    extract::{Path, State},
    response::IntoResponse,
    routing::{get, post},
    Json, Router,
};
use chrono::{Duration, NaiveDate, Utc};
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
        .route("/:id", get(getbyid).delete(delete_data).post(update_data))
        .route("/search", get(search_data))
        .route("/result/:id", post(update_result))
        .route("/status/:id", get(current_status))
        .route("/cancel_result/:id", post(cancel_result))
        .route("/createfromgame", post(createfromgame))
        .route("/getactivegames", get(getactivegames))
        .route("/get-by-date/:date", get(get_by_date))
        .with_state(app_state)
}

async fn createfromgame(State(db): State<AppState>) -> Result<impl IntoResponse> {
    println!("\n -- create game from games ---\n");
    let daily_game = create_daily_game_from_games(db.db).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "All Daily Game Created Succesufull".to_string(),
        data: Some(json!(daily_game)),
        status: true,
    };

    Ok(Json(response))
}

async fn get_by_date(
    Path(fetch_date): Path<String>,
    State(db): State<AppState>,
) -> Result<impl IntoResponse> {
    let date_parser = NaiveDate::parse_from_str;
    let parsed_date = date_parser(&fetch_date, "%Y-%m-%d")?;

    let daily_game: Vec<DailyGameRelatedGame> = get_daily_game_by_date(parsed_date, db.db).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Daily Game data get Succesufull".to_string(),
        data: Some(json!(daily_game)),
        status: true,
    };

    Ok(Json(response))
}

async fn getactivegames(State(db): State<AppState>) -> Result<impl IntoResponse> {
    let daily_game = get_daily_active_games(db.db).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "All Daily Game Created Succesufull".to_string(),
        data: Some(json!(daily_game)),
        status: true,
    };
    Ok(Json(response))
}

async fn create_data(State(db): State<AppState>) -> Result<impl IntoResponse> {
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Game Created Succesufll".to_string(),
        data: None,
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

async fn getall(State(db): State<AppState>) -> Result<impl IntoResponse> {
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "get all".to_string(),
        data: None,
        status: true,
    };

    Ok(Json(response))
}

async fn update_result(
    State(db): State<AppState>,
    Path(id): Path<i32>,
    ValidatePayload(payload): ValidatePayload<UpdateDailyGamePayload>,
) -> Result<impl IntoResponse> {
    log::error!("{id}");
    let update_game: DailyGame = update_daily_game_result(db.db, id, payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "update".to_string(),
        data: Some(json!(update_game)),
        status: true,
    };
    Ok(Json(response))
}

async fn cancel_result(
    State(db): State<AppState>,
    Path(id): Path<i32>,
    ValidatePayload(payload): ValidatePayload<UpdateDailyGamePayload>,
) -> Result<impl IntoResponse> {
    log::error!("{id}");
    let update_game: DailyGame = cancel_daily_game_result(db.db, id, payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "update".to_string(),
        data: Some(json!(update_game)),
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

async fn delete_data(State(db): State<AppState>, Path(id): Path<i32>) -> Result<impl IntoResponse> {
    log::error!("{id}");
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "update".to_string(),
        data: None,
        status: true,
    };

    Ok(Json(response))
}

async fn current_status(
    State(db): State<AppState>,
    Path(payload): Path<String>,
) -> Result<impl IntoResponse> {
    let mut current_date_ist = Utc::now();
    current_date_ist = current_date_ist + Duration::hours(5) + Duration::minutes(30);
    let formatted_date = current_date_ist.format("%Y-%m-%d").to_string();
    println!("\n\n  {} - {} \n\n", formatted_date, payload);
    
    let game_status: DailyGame =   sqlx::query_as(
        "
        SELECT *
        FROM daily_game 
        WHERE DATE(created_at) = ?  AND game_id = ?;
    ",
    )
    .bind(formatted_date)
    .bind(payload)
    .fetch_one(&db.db)
    .await?;

    Ok(format!("{}", game_status.status).into_response())
}

async fn search_data(
    State(db): State<AppState>,
    Query(payload): Query<SearchDailyGamePayload>,
) -> Result<impl IntoResponse> {
    println!("\n\n ---------- HANDLER   - search daily game");
    let data: Vec<DailyGame> = search_daily_game(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "search".to_string(),
        data: Some(json!(data)),
        status: true,
    };

    Ok(Json(response))
}
