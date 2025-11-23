use std::collections::HashMap;

use super::super::error::{Result, RouterError};
use crate::controller::database_model::{create_data, search_data, update_status_by_id};
use crate::{
    controller::database_model::{get_all, get_by_id},
    libs::custom_validation::ValidatePayload,
    models::{
        app_state::AppState,
        payment_model::payments::{PaymentGateway, PaymentGatewayCreate},
        utils::{ApiResponse, LimitSearch, StatusUpdate},
    },
};
use argon2::password_hash::rand_core::le;
use axum::{
    extract::{Path, Query, State},
    response::IntoResponse,
    routing::post,
    Json, Router,
};
use hyper::StatusCode;
use serde_json::json;
use sqlx::{MySql, Pool};



pub fn routes(db: Pool<MySql>) -> Router {
    let app_state = AppState { db };

    Router::new()
        .route("/create", post(create_gateway))
        .route("/get/:id", post(get_gateway))
        .route("/get", post(get_all_gateway))
        .route("/status", post(update_gateway_status))
        .route("/type/:type", post(get_gateway_status_by_type))
        .with_state(app_state)
}

async fn create_gateway(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<PaymentGatewayCreate>,
) -> Result<impl IntoResponse> {
    println!("------------- Gateway create handler -------------");

    let mut data = HashMap::new();
    data.insert("name".to_string(), payload.name);
    data.insert("image".to_string(), payload.image);

    if let Some(short_image) = payload.short_image {
        data.insert("short_image".to_string(), short_image);
    }
    data.insert("payment_type".to_string(), payload.payment_type);
    data.insert("status".to_string(), payload.status);
    data.insert("created_by".to_string(), payload.created_by.to_string());

    let gateway: PaymentGateway = create_data(db.db, "payment_gateway".to_string(), data).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User get Succesufll".to_string(),
        data: Some(json!(gateway)),
        status: true,
    };

    Ok(Json(response))
}

async fn get_gateway(State(db): State<AppState>, Path(id): Path<i32>) -> Result<impl IntoResponse> {
    let res: PaymentGateway = get_by_id(db.db, id, "payment_gateway".to_string()).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Payment Gateway get successfully".to_string(),
        data: Some(json!(res)),
        status: true,
    };

    Ok(Json(response))
}

async fn get_all_gateway(
    State(db): State<AppState>,
    Query(payload): Query<LimitSearch>,
) -> Result<impl IntoResponse> {
    println!("------------- Gateway get handler -------------");

    println!("{:?}", payload);

    let res: Vec<PaymentGateway> = get_all(db.db, "payment_gateway".to_string(), payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "All Payment Gateway get successfully".to_string(),
        data: Some(json!(res)),
        status: true,
    };

    Ok(Json(response))
}

async fn update_gateway_status(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<StatusUpdate>,
) -> Result<impl IntoResponse> {
    let res: PaymentGateway = update_status_by_id(
        db.db,
        payload.id,
        "payment_gateway".to_string(),
        payload.status,
        payload.updated_by,
    )
    .await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Payment Gateway status updated successfully".to_string(),
        data: Some(json!(res)),
        status: true,
    };

    Ok(Json(response))
}

async fn get_gateway_status_by_type(
    State(db): State<AppState>,
    Path(gateway_type): Path<String>,
    ValidatePayload(payload): ValidatePayload<LimitSearch>,
) -> Result<impl IntoResponse> {
    println!("{}", gateway_type);

    let mut data = HashMap::new();
    data.insert("payment_type".to_string(), gateway_type);
    let res: Vec<PaymentGateway> =
        search_data(db.db, "payment_gateway".to_string(), data, payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Payment Gateway get successfully".to_string(),
        data: Some(json!(res)),
        status: true,
    };

    Ok(Json(response))
}
