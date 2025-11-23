use crate::controller::game::game::create_game;
use crate::controller::game::game_result::{
    create_game_result, get_user_game_result, search_game_result,
};
use crate::libs::custom_validation::ValidatePayload;
use crate::models::game::game_result::{
    CreateGameResultPayload, GameResult, GameResultSearchPayload, UserGameResult,
};
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
        // .route("/user/:userId", get(get_by_user_id))
        .route("/search", get(search_data))
        .route("/user/:id", get(user_history))
        .with_state(app_state)
}

async fn create_data(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateGameResultPayload>,
) -> Result<impl IntoResponse> {
    let data = create_game_result(db.db, payload).await?;

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
// async fn get_by_user_id(
//     State(db): State<AppState>,
//     Path(id): Path<i32>,
//     ValidatePayload(limit_param): ValidatePayload<LimitSearch>,
// ) -> Result<impl IntoResponse> {

//     let game_result: Vec<UserGameResult> = get_user_game_result(db.db, id, limit_param).await?;
//     let response: ApiResponse = ApiResponse {
//         code: StatusCode::OK.as_u16(),
//         message: "get by id".to_string(),
//         data: Some(json!(game_result)),
//         status: true,
//     };
//     Ok(Json(response))
// }

async fn getall(State(db): State<AppState>) -> Result<impl IntoResponse> {
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

async fn search_data(
    State(db): State<AppState>,
    Query(payload): Query<GameResultSearchPayload>,
) -> Result<impl IntoResponse> {
    let searched: Vec<UserGameResult> = search_game_result(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "search".to_string(),
        data: Some(json!(searched)),
        status: true,
    };

    Ok(Json(response))
}

async fn user_history(
    State(db): State<AppState>,
    Query(payload): Query<LimitSearch>,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse> {
    let data = get_user_game_result(db.db, id, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "search".to_string(),
        data: Some(json!(data)),
        status: true,
    };

    Ok(Json(response))
}
