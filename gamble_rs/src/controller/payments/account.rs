use rand::seq::SliceRandom;
use rand::thread_rng;
use sqlx::mysql::MySqlQueryResult;
use sqlx::{MySql, Pool};

use crate::models::payment_model::account::{UpdatedAccountStatusPayload, WorkersAccount};

use crate::controller::error::{ControllerError, Result};
use crate::models::payment_model::payments::PaymentType;
use crate::models::utils::LimitSearch;

pub async fn get_account_by_id(db: Pool<MySql>, id: i32) -> Result<WorkersAccount> {
    let is_exist: Option<WorkersAccount> = sqlx::query_as(
        "
        SELECT workers_account.*, 
            users.email, 
            users.username, 
            users.mobile, 
            users.role, 
            payment_gateway.name, 
            payment_gateway.status AS getway_status, 
            payment_gateway.image 
        FROM `workers_account` 
        LEFT JOIN users ON `workers_account`.`worker_id` = users.id 
        LEFT JOIN payment_gateway ON workers_account.gateway_id = payment_gateway.id 
        WHERE workers_account.deleted_at IS NULL 
            AND workers_account.deleted_by IS NULL 
            AND payment_gateway.deleted_at IS NULL 
            AND payment_gateway.deleted_by IS NULL 
            AND  workers_account.id = ?;",
    )
    .bind(&id)
    .fetch_optional(&db)
    .await?;

    if let Some(user) = is_exist {
        Ok(user)
    } else {
        return Err(ControllerError::DataBase("Getway not exist".to_string()));
    }
}


pub async fn fetch_upi_id_for_payment(
    db: Pool<MySql>,
    payment_method: String,
) -> Result<WorkersAccount> {
    // Fetch active worker accounts for the given payment method
    let fetched_accounts: Vec<WorkersAccount> = sqlx::query_as(
        "
        SELECT * 
        FROM workers_account 
        WHERE status = 'ACTIVE' 
            AND payment_type = ?
            AND deleted_at IS NULL",
    )
    .bind(payment_method)
    .fetch_all(&db)
    .await?;

    // Check if any accounts were fetched
    if fetched_accounts.is_empty() {
        return Err(ControllerError::NoWorkersFound);
    }

    // Select a random account
    let mut rng = thread_rng();
    if let Some(random_account) = fetched_accounts.choose(& mut rng) {
        return Ok(random_account.clone());
    } else {
        Err(ControllerError::NoWorkersFound)
    }
}

pub async fn get_all_account(db: Pool<MySql>, payload: LimitSearch) -> Result<Vec<WorkersAccount>> {
    let accounts: Vec<WorkersAccount> = sqlx::query_as("SELECT workers_account.*, users.email, users.username, users.mobile, users.role, payment_gateway.name, payment_gateway.status AS getway_status, payment_gateway.image FROM `workers_account` LEFT JOIN users ON `workers_account`.`worker_id` = users.id LEFT JOIN payment_gateway ON workers_account.gateway_id = payment_gateway.id WHERE workers_account.deleted_at IS NULL AND workers_account.deleted_by IS NULL AND payment_gateway.deleted_at IS NULL AND payment_gateway.deleted_by IS NULL LIMIT ? OFFSET ?;")
    .bind(&payload.take)
        .bind(&payload.skip)
        .fetch_all(&db)
        .await?;

    if accounts.len() == 0 {
        return Err(ControllerError::DataBase(
            "There are not accounts found".to_string(),
        ));
    }

    Ok(accounts)
}
pub async fn get_all_worker_accounts(db: Pool<MySql>, id: i32) -> Result<Vec<WorkersAccount>> {
    let accounts: Vec<WorkersAccount> = sqlx::query_as("SELECT workers_account.*, users.email, users.username, users.mobile, users.role, payment_gateway.name, payment_gateway.status AS getway_status, payment_gateway.image FROM `workers_account` LEFT JOIN users ON `workers_account`.`worker_id` = users.id LEFT JOIN payment_gateway ON workers_account.gateway_id = payment_gateway.id WHERE workers_account.deleted_at IS NULL AND workers_account.deleted_by IS NULL AND payment_gateway.deleted_at IS NULL AND payment_gateway.deleted_by IS NULL AND workers_account.worker_id = ?;")
    .bind(&id)
        .fetch_all(&db)
        .await?;

    // if accounts.len() == 0 {
    //     return Err(ControllerError::DataBase(
    //         "There are no worker accounts.".to_string(),
    //     ));
    // }
    Ok(accounts)
}
pub async fn update_worker_account_status(
    db: Pool<MySql>,
    payload: UpdatedAccountStatusPayload,
) -> Result<()> {
    let mut sql_query: String;

    if let Some(accoutId) = payload.id {
        sql_query = format!(
            "UPDATE workers_account SET status =  CASE 
                WHEN id = {} THEN '{}'
                ELSE 'INACTIVE' END 
            WHERE worker_id = {} 
            AND gateway_id = {} 
            AND workers_account.deleted_at IS NULL 
            AND workers_account.deleted_by IS NULL;",
            accoutId, payload.status, payload.worker_id, payload.gateway_id
        );
    } else {
        sql_query = format!(
            "UPDATE workers_account SET status = '{}' WHERE workers_account.worker_id = {} AND \
             workers_account.gateway_id = {} AND workers_account.deleted_at IS NULL AND \
             workers_account.deleted_by IS NULL;",
            payload.status, payload.worker_id, payload.gateway_id
        );
    }

    let accounts: MySqlQueryResult = sqlx::query(sql_query.as_str()).execute(&db).await?;

    if accounts.rows_affected() == 0 {
        return Err(ControllerError::DataBase(
            "No records found to update.".to_string(),
        ));
    }

    Ok(())
}
