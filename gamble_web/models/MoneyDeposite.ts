import { PaymentGateway } from "./paymentGatewayModel";
import { User } from "./UserModel";
import { WorkersAccount } from "./workerAccountModel";

interface MoneyDeposite {
    id: number;
    user_id: number;
    worker_id: number;
    amount: string;
    txn_id: string;
    payment_gateway_id: number;
    worker_account_id: number;
    payment_screen_shot: string;
    created_by: number;
    created_at: string;
    updated_at: string;
    updated_by?: number | null;
    deleted_by?: number | null;
    deleted_at?: string | null;
    status: 'ACTIVE' | 'INACTIVE' | 'NONE';
    payment_status: 'ACCEPT' | 'REJECT' | 'PROCESSING' | 'PENDING' | 'REFUNDED';
}

interface MoneyDepositWithRelations {
    id: number;
    user_id: number;
    worker_id: number;
    amount: string;
    txn_id: string;
    payment_gateway_id: number;
    worker_account_id: number;
    payment_screen_shot: string;
    status: 'ACTIVE' | 'INACTIVE' | 'NONE';
    payment_status: PaymentStatus;
    created_by: number;
    created_at: Date;
    updated_at: Date;
    deleted_at?: Date | null;
    updated_by?: number | null;
    deleted_by?: number | null;
    payment_gateway: PaymentGateway;
    worker_account: WorkersAccount;
    worker: User;
    user: User;
}

interface DepositeMoneyProbType {
    showAdminInfo: boolean
    depositeMoney: MoneyDepositWithRelations,
    setParentState?: (
        depositeReqId: number,
        status: PaymentStatus,
        workerId?: number
    ) => Promise<void>;
}

interface MoneyDepositeSearchPayload {
    user_id?: number;
    worker_id?: number;
    status?: string;
    payment_status?: PaymentStatus;
    created_at_start?: Date;
    created_at_end?: Date;
}

interface UpdateMoneyDeposite {
    id: number;
    status?: string;
    payment_status?: PaymentStatus;
    updated_by?: number;
    deleted_by?: number;
    worker_id?: number
}

enum PaymentStatus {
    PENDING = "PENDING",
    COMPLETED = "COMPLETED",
    FAILED = "FAILED",
    PROCESSING = "PROCESSING",
    ACCEPT = "ACCEPT",
    REFUNDED = "REFUNDED",
    REJECT = "REJECT"
}



export {
    type MoneyDeposite as MoneyDepositeModel,
    type MoneyDepositWithRelations,
    type DepositeMoneyProbType as AddMoneyProbParams,
    type MoneyDepositeSearchPayload,
    type UpdateMoneyDeposite,
    PaymentStatus,
};

