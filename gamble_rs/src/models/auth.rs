use serde::{Deserialize, Serialize};
use validator::Validate;

#[derive(Deserialize, Clone, Debug, Validate)]
pub struct LoginPayload {
    #[validate(length(min = 3, message = "Enter 10 digit Mobile number"))]
    pub mobile: String,
    #[validate(length(min = 3, message = "password must be atleast 3 character long"))]
    pub password: String,
}

#[derive(Deserialize, Debug, Serialize)]
pub struct LoginResponse {
    pub id: i32,
    pub role: String,
    pub token: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AccessTokenClaims {
    pub id: i32,
    pub role: String,
    pub exp: usize,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RefreshTokenClaims {
    pub id: i32,
    pub role: String,
    pub ip_addr: String,
    pub exp: usize,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
pub enum Role {
    SYSTEM,
    ADMIN,
    WORKER,
    USER,
    NONE,
}

#[derive(Debug, Validate, Deserialize)]
pub struct RegisterPayload {
    #[validate(
        email,
        contains(pattern = "gmail", message = "Email must be valid gmail address")
    )]
    pub email: String,

    #[validate(length(min = 3, message = "password must be atleast 3 character long "))]
    pub password: String,

    #[validate(length(min = 3, message = "repassword must be atleast 3 character long "))]
    pub repassword: String,

    #[validate()]
    pub role: Option<Role>,

    #[validate()]
    pub name: Option<String>,

    #[validate()]
    pub mobile_no: Option<i64>,
}

pub struct JwtTokePayload {
    refresh_token: String,
}
