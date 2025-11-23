use std::net::SocketAddr;

use crate::config;
use crate::models::{
    auth::{AccessTokenClaims, LoginPayload, RefreshTokenClaims, RegisterPayload, Role},
    user::User,
};
use jsonwebtoken::{encode, EncodingKey, Header};
use sqlx::{query, MySql, Pool};
use uuid::Uuid;

use super::error::{ControllerError, Result};

use crate::libs::auth::{hast_pwd, validate_pwd, ContentToHash};

pub async fn login_user(db: Pool<MySql>, user: LoginPayload) -> Result<User> {
    let user_exist: Option<User> = sqlx::query_as("SELECT * FROM users WHERE mobile = ?;")
        .bind(&user.mobile)
        .fetch_optional(&db)
        .await?;

    match user_exist {
        Some(user_response) => {
            if let Some(password) = &user_response.password {
                if let Ok(result) = validate_pwd(&user.password, password) {
                    if result {
                        Ok(user_response)
                    } else {
                        Err(ControllerError::DataNotFound(String::from(
                            "Incorrect password",
                        )))
                    }
                } else {
                    Err(ControllerError::BcryptError(
                        "Unable to check password".to_string(),
                    ))
                }
            } else {
                Err(ControllerError::DataBase(
                    "Password not found for user".to_string(),
                ))
            }
        }
        None => Err(ControllerError::DataBase(format!(
            "User with mobile number {} does not exist",
            user.mobile
        ))),
    }
}

pub async fn register_user(db: Pool<MySql>, user: RegisterPayload) -> Result<User> {
    let is_exist: Option<User> = sqlx::query_as("SELECT * FROM users WHERE email = ?;")
        .bind(&user.email)
        .fetch_optional(&db)
        .await?;

    if let Some(_) = is_exist {
        return Err(ControllerError::DataBase(format!(
            "Email {} already exist",
            user.email
        )));
    }

    let pwd = ContentToHash {
        content: user.password,
        salt: Uuid::new_v4(),
    };

    if let Ok(hash_password) = hast_pwd(&pwd) {
        let user_role: &str = match user.role.unwrap_or_else(|| Role::NONE) {
            Role::ADMIN => "ADMIN",
            Role::SYSTEM => "SYSTEM",
            Role::WORKER => "WORKER",
            Role::USER => "USER",
            Role::NONE => "NONE",
        };

        let userresponse = query!(
            "INSERT INTO users (email,password,role) VALUES (?, ?, ?);",
            user.email,
            hash_password,
            user_role
        )
        .execute(&db)
        .await?;

        let userid = userresponse.last_insert_id();

        let userdata: Option<User> = sqlx::query_as("SELECT * FROM users WHERE id = ?;")
            .bind(userid)
            .fetch_optional(&db)
            .await?;

        match userdata {
            Some(user) => Ok(user),
            None => Err(ControllerError::DataNotFound("user".to_string())),
        }
    } else {
        return Err(ControllerError::BcryptError(String::from(
            "Unable to hash password",
        )));
    }
}

pub async fn gen_jwt_token(
    data: &User,
    ip_addr: SocketAddr,
    db: Pool<MySql>,
) -> Result<(String, String)> {
    let jwt_secret = config::config::CONFIG.jwt_secret.as_str();
    let jwt_exp = config::config::CONFIG.jwt_exp;

    let access_token = encode(
        &Header::default(),
        &AccessTokenClaims {
            id: data.id.clone(),
            role: data.role.clone(),
            exp: (chrono::Utc::now() + chrono::Duration::minutes(jwt_exp as i64)).timestamp()
                as usize,
        },
        &EncodingKey::from_secret(jwt_secret.as_ref()),
    )?;

    let refresh_token = encode(
        &Header::default(),
        &RefreshTokenClaims {
            id: data.id.clone(),
            role: data.role.clone(),
            ip_addr: ip_addr.to_string().split(":").next().unwrap().to_string(),
            // exp: (chrono::Utc::now()).timestamp() as usize,
            exp: (chrono::Utc::now() + chrono::Duration::days(1 as i64)).timestamp() as usize,
        },
        &EncodingKey::from_secret(jwt_secret.as_ref()),
    )?;

    let _ = sqlx::query("UPDATE users SET refresh_token = ? WHERE id = ?;")
        .bind(&refresh_token)
        .bind(&data.id)
        .execute(&db)
        .await?;

    return Ok((access_token, refresh_token));
}
