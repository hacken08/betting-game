use sqlx::{query_as, MySql, Pool};
use std::collections::HashMap;
use validator::Validate;

use crate::controller::database_model::create_data;
use crate::controller::error::{ControllerError, Result};
use crate::models::payment_model::account::WorkersAccount;
use crate::models::payment_model::make_deposite::{
    MoneyDeposite, MoneyDepositeSearchPayload, MoneyDepositeWithRelations, PaymentStatus, UpdateMoneyDeposite
};
use crate::models::payment_model::payments::PaymentGateway;
use crate::models::payment_model::user_account::{CreateAccountPayload, UsersAccount};
use crate::models::user::User;

pub async fn create_users_account(
    db: Pool<MySql>,
    payload: CreateAccountPayload,
) -> Result<UsersAccount> {
    let already_exists: Vec<UsersAccount> = sqlx::query_as::<_, UsersAccount>(
        "
        SELECT * FROM users_account WHERE account_number = ?;
    ",
    )
    .bind(payload.account_number.clone())
    .fetch_all(&db)
    .await?;
    println!("\n\n {:?} \n\n", already_exists);

    if already_exists.len() != 0 {
        return Err(ControllerError::DataBase(
            "Account already exists with same account number".to_string(),
        ));
    }

    // Create a HashMap from payload data
    let mut data: HashMap<String, String> = HashMap::new();
    data.insert("user_id".to_string(), payload.user_id.to_string());

    if let Some(bank_name) = &payload.bank_name {
        data.insert("bank_name".to_string(), bank_name.clone());
    }

    if let Some(account_holder) = &payload.account_holder {
        data.insert("account_holder".to_string(), account_holder.clone());
    }

    if let Some(ifsc_code) = &payload.ifsc_code {
        data.insert("ifsc_code".to_string(), ifsc_code.clone());
    }

    if let Some(account_number) = &payload.account_number {
        data.insert("account_number".to_string(), account_number.clone());
    }

    data.insert("status".to_string(), "ACTIVE".to_string());
    if let Some(id) = payload.created_by {
        data.insert("created_by".to_string(), id.to_string());
    }

    // Assuming `create_data` inserts data and returns the created `UsersAccount`
    let created_account: UsersAccount = create_data(db, "users_account".to_string(), data).await?;
    Ok(created_account)
}

pub async fn get_users_account(db: Pool<MySql>, user_id: i32) -> Result<Vec<UsersAccount>> {
    let result: Vec<UsersAccount> = sqlx::query_as(
        "SELECT *
         FROM `users_account` us_a
         LEFT JOIN `users` u ON u.id = us_a.user_id
         WHERE u.id = ?;
        ",
    )
    .bind(user_id)
    .fetch_all(&db)
    .await?;

    Ok(result)
}

pub async fn search_money_deposites(
    pool: Pool<MySql>,
    payload: MoneyDepositeSearchPayload,
) -> Result<Vec<MoneyDepositeWithRelations>> {
    let mut query = String::from("SELECT * FROM money_deposite WHERE 1=1");
    let mut bind_count = 1; // Counter to keep track of parameter position.
    let mut parameters: Vec<String> = Vec::new();

    if let Some(user_id) = payload.user_id {
        query.push_str(&format!(" AND user_id = {}", user_id));
    }
    if let Some(worker_id) = payload.worker_id {
        query.push_str(&format!(" AND worker_id = {}", worker_id));
    }
    if let Some(status) = payload.status {
        query.push_str(&format!(" AND status = '{}'", status));
    }
    if let Some(payment_status) = payload.payment_status {
        query.push_str(&format!(" AND payment_status = '{}'", payment_status));
    }
    if let Some(created_at_start) = payload.created_at_start {
        query.push_str(&format!(" AND created_at >= '{}'", created_at_start));
    }
    if let Some(created_at_end) = payload.created_at_end {
        query.push_str(&format!(" AND created_at <= '{}'", created_at_end));
    }

    println!("\n\n {} \n\n", query);

    // Dynamically bind parameters.
    let mut query = sqlx::query_as::<_, MoneyDeposite>(&query);
    let rows = query.fetch_all(&pool).await?;

    // adding related data
    let mut related_data: Vec<MoneyDepositeWithRelations> = Vec::new();
    for row in rows {
        related_data.push(get_money_deposite_with_relations(pool.clone(), row).await?);
    }

    Ok(related_data)
}

pub async fn get_money_deposite_with_relations(
    pool: Pool<MySql>,
    money_deposite: MoneyDeposite,
) -> Result<MoneyDepositeWithRelations> {
    // Fetch related PaymentGateway
    let payment_gateway: PaymentGateway =
        sqlx::query_as("SELECT * FROM payment_gateway WHERE id = ?")
            .bind(money_deposite.payment_gateway_id)
            .fetch_one(&pool)
            .await?;

    // Fetch related WorkersAccount
    let worker_account: WorkersAccount =
        sqlx::query_as("SELECT * FROM workers_account WHERE id = ?")
            .bind(money_deposite.worker_account_id)
            .fetch_one(&pool)
            .await?;

    // Fetch related Worker (User)
    let worker: User = sqlx::query_as("SELECT * FROM users WHERE id = ?")
        .bind(money_deposite.worker_account_id)
        .fetch_one(&pool)
        .await?;

    // Fetch related User
    let user: User = sqlx::query_as("SELECT * FROM users WHERE id = ?")
        .bind(money_deposite.user_id)
        .fetch_one(&pool)
        .await?;

    // Combine all data into MoneyDepositeWithRelations
    let result = MoneyDepositeWithRelations {
        id: money_deposite.id,
        user_id: money_deposite.user_id,
        worker_id: money_deposite.worker_id,
        amount: money_deposite.amount,
        txn_id: money_deposite.txn_id,
        payment_gateway_id: money_deposite.payment_gateway_id,
        worker_account_id: money_deposite.worker_account_id,
        payment_screen_shot: money_deposite.payment_screen_shot,
        status: money_deposite.status,
        payment_status: money_deposite.payment_status,
        creteded_by: money_deposite.creteded_by,
        created_at: money_deposite.created_at,
        updated_by: money_deposite.updated_by,
        updated_at: money_deposite.updated_at,
        deleted_by: money_deposite.deleted_by,
        deleted_at: money_deposite.deleted_at,
        payment_gateway,
        worker_account,
        worker,
        user,
    };

    Ok(result)
}

pub async fn update_money_deposite(pool: Pool<MySql>, payload: UpdateMoneyDeposite) -> Result<()> {
    let mut query = String::from("UPDATE money_deposite SET ");

    if let Some(status) = &payload.status {
        query.push_str(format!("status = {}", status).as_str());
    }
    if let Some(payment_status) = payload.payment_status {
        query.push_str(format!("payment_status = '{}'", payment_status.to_string()).as_str());
    }
    if let Some(updated_by) = &payload.updated_by {
        query.push_str(format!("updated_by = {}", updated_by).as_str());
    }
    if let Some(deleted_by) = &payload.deleted_by {
        query.push_str(format!("deleted_by = {}", deleted_by).as_str());
    }
    if let Some(worker_id) = &payload.worker_id {
        query.push_str(format!("worker_id = {}", worker_id).as_str());
    }
    query.push_str(format!(" WHERE id = {}", payload.id).as_str());

    print!("\n\n update query for deposites  -> {}", query);
    

    let query = sqlx::query(&query).execute(&pool).await?;

    Ok(())
}
