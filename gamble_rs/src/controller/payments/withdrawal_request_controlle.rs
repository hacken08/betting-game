use crate::{
    controller::{
        database_model::create_data,
        error::{ControllerError, Result}, game::statment::create_statement,
    },
    models::{payment_model::{payments::Status, withdraw_request::{
        AssignedWorkerRequests, CreateWithdrawalRequestPayload, WithdrawalRequest,
        WorkersWithdrawalRequestData,
    }}, statments::{CreateStatementPayload, StatmentType}},
};
use sqlx::{MySql, Pool};
use std::collections::HashMap;

pub async fn create_withdrawal_request(
    db: Pool<MySql>,
    withdraw_payload: CreateWithdrawalRequestPayload,
) -> Result<WithdrawalRequest> {
    let current_active_worker: Vec<AssignedWorkerRequests> = sqlx::query_as(
        "SELECT 
	            u.id, 
                u.role, 
                u.email as worker_email,
                COUNT(wr.id) as total_withdrwal_request_have
            FROM users u
            LEFT JOIN withdrawal_request wr ON wr.worker_id = u.id
            WHERE u.role = 'WORKER'
            GROUP BY u.id, u.email, u.role;",
    )
    .fetch_all(&db)
    .await?;

    let worker_data: Option<&AssignedWorkerRequests> =
        current_active_worker.iter().min_by(|x, y| {
            x.total_withdrwal_request_have
                .cmp(&y.total_withdrwal_request_have)
        });

    let worker_with_less_req = worker_data.ok_or(ControllerError::DataBase(
        "Can't assign request to worker".to_string(),
    ))?;

    let mut data: HashMap<String, String> = HashMap::new();
    data.insert(
        "account_number".to_string(),
        withdraw_payload.account_number.to_string(),
    );
    data.insert("amount".to_string(), withdraw_payload.amount.to_string());
    data.insert("user_id".to_string(), withdraw_payload.user_id.to_string());
    data.insert("created_by".to_string(), "1".to_string());
    data.insert(
        "worker_id".to_string(),
        worker_with_less_req.id.unwrap().to_string(),
    );
    data.insert(
        "bank_name".to_string(),
        withdraw_payload.bank_name.to_string(),
    );
    data.insert(
        "account_holder".to_string(),
        withdraw_payload.account_holder.to_string(),
    );
    data.insert(
        "ifsc_code".to_string(),
        withdraw_payload.ifsc_code.to_string(),
    );
    data.insert("status".to_string(), withdraw_payload.status.to_string());

    let withdrawal_request: WithdrawalRequest =
        create_data(db.clone(), "withdrawal_request".to_string(), data).await?;

    let statment_payload = CreateStatementPayload {
        user_id: withdraw_payload.user_id,
        game_id: None,
        user_bet_id: None,
        game_result_id: None,
        money_deposite_id: None,
        withdraw_request_id: Some(withdrawal_request.id),
        daily_game_id: None,
        created_by: withdraw_payload.user_id,
        statement_type: StatmentType::WITHDRAW,
    };

    create_statement(db, statment_payload).await?;
    return Ok(withdrawal_request);
    // todo!()
}

pub async fn fetch_withdrawal_request_of_worker(
    db: Pool<MySql>,
    worker_id: i32,
) -> Result<Vec<WorkersWithdrawalRequestData>> {
    let withdrawal_requests: Vec<WorkersWithdrawalRequestData> = sqlx::query_as(
        "SELECT 
                u.id as user_id,
                u.email as user_email,
                u.mobile as user_mobile,
                u.username as user_username,
                wr.created_at,
                wr.id,
                wr.bank_name,
                wr.account_holder,
                wr.account_number,
                wr.ifsc_code,
                wr.amount
            FROM withdrawal_request wr 
            LEFT JOIN users u ON wr.user_id = u.id 
            WHERE wr.worker_id = ?;",
    )
    .bind(&worker_id)
    .fetch_all(&db)
    .await?;

    log::info!("{:?}", withdrawal_requests);

    // if accounts.len() == 0 {
    //     return Err(ControllerError::DataBase(
    //         "There are no worker accounts.".to_string(),
    //     ));
    // }
    Ok(withdrawal_requests)
}
