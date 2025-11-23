export interface UserBet {
    id: number;
    game_id: number;
    daily_game_id: number;
    user_id: number;
    game_type?: string | null; // JODI, ANDER, BAHER represented as a string or null
    bid_number: string;
    status: string; // PENDING, ACTIVE, COMPLETED, CANCELLED
    amount?: string ; // Can be null or default to 0
    created_by: number;
    created_at: string; // ISO string for NaiveDateTime
    updated_by?: number | null;
    updated_at?: string | null; // ISO string for NaiveDateTime
    deleted_by?: number | null;
    deleted_at?: string | null; // ISO string for NaiveDateTime
  }
  

  export enum BidNumberType {
    JODI = "JODI",
    ANDER = "ANDER",
    BAHER = "BAHER"
  }