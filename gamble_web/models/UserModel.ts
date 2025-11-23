

export interface User {
    id: number;
    username?: string;
    email?: string;
    password?: string;
    mobile?: string;
    refresh_token?: string;
    otp?: string;
    wallet: number;
    role: string;
    created_at: string;
    created_by?: number;
    updated_at: string;
    updated_by?: number;
    deleted_at?: string;
    deleted_by?: number;
}


enum Role {
    SYSTEM = "SYSTEM",
    ADMIN = "ADMIN",
    WORKER = "WORKER",
    USER = "USER",
    NONE = "NONE",
  }

