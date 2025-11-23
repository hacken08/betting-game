

interface GetWorkersWithdrawalRequest {
    id: number;
    account_holder: string;
    account_number: string;
    amount: string;
    bank_name: string;
    ifsc_code: string;
    user_id: number;
    user_username: string;
    user_email: string;
    user_mobile: string;
    created_at: Date;        
}


interface WithdrawalRequest {
    id: number;
    user_id: number;
    worker_id: number;
    amount: string;
    bank_name: string;
    account_holder: string;
    ifsc_code: string;
    account_number: string;
    status: string;
    created_at: Date;        
    updated_at: Date;        
    deleted_at?: Date | null;
}


export { type GetWorkersWithdrawalRequest as GetWithdrawalRequestSchema, type WithdrawalRequest }