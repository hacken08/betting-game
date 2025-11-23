use crate::controller::payments::user_accoutn::{search_money_deposites, update_money_deposite};
use crate::libs::custom_validation::ValidatePayload;
use crate::models::payment_model::make_deposite::UpdateMoneyDeposite;
use crate::routers::error::Result;
use crate::{
    controller::payments::{make_deposite::create_deposite, user_accoutn::get_users_account},
    models::{
        payment_model::make_deposite::{CreateMoneyDepositePayload, MoneyDepositeSearchPayload},
        utils::ApiResponse,
    },
};
use axum::routing::put;
use axum::Json;
use axum::{extract::Path, routing::get};
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
        .route("/get-by-id/:id", get(get_by_id))
        .route("/get", post(get_money_deposite))
        .route("/update", post(update_deposite_request))
        // .route("/get_by_user/:worker_id", post())
        .with_state(app_state)
}

async fn create(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateMoneyDepositePayload>,
) -> Result<impl IntoResponse> {
    println!("------------- CREATE - deposite's account handler -------------");

    let deposite_users_account = create_deposite(db.db, payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "deposite request is accepted".to_string(),
        data: Some(json!(deposite_users_account)),
        status: true,
    };
    Ok(Json(response))
}

async fn get_money_deposite(
    State(db): State<AppState>,
    ValidatePayload(search_payload): ValidatePayload<MoneyDepositeSearchPayload>,
) -> Result<impl IntoResponse> {
    println!("------------- GET - search deposite requests handler -------------");
    let fetched_deposites_request = search_money_deposites(db.db, search_payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User's account get Succesufll".to_string(),
        data: Some(json!(fetched_deposites_request)),
        status: true,
    };
    Ok(Json(response))
}

async fn update_deposite_request(
    State(db): State<AppState>,
    ValidatePayload(search_payload): ValidatePayload<UpdateMoneyDeposite>,
) -> Result<impl IntoResponse> {
    println!("------------- UPDATE -  deposite requests handler -------------");
    let fetched_deposites_request = update_money_deposite(db.db, search_payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Deposite request data is updated".to_string(),
        data: Some(json!(fetched_deposites_request)),
        status: true,
    };
    Ok(Json(response))
}

async fn get_by_id(
    State(db): State<AppState>,
    Path(user_id): Path<i32>,
) -> Result<impl IntoResponse> {
    println!("------------- GET - deposite's account handler -------------");
    let fetched_users_account = get_users_account(db.db, user_id).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User's account get Succesufll".to_string(),
        data: Some(json!(fetched_users_account)),
        status: true,
    };
    Ok(Json(response))
}
