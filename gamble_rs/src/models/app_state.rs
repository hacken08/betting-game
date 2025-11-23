use axum::extract::FromRef;
use sqlx::{MySql, Pool};

#[derive(Clone, FromRef)]
pub struct AppState {
    pub db: Pool<MySql>,
}
