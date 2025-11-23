use crate::routers::mw_auth::mw_require_auth;
use axum::{
    body::Body,
    extract::ConnectInfo,
    http::{Method, Uri},
    middleware,
    response::Response,
    routing::{get, post},
    serve, Json, Router,
};
use config::staticfile::static_files;
use controller::file_upload::upload_file;
use cron_job::CronJob;

use database::utils::index::create_database_connection;
use log::{info, warn};
use models::index::home::HomePage;
use server_log::log_request;
use simple_logger::SimpleLogger;
use sqlx::{MySql, MySqlPool, Pool};
use std::sync::Arc;
use std::{net::SocketAddr, process::exit};
use tokio::time::{sleep, Duration};
use tower_cookies::CookieManagerLayer;
use tower_http::cors::{Any, CorsLayer};
use uuid::Uuid;
mod config;
mod controller;
mod cronjob;
mod ctx;
mod database;
mod error;
mod libs;
mod models;
mod routers;
mod server_log;

use cronjob::task::{daily_scheduler, dynamic_scheduler};

pub use self::error::{AppError, Result};
// The function to be executed.
// async fn create_daily_games(db: Pool<MySql>) {
//     let _ = create_daily_game_from_games(db).await;
// }

#[tokio::main]
async fn main() -> Result<()> {
    // get keys
    // let mut key = [0u8; 64];
    // rand::thread_rng().fill_bytes(&mut key);
    // println!("key for hmac: {:?}", key);

    // let b64u = base64_url::encode(&key);
    // println!("key for hmac: {:?}", b64u);

    let logger = SimpleLogger::new()
        .with_colors(true)
        .without_timestamps()
        .init();

    match logger {
        Ok(_) => {
            info!("Logger init!")
        }
        Err(e) => {
            warn!("{e}");
            exit(1);
        }
    }

    let config = (*config::config::CONFIG).clone();
    info!("{:?}", config);

    // database config

    let db = Arc::new(create_database_connection(config.database_url.as_str()).await);

    // Start dynamic scheduler in a background task
    tokio::spawn(dynamic_scheduler(db.as_ref().clone()));
    tokio::spawn(daily_scheduler(db.as_ref().clone()));

    // Create the CronJob scheduler
    // let mut cron = CronJob::default();
    // cron.new_job("50 4 * * *", {
    //     println!("\n\n  println      \n\n");
    //     let db = Arc::clone(&db);
    //     move || {
    //         let db = Arc::clone(&db);
    //         tokio::spawn(async move {
    //             create_daily_games(db.as_ref().clone()).await;
    //         });
    //     }
    // });
    // let _ = tokio::spawn(async move {
    //     match cron.start() {
    //         Ok(_) => info!("CronJob started successfully"),
    //         Err(e) => warn!("Failed to start CronJob: {e}"),
    //     }
    // });

    let cors = CorsLayer::new()
        .allow_origin(Any) // Allow any origin, or specify origins
        .allow_methods([
            Method::GET,
            Method::POST,
            Method::PUT,
            Method::DELETE,
            Method::PATCH,
        ])
        .allow_headers(Any);

    // let routes_api = routers::routes_tickets::routes(mc.clone())
    //     .route_layer(middleware::from_fn(routers::mw_auth::mw_require_auth));

    let auth_router = routers::router_auth::routes(db.as_ref().clone());
    let gen_token_router = routers::router_gen_token::routes(db.as_ref().clone());

    let user_router = routers::router_user::routes(db.as_ref().clone());
    // .route_layer(middleware::from_fn(mw_require_auth));

    /////////////// paymnet routers ////////////////////
    let payment_gateway_router = routers::payments::payment_gateway::routes(db.as_ref().clone()); //.route_layer(middleware::from_fn(mw_require_auth));

    /////////////// Account routers ////////////////////
    let account_router = routers::payments::router_account::routes(db.as_ref().clone());
    // .route_layer(middleware::from_fn(mw_require_auth));

    /////////////// Withraw Routs ////////////////////
    let withdraw_rounter = routers::payments::withdraw_request::routes(db.as_ref().clone())
        .route_layer(middleware::from_fn(mw_require_auth));

    /////////////// Withraw Routs ////////////////////
    let make_deposite = routers::payments::make_deposite::routes(db.as_ref().clone()); // .route_layer(middleware::from_fn(mw_require_auth));

    /////////////// Game Routs ////////////////////
    let game_router = routers::game::game::routes(db.as_ref().clone());
    let daily_game_router = routers::game::daily_game::routes(db.as_ref().clone());
    let user_bet_router = routers::game::user_bet::routes(db.as_ref().clone());
    let game_result_router = routers::game::game_result::routes(db.as_ref().clone());
    let statment_router = routers::game::statement_route::routes(db.as_ref().clone());
    let users_account = routers::payments::user_account::routes(db.as_ref().clone());
    // .route_layer(middleware::from_fn(mw_require_auth));

    let homepage: HomePage = HomePage {
        name: config.name,
        version: config.version,
        authour: config.author,
        github: config.github,
    };

    let routes_hello: Router = Router::new()
        .route("/", get(|| async { Json(homepage) }))
        .nest("/api/auth", auth_router)
        .nest("/api/user", user_router)
        .nest("/api/game", game_router)
        .nest("/api/daily_game", daily_game_router)
        .nest("/api/user_bet", user_bet_router)
        .nest("/api/game_result", game_result_router)
        .nest("/api/gen-accesss-tokens", gen_token_router)
        .nest("/api/payment_gateway", payment_gateway_router)
        .nest("/api/account", account_router)
        .nest("/api/withdraw", withdraw_rounter)
        .nest("/api/deposite", make_deposite)
        .nest("/api/statement", statment_router)
        .nest("/api/users_account", users_account)
        .route(
            "/api/upload",
            post(upload_file).with_state(db.as_ref().clone()),
        )
        // .merge(web::routes_login::routes())
        // .nest("/api", routes_api)
        .layer(middleware::map_response(main_response_mapper))
        .layer(CookieManagerLayer::new())
        .layer(cors)
        .fallback_service(static_files());

    // route and marge for route
    // falback not route not match then fallback work
    // layer for extra think but it's work bottom to top

    let url = format!("{}:{}", config.server, config.port);
    println!("{}", url);

    let listener = tokio::net::TcpListener::bind(url.clone()).await.unwrap();
    log::info!("Listning: http://{}/", url);

    match serve(
        listener,
        routes_hello.into_make_service_with_connect_info::<SocketAddr>(),
    )
    .await
    {
        Ok(_) => {
            info!("Server started...")
        }
        Err(e) => {
            warn!("{e}");
            exit(1);
        }
    }

    Ok(())
}

async fn main_response_mapper(
    uri: Uri,
    req_method: Method,
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    res: Response<Body>,
) -> Response {
    println!();

    let uuid = Uuid::new_v4();
    let ip = addr.to_string().split(":").next().unwrap().to_string();

    let _ = log_request(uuid, req_method, uri, ip).await;

    res
}
