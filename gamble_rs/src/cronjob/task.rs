use std::result;

use crate::controller::game::daily_game::create_daily_game_from_games;
use crate::controller::game::user_bet::get_user_bet_game_id;
use crate::controller::payments::transition::create_transition;
use crate::controller::{error::Result, game::game_result::create_game_result};
use crate::libs::utils::generate_result;
use crate::models::game::daily_game::DailyGame;
use crate::models::game::game_result::{
    CreateGameResultPayload, GameResult, GameResultType, GameType,
};
use crate::models::game::user_bet::UserBet;
use crate::models::payment_model::tranistion::{TransitionPayload, TransitionType};
use crate::models::statments::CreateStatementPayload;
use crate::models::statments::StatmentType;
use chrono::{Local, NaiveTime, Utc};
use sqlx::{MySql, Pool};
use tokio::time::{sleep, Duration};

// // Process game end logic
// async fn process_end_of_game(db: &MySqlPool, game_id: i32) {
//     // Logic for processing the end of the game, e.g., updating the database
//     println!("Processing game {} as ended.", game_id);
// }

async fn complete_active_games(db: Pool<MySql>) -> Result<()> {
    // Get the current time (ignoring date) to hours, minutes, and seconds
    let current_time_utc = Utc::now();
    let current_time_ist: chrono::DateTime<Utc> =
        current_time_utc + chrono::Duration::hours(5) + chrono::Duration::minutes(30);

    let current_date = current_time_ist.format("%Y-%m-%d").to_string();
    let current_time = current_time_ist.format("%H:%M").to_string();

    println!(
        "\n\n current date time {} - {} \n\n",
        current_date, current_time
    );

    // Update ACTIVE games to COMPLETED if the time part of end_time matches now_time
    let daily_game: Vec<DailyGame> = sqlx::query_as::<_, DailyGame>(
        r#"
            SELECT dg.*
            FROM daily_game dg 
            INNER JOIN games g ON dg.game_id = g.id 
            WHERE dg.status = 'ACTIVE' 
            AND DATE_FORMAT(dg.created_at, '%Y-%m-%d') = ?
            AND TIME(g.end_time) < ?;
        "#,
    )
    .bind(current_date.clone())
    .bind(current_time.clone())
    .fetch_all(&db)
    .await?;

    println!(
        "\n\n result for date: {}, time: {} with daily_game {:?}\n\n",
        current_date, current_time, daily_game
    );

    if daily_game.len() == 0 {
        return Ok(());
    };

    sqlx::query!(
        r#"
            UPDATE daily_game dg 
            INNER JOIN games g ON dg.game_id = g.id 
            SET dg.status = 'COMPLETED' 
            WHERE dg.status = 'ACTIVE' 
            AND DATE_FORMAT(dg.created_at, '%Y-%m-%d') = ?
            AND TIME(g.end_time) < ?;
        "#,
        current_date,
        current_time
    )
    .execute(&db.clone())
    .await?;

    //  step 1: get daily game which is going to end.
    //  step 2: fetch user bet for each daily_game which is going to end.
    //  step 3: Check if there is any result if not than genrate a result.
    //  step 4: Compare each user_bet bidnumber with it's assocciated daily_game.
    //  step 5: After compareing each user_bet than add all to game_result.
    //  step 6: Record game_result in transition & statement.
    // Important work:-
    //  calculate result when no result is provided.
    //  record in tranistion.
    //

    for game in daily_game {
        let user_bet = get_user_bet_game_id(db.clone(), game.id).await?;
        let result: String;
        if let Some(res) = game.result {
            result = res;
        } else {
            result = generate_result(user_bet.clone())?;
            println!(
                "\n\n game result => {}, of game => {}  \n\n",
                result, game.id
            );
            sqlx::query!(
                r#"
                UPDATE daily_game dg 
                SET dg.result = ? 
                WHERE dg.id = ? 
                "#,
                result.clone(),
                game.id
            )
            .execute(&db.clone())
            .await?;
        }
        println!("\n\n result  => {} \n\n", result);
        check_result_with_user_bet(user_bet, result, db.clone()).await?;
    }

    Ok(())
}

