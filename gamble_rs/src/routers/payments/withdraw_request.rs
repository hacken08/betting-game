use std::collections::HashMap;

use crate::controller::{
    database_model::create_data, payments::withdrawal_request_controlle::{create_withdrawal_request, fetch_withdrawal_request_of_worker},
};
use crate::libs::custom_validation::ValidatePayload;
use crate::models::payment_model::withdraw_request::AssignedWorkerRequests;
use crate::models::payment_model::withdraw_request::{
    CreateWithdrawalRequestPayload, WithdrawalRequest,
};
use crate::models::utils::{ApiResponse, LimitSearch};
use crate::routers::error::{Result, RouterError};
use axum::extract::Path;
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
        .route("/create", post(create_withdraw_request))
        .route("/get_workers_requests/:worker_id", post(workers_withdrawal_request))
        .with_state(app_state)
}

async fn create_withdraw_request(
    State(db): State<AppState>,
    ValidatePayload(withdraw_payload): ValidatePayload<CreateWithdrawalRequestPayload>,
) -> Result<impl IntoResponse> {
    println!("------------- CREATE - Withdrawal request handler -------------");

    let created_withdrawal_request = create_withdrawal_request(db.db, withdraw_payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User get Succesufll".to_string(),
        data: Some(json!(created_withdrawal_request)),
        status: true,
    };

    Ok(Json(response))
    // Ok("t".into_response())
}

async fn workers_withdrawal_request(
    State(db): State<AppState>,
    Path(worker_id): Path<i32>,
) -> Result<impl IntoResponse> {
    println!("------------- GET - Withdrawal request handler -------------");
    let created_withdrawal_request = fetch_withdrawal_request_of_worker(db.db, worker_id).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User get Succesufll".to_string(),
        data: Some(json!(created_withdrawal_request)),
        status: true,
    };
    Ok(Json(response))
}
