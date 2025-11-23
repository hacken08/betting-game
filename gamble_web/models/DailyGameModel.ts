interface DailyGame {
  id: number;
  game_id: number;
  result?: string | null;
  status: string;
  created_by: number;
  created_at: string; // ISO string for NaiveDateTime
  updated_by?: number | null;
  updated_at?: string | null; // ISO string for NaiveDateTime
  deleted_by?: number | null;
  deleted_at?: string | null; // ISO string for NaiveDateTime
}


export { type DailyGame }
