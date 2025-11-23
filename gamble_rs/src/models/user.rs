use chrono::NaiveDateTime;
use regex::Regex;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use validator::{Validate, ValidationError};

#[derive(Debug, Deserialize, Serialize)]
pub enum UserRole {
    SYSTEM,
    ADMIN,
    WORKER,
    USER,
    NONE,
}

impl UserRole {
    // Function to check if the string matches any variant of the enum
    pub fn is_valid(role: &str) -> bool {
        matches!(
            role.to_uppercase().as_str(),
            "SYSTEM" | "ADMIN" | "WORKER" | "USER" | "NONE"
        )
    }
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct User {
    pub id: i32,
    pub username: Option<String>,
    pub email: Option<String>,
    pub password: Option<String>,
    pub mobile: Option<String>,
    pub refresh_token: Option<String>,
    pub otp: Option<String>,
    pub wallet: String,
    pub role: String,
    pub created_at: NaiveDateTime,
    pub created_by: Option<i32>,
    pub updated_at: NaiveDateTime,
    pub updated_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct UpdateUserPayload {
    pub username: Option<String>,
    pub email: Option<String>,
    pub password: Option<String>,
    pub mobile: Option<String>,
    pub refresh_token: Option<String>,
    pub otp: Option<String>,
    pub wallet: Option<String>,
    pub role: Option<String>,
    pub updated_by: Option<i32>,
    pub deleted_at: Option<NaiveDateTime>,
    pub deleted_by: Option<i32>,
}

#[derive(Deserialize, Debug, Validate, Serialize)]
pub struct CreateUserDemoPayload {
    #[validate(custom(function = "validate_password"))]
    pub password: String,

    #[validate(email(message = "Enter a valid email"))]
    pub email: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct SearchUserPayload {
    pub username: Option<String>,
    pub email: Option<String>,
    pub mobile: Option<String>,
    pub role: Option<String>,
    pub updated_by: Option<i32>,
    pub deleted_at_before: Option<NaiveDateTime>,
    pub deleted_at_after: Option<NaiveDateTime>, 
    pub created_at_before: Option<NaiveDateTime>,
    pub created_at_after: Option<NaiveDateTime>, 
    pub sort_by: Option<String>,                 
    pub sort_order: Option<String>,              
    pub limit: Option<u32>,                      
    pub offset: Option<u32>,                     
}

#[derive(Deserialize, Debug, Validate, Serialize)]
pub struct CreateUserPayload {
    #[validate(length(min = 3, message = "Name must be atleast 3 character long"))]
    pub name: String,

    #[validate(email(message = "Enter a valid email"))]
    pub email: String,

    #[validate(custom(
        function = "validate_number",
        message = "Enter a valid 10 digit mobile number"
    ))]
    pub number: String,

    #[validate(custom(function = "validate_password"))]
    pub password: String,

    #[validate(custom(function = "validate_role", message = "Enter a valid Role"))]
    pub role: String,
}

#[derive(Deserialize, Debug, Validate, Serialize)]
pub struct ChangePasswordPayload {
    pub user_id: i32,

    #[validate(custom(function = "validate_password"))]
    pub current_password: String,

    #[validate(custom(function = "validate_password"))]
    pub new_password: String,

    #[validate(custom(function = "validate_password"))]
    pub re_type_password: String,
}

// Validate that the number field is exactly 10 digits
fn validate_number(number: &str) -> Result<(), ValidationError> {
    let re = Regex::new(r"^\d{10}$").unwrap();
    if re.is_match(number) {
        Ok(())
    } else {
        Err(ValidationError::new(
            "Invalid number: must be exactly 10 digits",
        ))
    }
}

// Validate that the role is one of the enum variants as a string
fn validate_role(role: &str) -> Result<(), ValidationError> {
    if UserRole::is_valid(role) {
        Ok(())
    } else {
        Err(ValidationError::new(
            "Invalid role: must be one of SYSTEM, ADMIN, WORKER, USER, or NONE",
        ))
    }
}

// Validate the password field with the 7 rules
fn validate_password(password: &str) -> Result<(), ValidationError> {
    // Length between 8 and 16
    if password.len() < 8 || password.len() > 16 {
        return Err(ValidationError::new(
            "Password must be between 8 and 16 characters long",
        ));
    }

    // Must contain at least one capital letter
    if !password.chars().any(|c| c.is_uppercase()) {
        return Err(ValidationError::new(
            "Password must contain at least one uppercase letter",
        ));
    }

    // Must contain at least one small letter
    if !password.chars().any(|c| c.is_lowercase()) {
        return Err(ValidationError::new(
            "Password must contain at least one lowercase letter",
        ));
    }

    // Must contain at least one number
    if !password.chars().any(|c| c.is_numeric()) {
        return Err(ValidationError::new(
            "Password must contain at least one number",
        ));
    }

    // Must contain at least one special character
    let special_char_re = Regex::new(r"[!@#$%^&*(),.?\:{}|<>]").unwrap();
    if !special_char_re.is_match(password) {
        return Err(ValidationError::new(
            "Password must contain at least one special character",
        ));
    }

    // No spaces allowed
    if password.contains(' ') {
        return Err(ValidationError::new("Password must not contain spaces"));
    }

    // If all checks pass, return Ok
    Ok(())
}
