use crate::models::utils::ApiResponse;

#[derive(Clone, Debug)]
pub struct Ctx {
    user_id: i32,
    role: String,
}

// Constructor
impl Ctx {
    pub fn new(user_id: i32, role: String) -> Self {
        Self { user_id, role }
    }
}

// Property Accessor.
impl Ctx {
    pub fn user_id(&self) -> i32 {
        self.user_id
    }
    pub fn user_role(&self) -> String {
        self.role.clone()
    }
}
