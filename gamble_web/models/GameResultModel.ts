import { DailyGame } from "./DailyGameModel";
import { Game } from "./GameModel";
import { UserBet } from "./UserBetModels";

export interface GameResult {
  id: number;
  game_id: number;
  user_id: number;
  game_type: string; // Enum representation in TypeScript
  result: string; // Enum representation in TypeScript
  status: string; // Enum representation in TypeScript
  amount: string; // Optional amount represented as a string
  created_by: number;
  created_at: string; // ISO string for NaiveDateTime
  updated_by?: number | null;
  updated_at?: string | null; // ISO string for NaiveDateTime
  deleted_by?: number | null;
  deleted_at?: string | null; // ISO string for NaiveDateTime
}
export interface UserGameResult {
  id: number;
  game_id: number;
  user_id: number;
  daily_game_id: number;
  result: string; // Enum type for result
  status: string; // Enum type for status
  amount: string; // Optional amount field
  created_by: number;
  created_at: string; // ISO 8601 date string
  updated_by?: number | null;
  updated_at?: string | null; // ISO 8601 date string or null
  deleted_by?: number | null;
  deleted_at?: string | null; // ISO 8601 date string or null
  game: Game;
  daily_game: DailyGame;
  user_bet: UserBet;
}
