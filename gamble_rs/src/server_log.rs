use std::time::{SystemTime, UNIX_EPOCH};

use crate::Result;
use axum::http::{Method, Uri};
use serde::Serialize;
use serde_json::json;
use serde_with::skip_serializing_none;
use sqlx::types::Uuid;

#[skip_serializing_none]
#[derive(Serialize)]
struct RequeestLogLine {
    uuid: String,      // uuid string formated
    timestamp: String, // (should be iso8601)

    // -- User and context attributes.
    // user_id: Option<u64>,

    // -- http request attributes.
    req_path: String,
    req_method: String,

    // -- Errors attributes.

    // message: String,
    ip: String,
}

pub async fn log_request(uuid: Uuid, req_method: Method, uri: Uri, ip: String) -> Result<()> {
    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_millis();

    let log_line: RequeestLogLine = RequeestLogLine {
        uuid: uuid.to_string(),
        timestamp: timestamp.to_string(),
        req_path: uri.to_string(),
        req_method: req_method.to_string(),
        ip: ip,
    };

    log::info!("{}", json!(log_line));
    Ok(())
}
