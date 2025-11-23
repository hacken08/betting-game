use sqlx::{mysql::MySqlPoolOptions, MySql, Pool};

pub async fn create_database_connection(database_url: &str) -> Pool<MySql> {
    log::info!("{database_url}");
    
    let pool = MySqlPoolOptions::new()
        .max_connections(50)
        .min_connections(5)
        .connect(database_url)
        .await;
    match pool {
        Ok(db) => {
            log::info!("✅ Connection to the database is successful!");
            db
        }
        Err(err) => {
            log::error!("❌ Failed to connect to the database: {:?}", err);
            std::process::exit(1);
        }
    }
}
