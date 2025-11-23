pub struct EncryptContent {
    pub content: String,
    pub salt: String,
}
use hmac::{Hmac, Mac};
use rand::Rng;
use sha2::Sha512;
use std::{cmp::Ordering, collections::HashMap};

use crate::{
    controller::{self, error::ControllerError, user},
    libs::error::LibsError,
    models::game::user_bet::UserBet,
};

use super::error::Result;

pub fn encrypt_into_b64u(key: &[u8], enc_content: &EncryptContent) -> Result<String> {
    let EncryptContent { content, salt } = enc_content;

    let mut hmac_sha512 = Hmac::<Sha512>::new_from_slice(key)?;

    hmac_sha512.update(content.as_bytes());
    hmac_sha512.update(salt.as_bytes());

    let hmac_result = hmac_sha512.finalize();
    let result_bytes = hmac_result.into_bytes();

    let result = base64_url::encode(&result_bytes);

    Ok(result)
}

pub fn get_b64u_as_u8s(name: &'static str) -> Result<Vec<u8>> {
    base64_url::decode(name).map_err(|_| LibsError::ConfigWrongFormat)
}




pub fn generate_result(user_bet: Vec<UserBet>) -> Result<String> {
    let mut game_bets: HashMap<String, f32> = HashMap::new(); // Map: bid_number -> total amount

    // Process each bet in user_bet
    for bet in user_bet {
        // Check if the game type is "JODI"
        if let Some(ref game_type) = bet.game_type {
            if game_type == "JODI" {
                // Default to "0" if amount is None
                let amount: f32 = bet
                    .amount
                    .parse::<f32>()
                    .unwrap_or(0.0);

                // Accumulate the amount for the corresponding bid_number
                let entry = game_bets.entry(bet.bid_number).or_insert(0.0);
                *entry += amount;
            }
        }
    }

    // Find the bid_number with the lowest total amount
    let mut lowest_bid_number = None;
    let mut lowest_amount = f32::MAX;

    for (bid_number, total_amount) in game_bets {
        if total_amount < lowest_amount {
            lowest_amount = total_amount;
            lowest_bid_number = Some(bid_number);
        }
    }

    let mut rng = rand::thread_rng();
    let digit_1: i32 = rng.gen_range(0..=9);
    let digit_2: i32 = rng.gen_range(0..=9);

    // Return the result
    match lowest_bid_number {
        Some(bid_number) => Ok(format!("{}", bid_number)),
        None => Ok(format!("{}{}", digit_1, digit_2)),
    }
}
