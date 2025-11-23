interface Game {
  id: number;
  uid: string;
  name: string;
  start_time: string; 
  end_time: string; 
  max_number?: number | null;
  max_price?: string | null;
  created_by: number;
  created_at: string; 
  updated_by?: number | null;
  updated_at?: string | null; 
  deleted_by?: number | null;
  status: string;
  deleted_at?: string | null; 
}


export { type Game }
