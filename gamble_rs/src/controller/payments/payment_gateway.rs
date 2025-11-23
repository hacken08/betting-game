use crate::{
    controller::error::{ControllerError, Result},
    models::payment_model::payments::{PaymentGateway, PaymentGatewayCreate},
};
use sqlx::{query, MySql, Pool};

pub async fn create_payment_gateway(
    db: &Pool<MySql>,
    payload: PaymentGatewayCreate,
) -> Result<PaymentGateway> {
    let new_payment_gateway = query!(
        "INSERT INTO payment_gateway (name,image,payment_type,status,created_by) VALUES (?,?, ?, ? ,?);",
        payload.name,
        payload.image,
        payload.payment_type,
        payload.status,
        payload.created_by
    )
    .execute(db)
    .await?;

    let payment_gateway_id = new_payment_gateway.last_insert_id();
    let inserted_payment_gateway: Option<PaymentGateway> =
        sqlx::query_as("SELECT * FROM payment_gateway WHERE id = ?;")
            .bind(payment_gateway_id)
            .fetch_optional(db)
            .await?;

    match inserted_payment_gateway {
        Some(gateway) => Ok(gateway),
        None => {
            return Err(ControllerError::DataNotFound(String::from("not found")));
        }
    }

    // todo!();
}
