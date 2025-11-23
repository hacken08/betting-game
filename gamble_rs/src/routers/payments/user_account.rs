use std::collections::HashMap;

use crate::{controller::{
    database_model::create_data,
    payments::{user_accoutn::{create_users_account, get_users_account}, withdrawal_request_controlle::{
        create_withdrawal_request, fetch_withdrawal_request_of_worker,
    }},
}, models::payment_model::user_account::CreateAccountPayload};
use crate::libs::custom_validation::ValidatePayload;
use crate::models::payment_model::withdraw_request::AssignedWorkerRequests;
use crate::models::payment_model::withdraw_request::{
    CreateWithdrawalRequestPayload, WithdrawalRequest,
};
use crate::models::utils::{ApiResponse, LimitSearch};
use crate::routers::error::{Result, RouterError};
use axum::{extract::Path, routing::get};
use axum::Json;
use axum::{extract::State, response::IntoResponse, routing::post, Router};
use hyper::StatusCode;
use serde_json::json;
use sqlx::{MySql, Pool};

#[derive(Clone, Debug)]
struct AppState {
    db: Pool<MySql>,
}

pub fn routes(db: Pool<MySql>) -> Router {
    let app_state = AppState { db };

    Router::new()
        .route("/", post(create))
        .route("/get/:id", get(get_by_id))
        // .route("/get_by_user/:worker_id", post())
        .with_state(app_state)
}

async fn create(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateAccountPayload>,
) -> Result<impl IntoResponse> {
    println!("------------- CREATE - user's account handler -------------");

    let created_users_account = create_users_account(db.db, payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User's account created  Succesufll".to_string(),
        data: Some(json!(created_users_account)),
        status: true,
    };

    Ok(Json(response))
    // Ok("t".into_response())
}

async fn get_by_id(
    State(db): State<AppState>,
    Path(user_id): Path<i32>,
) -> Result<impl IntoResponse> {
    println!("------------- GET - user's account handler -------------");
    let fetched_users_account = get_users_account(db.db, user_id).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User's account get Succesufll".to_string(),
        data: Some(json!(fetched_users_account)),
        status: true,
    };
    Ok(Json(response))
}
