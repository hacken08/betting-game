

export interface PaymentGateway {
    id: number;
    name: string;
    image: string;
    short_image: string;
    payment_type: string;
    status: string;
    created_at: Date;
    created_by?: number | null;
    updated_at: Date;
    updated_by?: number | null;
    deleted_at?: Date | null;
    deleted_by?: number | null;
}
