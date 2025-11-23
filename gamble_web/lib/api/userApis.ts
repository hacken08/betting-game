
import { MoneyDepositeSearchPayload, MoneyDepositWithRelations, UpdateMoneyDeposite } from "@/models/MoneyDeposite";
import { HttpMethodType, makeApiRequeest } from "./untils";
import { AxiosError } from "axios";
import { toast } from "react-toastify";
import { BASE_URL } from "../const";
import { User } from "@/models/UserModel";
import { Role } from "@/schema/create";



async function getUserByIdApi(userId: number): Promise<User | undefined> {
    try {
        const response = await makeApiRequeest(
            `${BASE_URL}/api/user/${userId}`,
            HttpMethodType.GET,
            {
                includeToke: true,
                // bodyParam: { wallet }
            }
        )
        console.log(response);
        return response?.data.data as User;
    } catch (error) {
        const asioError: AxiosError = error as AxiosError;
        toast.error(asioError.message);
        return;
    }
}


async function getUserByRole(role: Role, skip: number = 0, take: number = 10): Promise<User[] | undefined> {
    try {
        const response = await makeApiRequeest(
            `${BASE_URL}/api/user/role/${role}`,
            HttpMethodType.POST,
            { includeToke: true, bodyParam: { skip, take } }
        )
        console.log(response?.data.data);
        return response?.data.data as User[];
    } catch (error) {
        const asioError: AxiosError = error as AxiosError;
        console.error(error);
        toast.error(asioError.message);
        return;
    }
}




// async function updateUserDataByIdApi(userId: number): Promise<User[] | undefined> {
//     try {
//         const response = await makeApiRequeest(
//             `${BASE_URL}/api/user/role/${role}`,
//             HttpMethodType.POST,
//             { includeToke: true, bodyParam: { skip, take } }
//         )
//         console.log(response?.data.data);
//         return response?.data.data as User[];
//     } catch (error) {
//         const asioError: AxiosError = error as AxiosError;
//         console.error(error);
//         toast.error(asioError.message);
//         return;
//     }
// }







export { 
    getUserByIdApi,
    getUserByRole
}

