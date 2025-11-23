
import { DailyGame } from './DailyGameModel';
import { Game } from './GameModel';
import { GameResult } from './GameResultModel';
import { BidNumberType, UserBet } from './UserBetModels';
import { User } from './UserModel';
import { WithdrawalRequest } from './WithdrawalModel';

interface Statement {
    id: number;
    user_id?: number | undefined;
    game_id?: number | undefined;
    user_bet_id?: number | undefined;
    game_result_id?: number | undefined;
    money_deposite_id?: number | undefined;
    withdraw_request_id?: number | undefined;
    daily_game_id?: number | undefined;
    created_by: number;
    created_at: string;
    updated_by?: number | undefined;
    updated_at?: string | undefined;
    deleted_by?: number | undefined
    deleted_at?: string | undefined;
    statement_type: string;
    status: string;
    user?: User | undefined;
    game?: Game | undefined;
    user_bet?: UserBet | undefined;
    game_result?: GameResult | undefined;
    withdraw_request?: WithdrawalRequest | undefined;
    daily_game?: DailyGame | undefined;
}

interface UserPlayStatment {
    gameName: string,
    gameId: number,
    id: number,
    dateTime: Date,
    totalAmount: number,
    closingBalance: number,
    biddingNumbers: [BidNumber],
}

export interface BidNumber {
    bidNumber: number,
    amount: string,
    numberType: BidNumberType | string
}

export enum StatmentType {
    WITHDRAW, ADD, GAME, PLAY, CASH,
}

export { type Statement as StatementScheme, type UserPlayStatment }
