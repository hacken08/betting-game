use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct HomePage {
    pub name: String,
    pub version: String,
    pub authour: String,
    pub github: String,
}
