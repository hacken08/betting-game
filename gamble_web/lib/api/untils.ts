
import axios, { AxiosHeaders, AxiosRequestConfig, AxiosError, AxiosResponse } from "axios";
import { BASE_URL } from "@/lib/const";
import { getCookie, setCookie } from "cookies-next";
import { log } from "console";
import { jwtDecode } from "jwt-decode";
import { headers } from "next/headers";
import { toast } from "react-toastify";
import { CreateWorkerAccountForm } from "@/schema/createWorkerAcountSchema";
import { AppRouterInstance } from "next/dist/shared/lib/app-router-context.shared-runtime";
import CryptoJS from 'crypto-js';



export enum ParamType {
    Path,
    Query,
    Body
}

export enum HttpMethodType {
    GET,
    POST,
    PUT,
    DELETE
}

interface Options {
    includeToke?: boolean,
    bodyParam?: Object,
    queryParam?: Object,
    makeNewTokenReq?: boolean,
    ignoreTokenExp?: boolean
}

interface ParamInput {
    pathParam?: String,
    queryParam?: { [key: string]: any }
}

export function generateUrl(path: string, parameters: ParamInput = {}, paramType: ParamType): string {
    let params = '';
    if (paramType === ParamType.Path) {
        return `${BASE_URL}/${path}/${parameters.pathParam}`

    } else if (paramType === ParamType.Query) {
        Object.entries(parameters).forEach(([key, value]) => {
            params += `&${key}=${value}`;
        });
        return `${BASE_URL}/${path}?${params}`;
    } else {
        return `${BASE_URL}${path}`;
    }
}



export async function makeApiRequeest(url: string,
    httpMethod: HttpMethodType,
    opt: Options = {
        includeToke: true,
        bodyParam: undefined,
        queryParam: undefined,
        makeNewTokenReq: true,
        ignoreTokenExp: false
    }): Promise<AxiosResponse | undefined> {

    let token = getCookie('session');

    if (!token || typeof token !== 'string') {
        console.error('Invalid or missing session');
        toast.error('Invalid or missing session');
        return;
    }

    if (!opt.ignoreTokenExp) {
        if (opt.makeNewTokenReq && isTokenExpired(token)) {
            const refresh_token = getCookie('x-r-t')
            const response = await axios.post(`${BASE_URL}/api/gen-accesss-tokens/${refresh_token}`);

            setCookie('session', response.data.data.access_token);
            setCookie('x-r-t', response.data.data.refresh_token);
            makeApiRequeest(url, httpMethod, opt)
        }
    }

    const axioConfig: AxiosRequestConfig = { method: HttpMethodType[httpMethod].toString().toLowerCase(), url: url }

    if (opt.includeToke) {
        axioConfig.headers = { "Authorization": `Bearer ${token}`, "Content-Type": "application/json" }
    }
    if (opt.queryParam) {
        axioConfig.params = opt.queryParam
    }
    if (opt.bodyParam && (httpMethod === HttpMethodType.POST || httpMethod === HttpMethodType.PUT || httpMethod === HttpMethodType.GET)) {
        axioConfig.data = opt.bodyParam;
    }
    // console.log(opt)
    const responsedata: AxiosResponse = await axios(axioConfig) as AxiosResponse<any>;
    return responsedata;
}

export const isTokenExpired = (token: string) => {
    try {
        const decodedToken = jwtDecode(token);
        const currentTime = Date.now() / 1000;

        if (!decodedToken.exp) {
            return null;
        }

        return decodedToken.exp < currentTime;
    } catch (error) {
        console.error('Error decoding token:', error);
        return true;
    }
};

export const handleAccountParamData = async (
    data: CreateWorkerAccountForm,
    worker_id: number,
    gateway_id: number,
    qr_image: File | undefined,
    created_by: number) => {

    let responseData;

    if (data.payment_type === "QR") {
        if (qr_image === undefined) {
            toast.error("Select QR image")
            return;
        }
        const imagePathData = await axios.postForm(`${BASE_URL}/api/upload`,
            {
                file: qr_image,
                f_type: "workers_account",
                userid: 1
            },
        )
        responseData = await makeApiRequeest(
            `${BASE_URL}/api/account/create`,
            HttpMethodType.POST,
            {
                bodyParam: {
                    ...data,
                    worker_id,
                    gateway_id,
                    created_by,
                    qr_image: imagePathData.data.data.path,
                },
                includeToke: true
            }
        )
    } else {
        if (data.payment_type === "UPI" && data.upi_address === undefined) {
            toast.error("Please provide UPI id")
            return;
        }

        responseData = await makeApiRequeest(
            `${BASE_URL}/api/account/create`,
            HttpMethodType.POST,
            {
                bodyParam: {
                    ...data,
                    worker_id,
                    gateway_id,
                    created_by
                },
                includeToke: true
            }
        )
    }

    return responseData;
}


const secretKey = "knf92fg#G$%2Ij309pwkn4gf#WTF#WCc2@#$WTfwe4jfieowjiogFVD";

// Helper functions for URL-safe Base64 encoding and decoding
const toBase64Url = (str: string): string =>
    str.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");

const fromBase64Url = (str: string): string =>
    str.replace(/-/g, "+").replace(/_/g, "/") + "==".slice(str.length % 4 || 4);

export const encryptURLData = (data: string): string => {
    console.log(data);
    const encryptedData = CryptoJS.AES.encrypt(data, secretKey).toString();
    console.log(encryptedData);
    
    return toBase64Url(encryptedData);
};

export const decryptURLData = (
    cipherText: string,
    router: AppRouterInstance
): string => {
    try {
        const decodedCipherText = fromBase64Url(cipherText); // Convert back from URL-safe Base64
        const bytes = CryptoJS.AES.decrypt(decodedCipherText, secretKey);
        return bytes.toString(CryptoJS.enc.Utf8);
    } catch (e) {
        router.back();
        return "";
    }
};




