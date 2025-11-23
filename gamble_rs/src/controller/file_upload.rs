use std::collections::HashMap;
use std::path::Path;

use axum::extract::State;
use axum::{extract::Multipart, http::StatusCode, Json};
use chrono::Utc;
use serde_json::json;
use sqlx::{MySql, Pool};
use tokio::fs::{self};
use tokio::io::AsyncWriteExt;

use crate::controller::database_model::create_data;
use crate::models::file_upload::FileUpload;
use crate::models::utils::{ApiResponse, UploadFile};

use crate::controller::error::{ControllerError, Result};

pub async fn upload_file(
    State(db): State<Pool<MySql>>,
    mut multipart: Multipart,
) -> Result<Json<ApiResponse>> {
    println!("-------- upload file handler ------------");

    let mut upload_file = UploadFile {
        file: None,
        f_type: String::new(),
        userid: 0,
        original_file_name: None,
    };

    while let Some(field) = multipart.next_field().await? {
        let field_name = field.name().unwrap_or("").to_string();
        println!("field: {}", field_name);

        match field_name.as_str() {
            "file" => {
                if let Some(original_file_name) = field.file_name() {
                    println!("{}", original_file_name);
                    upload_file.original_file_name = Some(original_file_name.to_string());
                }

                let data = field.bytes().await?;
                upload_file.file = Some(data);
            }
            "f_type" => {
                upload_file.f_type = field.text().await?;
            }
            "userid" => {
                upload_file.userid = field.text().await?.parse().unwrap_or(0);
            }
            _ => {
                return Err(ControllerError::DataBase("unexpted files".to_string()));
            }
        }
    }

    // Check for missing fields
    if upload_file.file.is_none() || upload_file.f_type.is_empty() || upload_file.userid == 0 {
        return Err(ControllerError::DataBase(
            "some filed is missing".to_string(),
        ));
    }

    let path = match upload_file.f_type.as_str() {
        "payment_gateway" => "payment_gateway",
        _ => "",
    };

    // Get the current Unix timestamp
    let timestamp = Utc::now().timestamp();

    // Extract the file extension from the original file name
    let original_file_name = upload_file.original_file_name.clone().unwrap();
    let extension = Path::new(&original_file_name)
        .extension()
        .and_then(|ext| ext.to_str())
        .ok_or_else(|| ControllerError::DataBase("Unable to extract file extension".to_string()))?;

    // Define the full directory path
    let dir_path = format!("./public/{}", path);

    // Check if the directory exists, and create it if it doesn't
    if !Path::new(&dir_path).exists() {
        fs::create_dir_all(&dir_path).await?; // This will create the directory and all its parent directories
    }

    // Form the new file name
    let file_name = format!("{}/{}.{}", dir_path, timestamp, extension);
    // let file_name = format!("./public/{}/{}.{}", path, timestamp, extension);
    let path = format!("public/{}/{}.{}", path, timestamp, extension);

    // Save the file to disk
    let file_data = upload_file.file.unwrap();
    let mut file = fs::File::create(&file_name).await?;
    file.write_all(&file_data).await?;

    /////////// create data example //////////////

    let mut data = HashMap::new();
    data.insert("name".to_string(), file_name.clone());
    data.insert("userid".to_string(), upload_file.userid.to_string());
    data.insert("file_type".to_string(), upload_file.f_type);
    data.insert("path".to_string(), path.clone());
    data.insert("status".to_string(), "ACTIVE".to_string());
    data.insert("created_by".to_string(), upload_file.userid.to_string());

    let _: FileUpload = create_data(db, "file_uploads".to_string(), data).await?;

    let response: ApiResponse = ApiResponse {
        code: StatusCode::OK.as_u16(),
        message: String::from("Upload Successful"),
        data: Some(json!({
                "upload": true,
                "original_file_name": upload_file.original_file_name, // Return original file name
                "saved_file_name": file_name,
                "path":path // Return saved file name
        })),
        status: true,
    };

    Ok(Json(response))
}