async fn check_result_with_user_bet(
    user_bet: Vec<UserBet>,
    result: String,
    db: Pool<MySql>,
) -> Result<()> {
    println!("\n\n game user_bet => {:?}, of   \n\n", user_bet);
    for bet in user_bet {
        match bet.game_type.clone().unwrap().as_str() {
            "JODI" => {
                if bet.bid_number.to_string() == result {
                    let _ = match bet.game_type.clone().unwrap().as_str() {
                        "JODI" => GameType::JODI,
                        "ANDER" => GameType::ANDER,
                        "BAHER" => GameType::BAHER,
                        _ => GameType::JODI,
                    };

                    let winn_amount: String = match bet.game_type.unwrap().as_str() {
                        "JODI" => {
                            let bet_amount = bet.amount.parse::<f32>().unwrap_or(0.0);
                            format!("{}", bet_amount * 95.0)
                        }
                        _ => {
                            let bet_amount = bet.amount.parse::<f32>().unwrap_or(0.0);
                            format!("{}", bet_amount * 9.5)
                        }
                    };

                    sqlx::query(
                        "UPDATE `users`
                            SET `wallet` = CAST(`wallet` AS SIGNED) + ?
                            WHERE `id` = ?;
                            ",
                    )
                    .bind(winn_amount.parse::<i64>().unwrap_or(0))
                    .bind(bet.user_id)
                    .execute(&db)
                    .await?;

                    let tranistion_payload: TransitionPayload = TransitionPayload {
                        user_id: bet.user_id,
                        admin_id: 1,
                        amount: bet.amount,
                        tranisition_type: TransitionType::CREDIT,
                        created_by: 1,
                    };
                    let generated_transistion =
                        create_transition(db.clone(), tranistion_payload).await?;

                    println!("\n\n creating game result ");
                    let game_result_payload = CreateGameResultPayload {
                        game_id: bet.game_id,
                        user_id: bet.user_id,
                        result: GameResultType::WIN,
                        amount: Some(winn_amount),
                        created_by: bet.user_id,
                        daily_game_id: bet.daily_game_id,
                        transition_id: generated_transistion.id,
                    };
                    let _ = create_game_result(db.clone(), game_result_payload).await?;
                } else {
                    let _ = match bet.game_type.unwrap().as_str() {
                        "JODI" => GameType::JODI,
                        "ANDER" => GameType::ANDER,
                        "BAHER" => GameType::BAHER,
                        _ => GameType::JODI,
                    };

                    let tranistion_payload: TransitionPayload = TransitionPayload {
                        user_id: bet.user_id,
                        admin_id: 1,
                        amount: bet.amount.clone(),
                        tranisition_type: TransitionType::DEBIT,
                        created_by: 1,
                    };
                    let generated_transistion =
                        create_transition(db.clone(), tranistion_payload).await?;

                    let game_result_payload = CreateGameResultPayload {
                        amount: Some(bet.amount),
                        game_id: bet.game_id,
                        user_id: bet.user_id,
                        transition_id: generated_transistion.id,
                        result: GameResultType::LOSS,
                        daily_game_id: bet.daily_game_id,
                        created_by: bet.user_id,
                    };
                    create_game_result(db.clone(), game_result_payload).await?;
                }
            }
            "ANDER" => {
                let chars: Vec<char> = result.chars().collect();
                if bet.bid_number.to_string() == chars[0].to_string() {
                    let _ = match bet.game_type.clone().unwrap().as_str() {
                        "JODI" => GameType::JODI,
                        "ANDER" => GameType::ANDER,
                        "BAHER" => GameType::BAHER,
                        _ => GameType::JODI,
                    };

                    let winn_amount: String = match bet.game_type.unwrap().as_str() {
                        "JODI" => {
                            let bet_amount = bet.amount.parse::<f32>().unwrap_or(0.0);
                            format!("{}", bet_amount * 95.0)
                        }
                        _ => {
                            let bet_amount = bet.amount.parse::<f32>().unwrap_or(0.0);
                            format!("{}", bet_amount * 9.5)
                        }
                    };

                    let tranistion_payload: TransitionPayload = TransitionPayload {
                        user_id: bet.user_id,
                        admin_id: 1,
                        amount: bet.amount,
                        tranisition_type: TransitionType::CREDIT,
                        created_by: 1,
                    };
                    let generated_transistion =
                        create_transition(db.clone(), tranistion_payload).await?;

                    let game_result_payload = CreateGameResultPayload {
                        game_id: bet.game_id,
                        user_id: bet.user_id,
                        transition_id: generated_transistion.id,
                        daily_game_id: bet.daily_game_id,
                        result: GameResultType::WIN,
                        amount: Some(winn_amount),
                        created_by: bet.user_id,
                    };
                    create_game_result(db.clone(), game_result_payload).await?;
                } else {
                    let _ = match bet.game_type.unwrap().as_str() {
                        "JODI" => GameType::JODI,
                        "ANDER" => GameType::ANDER,
                        "BAHER" => GameType::BAHER,
                        _ => GameType::JODI,
                    };

                    let tranistion_payload: TransitionPayload = TransitionPayload {
                        user_id: bet.user_id,
                        admin_id: 1,
                        amount: bet.amount.clone(),
                        tranisition_type: TransitionType::DEBIT,
                        created_by: 1,
                    };
                    let generated_transistion =
                        create_transition(db.clone(), tranistion_payload).await?;

                    let game_result_payload = CreateGameResultPayload {
                        game_id: bet.game_id,
                        user_id: bet.user_id,
                        result: GameResultType::LOSS,
                        daily_game_id: bet.daily_game_id,
                        transition_id: generated_transistion.id,
                        amount: Some(bet.amount),
                        created_by: bet.user_id,
                    };
                    let _ = create_game_result(db.clone(), game_result_payload).await?;
                }
            }
            "BAHER" => {
                let chars: Vec<char> = result.chars().collect();
                if bet.bid_number.to_string() == chars[1].to_string() {
                    let _ = match bet.game_type.clone().unwrap().as_str() {
                        "JODI" => GameType::JODI,
                        "ANDER" => GameType::ANDER,
                        "BAHER" => GameType::BAHER,
                        _ => GameType::JODI,
                    };

                    let winn_amount: String = match bet.game_type.unwrap().as_str() {
                        "JODI" => {
                            let bet_amount = bet.amount.parse::<f32>().unwrap_or(0.0);
                            format!("{}", bet_amount * 95.0)
                        }
                        _ => {
                            let bet_amount = bet.amount.parse::<f32>().unwrap_or(0.0);
                            format!("{}", bet_amount * 9.5)
                        }
                    };

                    let tranistion_payload: TransitionPayload = TransitionPayload {
                        user_id: bet.user_id,
                        admin_id: 1,
                        amount: bet.amount,
                        tranisition_type: TransitionType::CREDIT,
                        created_by: 1,
                    };
                    let generated_transistion =
                        create_transition(db.clone(), tranistion_payload).await?;

                    let game_result_payload = CreateGameResultPayload {
                        game_id: bet.game_id,
                        user_id: bet.user_id,
                        result: GameResultType::WIN,
                        transition_id: generated_transistion.id,
                        amount: Some(winn_amount),
                        daily_game_id: bet.daily_game_id,
                        created_by: bet.user_id,
                    };
                    create_game_result(db.clone(), game_result_payload).await?;
                } else {
                    let _ = match bet.game_type.unwrap().as_str() {
                        "JODI" => GameType::JODI,
                        "ANDER" => GameType::ANDER,
                        "BAHER" => GameType::BAHER,
                        _ => GameType::JODI,
                    };

                    let tranistion_payload: TransitionPayload = TransitionPayload {
                        user_id: bet.user_id,
                        admin_id: 1,
                        amount: bet.amount.clone(),
                        tranisition_type: TransitionType::DEBIT,
                        created_by: 1,
                    };
                    let generated_transistion =
                        create_transition(db.clone(), tranistion_payload).await?;

                    let game_result_payload = CreateGameResultPayload {
                        game_id: bet.game_id,
                        user_id: bet.user_id,
                        daily_game_id: bet.daily_game_id,
                        result: GameResultType::LOSS,
                        transition_id: generated_transistion.id,
                        amount: Some(bet.amount.clone()),
                        created_by: bet.user_id,
                    };

                    create_game_result(db.clone(), game_result_payload).await?;
                }
            }
            _ => {}
        }
    }

    Ok(())
}

