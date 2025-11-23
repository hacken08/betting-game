use std::collections::HashMap;

use jsonwebtoken::crypto::verify;
use sqlx::{query, MySql, Pool};
use uuid::Uuid;

use crate::{
    libs::auth::{hast_pwd, validate_pwd, ContentToHash},
    models::user::{
        ChangePasswordPayload, CreateUserDemoPayload, CreateUserPayload, UpdateUserPayload, User,
    },
};

use super::{
    database_model::update_data,
    error::{ControllerError, Result},
};
// use crate::routers::error::Result;

pub async fn create_demo_user(db: Pool<MySql>, user: CreateUserDemoPayload) -> Result<User> {
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

    let hash_password = hast_pwd(&pwd);

    if let Ok(hash_password) = hash_password {
        let userresponse = query("INSERT INTO users (email,password) VALUE(?, ?);")
            .bind(user.email)
            .bind(hash_password)
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

pub async fn get_user_by_id(db: Pool<MySql>, id: i32) -> Result<User> {
    let is_exist: Option<User> = sqlx::query_as("SELECT * FROM users WHERE id = ?;")
        .bind(&id)
        .fetch_optional(&db)
        .await?;

    if let Some(user) = is_exist {
        Ok(user)
    } else {
        return Err(ControllerError::DataBase("User not exist".to_string()));
    }
}

pub async fn update_user_by_id(
    db: Pool<MySql>,
    id: i32,
    payload: UpdateUserPayload,
) -> Result<User> {
    let mut data: HashMap<String, String> = HashMap::new();

    // Add values from the payload into the data map only if they're present
    if let Some(username) = payload.username {
        data.insert("username".to_string(), username);
    }
    if let Some(email) = payload.email {
        data.insert("email".to_string(), email);
    }
    if let Some(password) = payload.password {
        data.insert("password".to_string(), password);
    }
    if let Some(mobile) = payload.mobile {
        data.insert("mobile".to_string(), mobile.to_string());
    }
    if let Some(wallet) = payload.wallet {
        data.insert("wallet".to_string(), wallet);
    }
    if let Some(role) = payload.role {
        data.insert("role".to_string(), role);
    }
    if let Some(deleted_at) = payload.deleted_at {
        data.insert("deleted_at".to_string(), deleted_at.to_string());
    }
    if let Some(deleted_by) = payload.deleted_by {
        data.insert("deleted_by".to_string(), deleted_by.to_string());
    }
    if let Some(updated_by) = payload.updated_by {
        data.insert("updated_by".to_string(), updated_by.to_string());
    }

    let updated_user: User = update_data(db, "users".to_string(), id, data, id).await?;

    Ok(updated_user)
}

pub async fn get_user_by_mobile(db: Pool<MySql>, mobile: i64) -> Result<User> {
    let is_exist: Option<User> = sqlx::query_as("SELECT * FROM users WHERE mobile = ?;")
        .bind(&mobile)
        .fetch_optional(&db)
        .await?;

    if let Some(user) = is_exist {
        Ok(user)
    } else {
        return Err(ControllerError::DataBase("User not exist".to_string()));
    }
}

pub async fn change_password(db: Pool<MySql>, payload: ChangePasswordPayload) -> Result<User> {
    if payload.new_password != payload.re_type_password {
        return Err(ControllerError::DataNotFound(
            "Re-enter password doesn't match with new password".to_string(),
        ));
    }

    // Step 2: Fetch the current password hash from the database
    let existed_user: Option<User> = sqlx::query_as("SELECT * FROM users WHERE id = ?")
        .bind(payload.user_id)
        .fetch_optional(&db)
        .await?;

    let user: User;

    if let Some(existed) = existed_user {
        user = existed;
    } else {
        return Err(ControllerError::DataNotFound("User not found".to_string()));
    }

    let stored_hash = user.password.unwrap();

    // Step 3: Verify the current password
    if !validate_pwd( &payload.current_password,&stored_hash)? {
        return Err(ControllerError::BcryptError(
            "Your current password is wrong".to_string(),
        ));
    }

    // Step 4: Hash the new password
    let hashed_new_password = hast_pwd(&ContentToHash {
        content: payload.new_password,
        salt: Uuid::new_v4(),
    })?;

    // Step 5: Update the password in the database
    let result = sqlx::query("UPDATE users SET password = ? WHERE id = ?")
        .bind(hashed_new_password)
        .bind(payload.user_id)
        .execute(&db)
        .await?;

    if result.rows_affected() == 0 {
        return Err(ControllerError::DataBase(
            "No rows updated with in table users for password".to_string(),
        ));
    }

    let user: User = get_user_by_id(db, user.id).await?;
    Ok(user)
}

pub async fn controller_create_user(db: Pool<MySql>, user: CreateUserPayload) -> Result<User> {
    // check email exist or not
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

    // check number exist of not
    let is_exist: Option<User> = sqlx::query_as("SELECT * FROM users WHERE mobile = ?;")
        .bind(&user.number)
        .fetch_optional(&db)
        .await?;

    if let Some(_) = is_exist {
        return Err(ControllerError::DataBase(format!(
            "Number {} already exist",
            user.number
        )));
    }

    // hash password
    let pwd = ContentToHash {
        content: user.password,
        salt: Uuid::new_v4(),
    };

    let hash_password = hast_pwd(&pwd)?;

    let userresponse =
        query("INSERT INTO users (email,password,mobile,username,role) VALUE(?, ?, ?, ?, ?);")
            .bind(user.email)
            .bind(hash_password)
            .bind(user.number)
            .bind(user.name)
            .bind(user.role)
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
}
