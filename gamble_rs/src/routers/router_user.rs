use std::collections::HashMap;

use axum::{
    extract::{FromRef, Path, Query, State},
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post},
    Json, Router,
};
use crate::{
    controller::{
        database_model::{get_all, search_data},
        user::{change_password, controller_create_user, create_demo_user, get_user_by_id, get_user_by_mobile, update_user_by_id},
    },
    libs::{custom_auth::MyCustomBearerAuth, custom_validation::ValidatePayload},
    models::{
        user::{ChangePasswordPayload, CreateUserDemoPayload, CreateUserPayload, UpdateUserPayload, User},
        utils::LimitSearch,
    },
    routers::error::Result,
};
use serde_json::json;
use sqlx::{MySql, Pool};
use crate::models::utils::ApiResponse;


#[derive(Clone, FromRef)]
struct AppState {
    db: Pool<MySql>,
}

pub fn routes(db: Pool<MySql>) -> Router {
    let app_state = AppState { db };

    Router::new()
        .route("/:id", get(get_user).put(update_user))
        .route("/create", post(create_user))
        .route("/change_pass", post(change_user_password))
        .route("/create_demo", post(create_demo))
        .route("/number/:mobile", get(get_by_mobile))
        .route("/role/:role", post(get_user_by_role))
        .route("/get", post(get_all_user))
        .with_state(app_state)
}

async fn create_demo(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateUserDemoPayload>,
) -> Result<Json<ApiResponse>> {
    println!("->> {:<12}  -- create_demo_user", "ROUTE_HANDLER");
    let data: User = create_demo_user(db.db, payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User Created Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };
    Ok(Json(response))
}

async fn get_user(
    // MyCustomBearerAuth(token): MyCustomBearerAuth,
    State(db): State<AppState>,
    Path(id): Path<i32>,
) -> Result<Json<ApiResponse>> {
    let data: User = get_user_by_id(db.db, id).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User get Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };
    Ok(Json(response))
}

async fn update_user(
    // MyCustomBearerAuth(token): MyCustomBearerAuth,
    State(db): State<AppState>,
    Path(id): Path<i32>,
    ValidatePayload(payload): ValidatePayload<UpdateUserPayload>
) -> Result<Json<ApiResponse>> {
    let data: User = update_user_by_id(db.db, id, payload).await?;
    
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User update Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };
    Ok(Json(response))
}

async fn get_by_mobile(
    // MyCustomBearerAuth(token): MyCustomBearerAuth,
    State(db): State<AppState>,
    Path(mobile): Path<i64>,
) -> Result<Json<ApiResponse>> {
    let data: User = get_user_by_mobile(db.db, mobile).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User get Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };

    Ok(Json(response))
}

async fn get_all_user(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<LimitSearch>,
) -> Result<impl IntoResponse> {
    println!("------------- get all users handler -------------");

    println!("{:?}", payload);

    let res: Vec<User> = get_all(db.db, "users".to_string(), payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "All users get successfully".to_string(),
        data: Some(json!(res)),
        status: true,
    };

    Ok(Json(response))
}

async fn create_user(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<CreateUserPayload>,
) -> Result<Json<ApiResponse>> {
    let data: User = controller_create_user(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "User Created Succesufll".to_string(),
        data: Some(json!(data)),
        status: true,
    };

    Ok(Json(response))
}

async fn change_user_password(
    State(db): State<AppState>,
    ValidatePayload(payload): ValidatePayload<ChangePasswordPayload>,
) -> Result<Json<ApiResponse>> {
    let data: User = change_password(db.db, payload).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Password changed".to_string(),
        data: Some(json!(data)),
        status: true,
    };

    Ok(Json(response))
}

async fn get_user_by_role(
    State(db): State<AppState>,
    Path(role): Path<String>,
    ValidatePayload(payload): ValidatePayload<LimitSearch>,
) -> Result<Json<ApiResponse>> {
    let mut data = HashMap::new();
    data.insert("role".to_string(), role.to_uppercase());
    
    let res: Vec<User> = search_data(db.db, "users".to_string(), data, payload).await?;
    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: "Users get successfully".to_string(),
        data: Some(json!(res)),
        status: true,
    };

    Ok(Json(response))
}
