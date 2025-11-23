use std::collections::HashMap;

use sqlx::{MySql, Pool};

use crate::controller::database_model::create_data;
use crate::controller::error::{ControllerError, Result};
use crate::models::payment_model::account::WorkersAccount;
use crate::models::payment_model::make_deposite::{CreateMoneyDepositePayload, MoneyDeposite};

pub async fn create_deposite(
    db: Pool<MySql>,
    payload: CreateMoneyDepositePayload,
) -> Result<MoneyDeposite> {
    //  check if the worker's account  is active to accept payments
    let worker_account_status: WorkersAccount = sqlx::query_as("SELECT * FROM workers_account WHERE id = ?")
        .bind(payload.worker_id.to_string())
        .fetch_one(&db)
        .await?;

    print!("\n\n fetched status -> {:?}", worker_account_status.status); 
    if (worker_account_status.status != "ACTIVE") {
        return Err(ControllerError::DataBase(String::from("Account is not accepting payments")));
    }

    // Dynamically build query based on non-null fields in the payload
    let mut data_to_insert: HashMap<String, String> = HashMap::new();

    data_to_insert.insert("user_id".to_string(), payload.user_id.to_string());
    data_to_insert.insert("worker_id".to_string(), payload.worker_id.to_string());
    data_to_insert.insert("amount".to_string(), payload.amount.clone());
    data_to_insert.insert("creteded_by".to_string(), "1".to_string());
    data_to_insert.insert("txn_id".to_string(), payload.txn_id.clone());
    data_to_insert.insert(
        "payment_gateway_id".to_string(),
        payload.payment_gateway_id.to_string(),
    );
    data_to_insert.insert(
        "worker_account_id".to_string(),
        payload.worker_account_id.to_string(),
    );
    data_to_insert.insert(
        "payment_screen_shot".to_string(),
        payload.payment_screen_shot.clone(),
    );

    let money_deposite_created: MoneyDeposite =
        create_data(db, "money_deposite".to_string(), data_to_insert).await?;
    return Ok(money_deposite_created);
}
