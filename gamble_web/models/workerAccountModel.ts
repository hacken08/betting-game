interface WorkersAccount {
    id: number;
    worker_id: number;
    gateway_id: number;
    upi_address: string;
    contact: string;
    qr_image: string;
    worker_email: string;
    bank_name: string;
    account_holder: string;
    ifsc_code: string;
    account_number: string;
    payment_type: string;
    status: string;
    created_at: string;
    created_by: number;
    updated_at: string;
    updated_by?: number;
    deleted_at?: string;
    deleted_by?: number;
}


export { type WorkersAccount };