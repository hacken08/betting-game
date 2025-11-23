use std::collections::HashMap;

use axum::extract::{Path, State};
use axum::Json;
use axum::{response::IntoResponse, routing::post, Router};
use hyper::StatusCode;
use serde_json::json;
use sqlx::{mysql::MySql, pool::Pool};
use validator::ValidationError;

use crate::controller::database_model::{create_data, get_count};
use crate::controller::payments::account::{
    fetch_upi_id_for_payment, get_account_by_id, get_all_account, get_all_worker_accounts,
    update_worker_account_status,
};
use crate::ctx::user_ctx::Ctx;
use crate::libs::custom_validation::ValidatePayload;
use crate::models::app_state::AppState;
use crate::models::payment_model::account::{
    CreateAccountPayload, UpdatedAccountStatusPayload, WorkersAccount,
};
use crate::models::payment_model::payments::{validate_type, PaymentType};
use crate::models::utils::{ApiResponse, LimitSearch};
use crate::routers::error::{Result, RouterError};

pub fn routes(db: Pool<MySql>) -> Router {
    let app_state = AppState { db };

    Router::new()
        .route("/get", post(get_all))
        .route("/get/:id", post(get_account))
        .route("/create", post(create_account))
        .route("/live", post(update_worker_status))
        .route("/get_for_payment/:method", post(get_account_for_payments))
        .route("/get_qr", post(create_account))
        .route("/get_bank", post(create_account))
        .route("/update_account_status", post(update_worker_status))
        .route("/get_workers_account/:id", post(worker_account))
        .with_state(app_state)
}

async fn create_account(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateAccountPayload>,
) -> Result<impl IntoResponse> {
    println!("------------- Worker Account create handler -------------");

    println!("{:?}", payload);

    let mut data = HashMap::new();
    data.insert(
        "worker_email".to_string(),
        payload.worker_email.unwrap_or("none".to_string()),
    );
    data.insert("worker_id".to_string(), payload.worker_id.to_string());
    data.insert("gateway_id".to_string(), payload.gateway_id.to_string());
    data.insert(
        "status".to_string(),
        payload.status.unwrap_or("ACTIVE".to_string()),
    );
    data.insert("created_by".to_string(), payload.created_by.to_string());
    data.insert("contact".to_string(), "".to_string());
    data.insert("payment_type".to_string(), payload.payment_type);
    data.insert(
        "qr_image".to_string(),
        payload.qr_image.unwrap_or("none".to_string()),
    );
    data.insert(
        "upi_address".to_string(),
        payload.upi_address.unwrap_or("none".to_string()),
    );
    data.insert(
        "bank_name".to_string(),
        payload.bank_name.unwrap_or("none".to_string()),
    );
    data.insert(
        "account_holder".to_string(),
        payload.account_holder.unwrap_or("none".to_string()),
    );
    data.insert(
        "account_number".to_string(),
        payload.account_number.unwrap_or("none".to_string()),
    );
    data.insert(
        "ifsc_code".to_string(),
        payload.ifsc_code.unwrap_or("none".to_string()),
    );

    let gateway: WorkersAccount = create_data(db.db, "workers_account".to_string(), data).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User get Succesufll".to_string(),
        data: Some(json!(gateway)),
        status: true,
    };

    Ok(Json(response))
}

async fn get_account(State(db): State<AppState>, Path(id): Path<i32>) -> Result<impl IntoResponse> {
    let data: WorkersAccount = get_account_by_id(db.db, id).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Account get Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };
    Ok(Json(response))
}

async fn get_account_for_payments(
    State(db): State<AppState>,
    Path(payment_method): Path<PaymentType>,
) -> Result<impl IntoResponse> {
    // validate_type(&payment_method)?;
    let data: WorkersAccount = fetch_upi_id_for_payment(db.db, payment_method.to_string()).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Account get Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };
    Ok(Json(response))
}

async fn get_all(
    ctx: Ctx,
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<LimitSearch>,
) -> Result<impl IntoResponse> {
    if !(ctx.user_role() == "ADMIN" || ctx.user_role() == "WORKER") {
        return Err(RouterError::UnauthorizedUser);
    }
    let res: Vec<WorkersAccount> = get_all_account(db.db.clone(), payload.clone()).await?;
    let count = get_count::<WorkersAccount>(db.db.clone(), "workers_account".to_string()).await?;

    println!("-----------------------> this is ctx");
    println!("{:?}", ctx);
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "All wokers account get successfully".to_string(),
        data: Some(json!({
            "count":count,
            "take":payload.take,
            "skip":payload.skip,
            "result":res
        })),
        status: true,
    };
    Ok(Json(response))
}

async fn worker_account(
    ctx: Ctx,
    State(db): State<AppState>,
    Path(id): Path<i32>,
) -> Result<impl IntoResponse> {
    println!("\n\n {} \n", ctx.user_role());

    if !(ctx.user_role() == "ADMIN" || ctx.user_role() == "WORKER") {
        return Err(RouterError::UnauthorizedUser);
    }
    let res: Vec<WorkersAccount> = get_all_worker_accounts(db.db.clone(), id).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "All wokers account get successfully".to_string(),
        data: Some(json!(res)),
        status: true,
    };

    Ok(Json(response))
}

async fn update_worker_status(
    // ctx: Ctx,
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<UpdatedAccountStatusPayload>,
) -> Result<impl IntoResponse> {
    println!("-----------------------> update account status router ");
    // if ctx.user_role() != "WORKER" {
    //     return Err(RouterError::UnauthorizedUser);
    // }
    let _res = update_worker_account_status(db.db.clone(), payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "All wokers account get successfully".to_string(),
        data: None,
        status: true,
    };
    Ok(Json(response))
}
