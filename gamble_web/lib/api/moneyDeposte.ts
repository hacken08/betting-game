import { MoneyDepositeSearchPayload, MoneyDepositWithRelations, UpdateMoneyDeposite } from "@/models/MoneyDeposite";
import { HttpMethodType, makeApiRequeest } from "./untils";
import { AxiosError } from "axios";
import { toast } from "react-toastify";
import { BASE_URL } from "../const";


async function updateDepositeRequestApi(query: UpdateMoneyDeposite): Promise<boolean> {
    try {
        const response = await makeApiRequeest(
            `${BASE_URL}/api/deposite/update`,
            HttpMethodType.POST,
            {
                includeToke: true,
                bodyParam: query
            }
        )
        console.log(response);
        return (response?.status ?? 500) <= 200
    } catch (error) {
        const asioError: AxiosError = error as AxiosError;
        toast.error(asioError.message);
        return false;
    }
}

async function updateUserWalletApi(userId: number, wallet: string): Promise<boolean> {
    try {
        const response = await makeApiRequeest(
            `${BASE_URL}/api/user/${userId}`,
            HttpMethodType.PUT,
            {
                includeToke: true,
                bodyParam: { wallet }
            }
        )
        console.log(response);
        return (response?.status ?? 500) <= 200
    } catch (error) {
        const asioError: AxiosError = error as AxiosError;
        toast.error(asioError.message);
        return false;
    }
}


export { 
    updateDepositeRequestApi,
    updateUserWalletApi,
}