async fn start_active_games(db: &Pool<MySql>) -> Result<()> {
    // Get the current time (ignoring date) to hours, minutes, and seconds    let current_time_utc = Utc::now();
    let current_time_utc = Utc::now();
    let current_time_ist: chrono::DateTime<Utc> =
        current_time_utc + chrono::Duration::hours(5) + chrono::Duration::minutes(30);

    let current_date = current_time_ist.format("%Y-%m-%d").to_string();
    let current_time = current_time_ist.format("%H:%M").to_string();

    println!(
        "\n\n current date time {} - {} \n\n",
        current_date, current_time
    );

    // Update ACTIVE games to COMPLETED if the time part of end_time matches now_time
    let _ = sqlx::query!(
        r#"
            UPDATE daily_game dg 
            INNER JOIN games g ON dg.game_id = g.id 
            SET dg.status = 'ACTIVE' 
            WHERE dg.status = 'UPCOMING' 
            AND DATE(dg.created_at) = ?
            AND TIME(g.start_time) <= ?;
        "#,
        current_date,
        current_time
    )
    .execute(db)
    .await?;

    Ok(())
}

pub async fn dynamic_scheduler(db: Pool<MySql>) {
    loop {
        log::debug!("i run ever second");
        // Then, complete any ACTIVE games that should be COMPLETED

        // Then, complete any ACTIVE games that should be COMPLETED
        if let Err(e) = complete_active_games(db.clone()).await {
            eprintln!("Failed to update active games to completed: {:?}", e);
        }

        if let Err(e) = start_active_games(&db).await {
            eprintln!("Failed to update active games to completed: {:?}", e);
        }

        // Sleep for 1 second before checking again
        sleep(Duration::from_secs(30)).await;
    }
}

pub async fn daily_scheduler(db: Pool<MySql>) {
    loop {
        // Calculate the time until the next 5 AM
        let now = Local::now();
        let today_5am = now.date().and_time(NaiveTime::from_hms(5, 0, 0)).unwrap();
        let next_5am = if now < today_5am {
            today_5am
        } else {
            // If it's past 5 AM, schedule for the next day
            today_5am + chrono::Duration::days(1)
        };

        let duration_until_next_5am = (next_5am - now).to_std().unwrap();
        println!(
            "Sleeping for {:?} until the next 5 AM",
            duration_until_next_5am
        );

        // Sleep until the next 5 AM
        sleep(duration_until_next_5am).await;

        if let Err(e) = create_daily_game_from_games(db.clone()).await {
            eprintln!("Failed to create daily games: {:?}", e);
        }
    }
}
