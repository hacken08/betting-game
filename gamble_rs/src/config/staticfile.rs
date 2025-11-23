use axum::{routing::get_service, Router};
use tower_http::services::ServeDir;

pub fn static_files() -> Router {
    Router::new().nest_service("/public", get_service(ServeDir::new("./public")))
}
