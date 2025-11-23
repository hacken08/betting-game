import { object, string, number, optional, minLength, regex, pipe, InferInput, custom, nullable, nullish } from 'valibot';

const validateType = (value: unknown) => {
    // Implement yourvalidation logic for payment_type here
};

const validateStatus = (value: unknown) => {
    // Implement yourvalidation logic for status here
};

const CreateWorkerAccountSchema = object({
    worker_id: string("No email selected"),
    gateway_id: nullish(string()),
    upi_address: nullish(
        pipe(
            string(),
            regex(/^[a-zA-Z0-9.\-_]{2,}@[a-zA-Z]{2,}$/, "Invalid upi address")
        )
    ),
    qr_image: nullish(string()),
    bank_name: nullish(string()),
    account_holder: nullish(string()),
    ifsc_code: nullish(string()),
    account_number: nullish(
        string(),
    ),
    payment_type: string("select account type"),
});


type CreateWorkerAccountForm = InferInput<typeof CreateWorkerAccountSchema>;

export { type CreateWorkerAccountForm, CreateWorkerAccountSchema }