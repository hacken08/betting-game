use crate::controller::game::game::create_game;
use crate::controller::game::user_bet::{create_user_bet, get_user_bet_by_date, search_bet_controller};
use crate::libs::custom_validation::ValidatePayload;
use crate::models::game::user_bet::{
    CreateUserBetPayload, SearUserBetPayload, SearchUserBetPayload, UserBet, UserBetWithDailyGame
};
// use crate::controller::game::game::create_game;
// use crate::libs::custom_validation::ValidatePayload;
// use crate::models::game::games::CreateGamePayload;
// use serde_json::json;
use crate::models::utils::ApiResponse;
use crate::models::{app_state::AppState, game::games::CreateGamePayload};
use crate::routers::error::Result;
use axum::extract::Query;
use axum::{
    extract::{Path, State},
    response::IntoResponse,
    routing::{get, post},
    Json, Router,
};
use chrono::NaiveDate;
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
        .route("/get-by-date", post(get_by_date))
        .route("/:id", get(getbyid).delete(delete_data).patch(update_data))
        .route("/search", get(search_user_bet))
        .with_state(app_state)
}

async fn create_data(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateUserBetPayload>,
) -> Result<impl IntoResponse> {
    let data: UserBet = create_user_bet(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User bet Created Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };

    Ok(Json(response))
}

async fn getbyid(State(_): State<AppState>, Path(id): Path<i32>) -> Result<impl IntoResponse> {
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "get by id".to_string(),
        data: None,
        status: true,
    };
    Ok(Json(response))
}

async fn get_by_date(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<SearUserBetPayload>,
) -> Result<impl IntoResponse> {
    let daily_game: Vec<UserBetWithDailyGame> = get_user_bet_by_date(payload, db.db).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Daily Game data get Succesufull".to_string(),
        data: Some(json!(daily_game)),
        status: true,
    };

    Ok(Json(response))
}

async fn getall(State(_): State<AppState>) -> Result<impl IntoResponse> {
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "get all".to_string(),
        data: None,
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

async fn search_user_bet(
    State(db): State<AppState>,
    Query(payload): Query<SearchUserBetPayload>,
) -> Result<impl IntoResponse> {

    let searched_bets: Vec<UserBet> = search_bet_controller(db.db, payload).await?;
    
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "search".to_string(),
        data: Some(json!(searched_bets)),
        status: true,
    };

    Ok(Json(response))
}

// use crate::controller::game::game_result::create_game_result;
// use crate::controller::game::user_bet::create_user_bet;
// use crate::libs::custom_validation::ValidatePayload;
// use crate::models::app_state::AppState;
// use crate::models::game::game_result::CreateGameResultPayload;
// use crate::models::game::games::CreateGamePayload;
// use crate::models::game::user_bet::{CreateUserBetPayload, UserBet};
// use crate::models::utils::ApiResponse;
// use crate::routers::error::{Result, RouterError};
// use axum::{extract::State, response::IntoResponse, routing::post, Json, Router};
// use hyper::StatusCode;
// use serde_json::json;
// use sqlx::{MySql, Pool};

// pub fn routes(db: Pool<MySql>) -> Router {
//     let appState = AppState { db };

//     Router::new()
//         .route("/create", post(create))
//         // .route("/get", post(get))
//         // .route("/update", post(get))
//         .with_state(appState)
// }

// async fn create(
//     State(db): State<AppState>,
//     ValidatePayload(payload): ValidatePayload<CreateUserBetPayload>,
// ) -> Result<impl IntoResponse> {
//     print!(" ----- user bet create  - HANDLER ------");

//     let created_user_bet: UserBet = create_user_bet(db.db, payload).await?;

//     let response: ApiResponse = ApiResponse {
//         code: StatusCode::OK.as_u16(),
//         message: "user bet created successfully".to_string(),
//         data: Some(json!(created_user_bet)),
//         status: true,
//     };

//     Ok(Json(response))
// }

// async fn get(
//     State(db): State<AppState>,
//     ValidatePayload(payload): ValidatePayload<CreateGamePayload>,
// ) -> Result<impl IntoResponse> {
//     Ok("implement get game login here".into_response())
// }

// async fn c(
//     State(db): State<AppState>,
//     ValidatePayload(payload): ValidatePayload<CreateGamePayload>,
// ) -> Result<impl IntoResponse> {
//     Ok("implement update game tabe logic here".into_response())
// }
