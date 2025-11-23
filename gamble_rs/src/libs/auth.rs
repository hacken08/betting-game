use std::sync::OnceLock;

use crate::{config, libs::utils::get_b64u_as_u8s};

use super::error::Result;

use argon2::{
    password_hash::{PasswordHash, PasswordHasher, PasswordVerifier, SaltString},
    Algorithm, Argon2, Params, Version,
};

use uuid::Uuid;

fn get_argon2() -> &'static Argon2<'static> {
    static INSTANCE: OnceLock<Argon2<'static>> = OnceLock::new();
    static PASSWORD_SECRET: OnceLock<Vec<u8>> = OnceLock::new();

    let pass = PASSWORD_SECRET.get_or_init(|| {
        let password_secret = config::config::CONFIG.password_secret.as_str();
        get_b64u_as_u8s(password_secret).unwrap().clone()
    });

    let val = INSTANCE.get_or_init(|| {
        Argon2::new_with_secret(pass, Algorithm::Argon2id, Version::V0x13, Params::default())
            .unwrap() // TODO - needs to fail early
    });

    val
}

pub struct ContentToHash {
    pub content: String,
    pub salt: Uuid,
}

pub fn hast_pwd(to_hash: &ContentToHash) -> Result<String> {
    let argon2 = get_argon2();

    // let salt_b64 =
    //     SaltString::encode_b64(to_hash.salt.as_bytes()).map_err(|_| LibsError::AuthErrro)?;
    let salt_b64 = SaltString::encode_b64(to_hash.salt.as_bytes())?;

    let pwd = argon2
        .hash_password(to_hash.content.as_bytes(), &salt_b64)?
        .to_string();
    Ok(pwd)
}

pub fn validate_pwd(to_hash: &str, pwd_ref: &str) -> Result<bool> {
    let argon2 = get_argon2();

    // let parsed_hash_ref = PasswordHash::new(pwd_ref).map_err(|_| LibsError::KeyFailHmac)?;
    let parsed_hash_ref = PasswordHash::new(pwd_ref)?;

    // let result = argon2
    //     .verify_password(to_hash.as_bytes(), &parsed_hash_ref)
    //     .map_err(|_| LibsError::AuthErrro);
    let result = argon2.verify_password(to_hash.as_bytes(), &parsed_hash_ref);

    match result {
        Ok(()) => Ok(true),
        Err(_) => Ok(false),
    }
}
