use std::fs;
use std::io::Error as IoError;

use lazy_static::lazy_static;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct ConfigTomlDatabase {
    dbtype: Option<String>,
    username: Option<String>,
    password: Option<String>,
    host: Option<String>,
    port: Option<u16>,
    db: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct ConfigTomlServer {
    domain: Option<String>,
    port: Option<u16>,
}

#[derive(Serialize, Deserialize, Debug)]
struct ConfigTomlJWT {
    jwt_secret: Option<String>,
    expiration: Option<u16>,
}

#[derive(Serialize, Deserialize, Debug)]
struct ConfigTomlAuthor {
    name: Option<String>,
    github: Option<String>,
}
#[derive(Serialize, Deserialize, Debug)]
struct ConfigTomlPassword {
    password_secret: Option<String>,
    hash: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct ConfigToml {
    database: Option<ConfigTomlDatabase>,
    server: Option<ConfigTomlServer>,
    jwt: Option<ConfigTomlJWT>,
    author: Option<ConfigTomlAuthor>,
    password: Option<ConfigTomlPassword>,
}

#[derive(Serialize, Deserialize, Debug)]
struct ConfigTomlPackage {
    name: Option<String>,
    version: Option<String>,
    edition: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct AppConfigToml {
    package: Option<ConfigTomlPackage>,
}

#[derive(Debug, Clone)]
pub struct Config {
    pub name: String,
    pub server: String,
    pub edition: String,
    pub port: u16,
    pub version: String,
    pub author: String,
    pub database_url: String,
    pub github: String,
    pub password_secret: String,
    pub jwt_secret: String,
    pub jwt_exp: u16,
}

impl Config {
    pub fn new() -> Self {
        let config_filepath: [&str; 4] = [
            "./config.toml",
            "./Config.toml",
            "~/.config/todo/config.toml",
            "~/.config/todo/Config.toml",
        ];

        let mut content: String = String::new();

        for filepath in config_filepath {
            let result: Result<String, IoError> = fs::read_to_string(filepath);
            if result.is_ok() {
                content = result.unwrap();
                break;
            }
        }

        let config_toml: ConfigToml = toml::from_str(&content).unwrap_or_else(|_| {
            log::error!("Failed to create ConfigToml object out of config file");
            ConfigToml {
                database: None,
                server: None,
                jwt: None,
                author: None,
                password: None,
            }
        });

        let (dbtype, username, password, host, port, db): (
            String,
            String,
            String,
            String,
            u16,
            String,
        ) = match config_toml.database {
            Some(database) => {
                let db_type: String = database.dbtype.unwrap_or_else(|| {
                    log::error!("Missing field database type in table database");
                    "unknown".to_owned()
                });
                let db_username: String = database.username.unwrap_or_else(|| {
                    log::error!("Missing field username in table database");
                    "unknown".to_owned()
                });

                let db_password: String = database.password.unwrap_or_else(|| {
                    log::error!("Missing field password in table database");
                    "unknown".to_owned()
                });

                let db_host: String = database.host.unwrap_or_else(|| {
                    log::error!("Missing field host in table database");
                    "unknown".to_owned()
                });

                let db_port: u16 = database.port.unwrap_or_else(|| {
                    log::error!("Missing field port in table database");
                    0
                });

                let db_name: String = database.db.unwrap_or_else(|| {
                    log::error!("Missing field database name in table database");
                    "unknown".to_owned()
                });

                (db_type, db_username, db_password, db_host, db_port, db_name)
            }
            None => {
                log::error!("Missing table database");

                (
                    "unknown".to_owned(),
                    "unknown".to_owned(),
                    "unknown".to_owned(),
                    "unknown".to_owned(),
                    0,
                    "unknown".to_owned(),
                )
            }
        };

        let (domain_name, domain_port): (String, u16) = match config_toml.server {
            Some(server) => {
                let server_name: String = server.domain.unwrap_or_else(|| {
                    log::error!("Missing field domain in table server");
                    "unknown".to_owned()
                });

                let server_port: u16 = server.port.unwrap_or_else(|| {
                    log::error!("Missing field port in table server");
                    0
                });

                (server_name, server_port)
            }
            None => {
                log::error!("Missing table server");

                ("unknown".to_owned(), 0)
            }
        };
        let (jwt_secret, expiration): (String, u16) = match config_toml.jwt {
            Some(jwt) => {
                let jwt_secret: String = jwt.jwt_secret.unwrap_or_else(|| {
                    log::error!("Missing field jwt_secret in table server");
                    "unknown".to_owned()
                });

                let expiration: u16 = jwt.expiration.unwrap_or_else(|| {
                    log::error!("Missing field expiration in table server");
                    0
                });

                (jwt_secret, expiration)
            }
            None => {
                log::error!("Missing table server");

                ("unknown".to_owned(), 0)
            }
        };

        let (name, github): (String, String) = match config_toml.author {
            Some(author) => {
                let author_name: String = author.name.unwrap_or_else(|| {
                    log::error!("Missing field name in table author");
                    "unknown".to_owned()
                });
                let author_github: String = author.github.unwrap_or_else(|| {
                    log::error!("Missing field github in table author");
                    "unknown".to_owned()
                });

                (author_name, author_github)
            }
            None => {
                log::error!("Missing table author");

                ("unknown".to_owned(), "unknown".to_owned())
            }
        };

        let (password_secret, hash): (String, String) = match config_toml.password {
            Some(password) => {
                let password_secret: String = password.password_secret.unwrap_or_else(|| {
                    log::error!("Missing field password secret in table author");
                    "unknown".to_owned()
                });
                let hash: String = password.hash.unwrap_or_else(|| {
                    log::error!("Missing field hash in table author");
                    "unknown".to_owned()
                });
                (password_secret, hash)
            }
            None => {
                log::error!("Missing table password");

                ("unknown".to_owned(), "unknown".to_owned())
            }
        };

        let database_url = format!(
            "{}://{}:{}@{}:{}/{}",
            dbtype, username, password, host, port, db
        );

        let app_config_filepath: [&str; 2] = ["./Cargo.toml", "./cargo.toml"];
        let mut app_config_content: String = String::new();

        for filepath in app_config_filepath {
            let result: Result<String, IoError> = fs::read_to_string(filepath);
            if result.is_ok() {
                app_config_content = result.unwrap();
                break;
            }
        }

        let app_config_toml: AppConfigToml =
            toml::from_str(&app_config_content).unwrap_or_else(|_| {
                log::error!("Failed to create ConfigToml object out of config file");
                AppConfigToml { package: None }
            });

        let (app_name, app_version, app_edition): (String, String, String) =
            match app_config_toml.package {
                Some(package) => {
                    let application_name: String = package.name.unwrap_or_else(|| {
                        log::error!("Missing field name in table package");
                        "unknown".to_owned()
                    });
                    let application_version: String = package.version.unwrap_or_else(|| {
                        log::error!("Missing field version in table package");
                        "unknown".to_owned()
                    });

                    let application_edition: String = package.edition.unwrap_or_else(|| {
                        log::error!("Missing field edition in table package");
                        "unknown".to_owned()
                    });

                    (application_name, application_version, application_edition)
                }
                None => {
                    log::error!("Missing table package");

                    (
                        "unknown".to_owned(),
                        "unknown".to_owned(),
                        "unknown".to_owned(),
                    )
                }
            };

        Config {
            name: app_name,
            version: app_version,
            edition: app_edition,
            server: domain_name,
            port: domain_port,
            author: name,
            database_url: database_url,
            github: github,
            password_secret: password_secret,
            jwt_secret: jwt_secret,
            jwt_exp: expiration,
        }
    }
}

lazy_static! {
    pub static ref CONFIG: Config = Config::new();
}
