import ApproveDailouge from '@/components/DialogeBoxes/approve'
import RejectDailouge from '@/components/DialogeBoxes/reject'
import TransferDailouge from '@/components/DialogeBoxes/transfer'
import { Tag, Image } from 'antd'
import React, { useEffect, useState } from 'react'
import { BiSolidUser } from 'react-icons/bi'
import { Skeleton } from "@/components/ui/skeleton";
import { BsBank } from 'react-icons/bs'
import { FaCopy } from 'react-icons/fa6'
import { MdSmartphone, MdEmail } from 'react-icons/md'
import { Button } from '../ui/button'
import ProcessingDailouge from '../DialogeBoxes/processing'
import { toast } from 'react-toastify'
import { BASE_URL } from '@/lib/const'
import { HttpMethodType, makeApiRequeest } from '@/lib/api/untils'
import { getCookie } from 'cookies-next'
import { GetWithdrawalRequestSchema } from '@/models/WithdrawalModel'
import { numberToWords } from 'amount-to-words';
import { dateTimeFormatter } from '@/lib/utilsMethod'

interface probType {
    showAdminInfo: boolean
    pendingWithdrawalRequest: GetWithdrawalRequestSchema
}

const PendingRequestCard = (probs: probType) => {
    const { pendingWithdrawalRequest } = probs;

    return (
        <div
            className="flex bg-gray-50 shadow-md flex-col w-full justify-start items-center sm:w-[360px] p-0 rounded-lg">
            <div className="min-h-7 bg-zinc-200 w-full flex items-center px-2 justify-start">
                <span className="mx-1">Pending Request </span>
                ( <BsBank className="mx-1" /> )<div className="grow"></div>
                <TransferDailouge />
            </div>

            {/* User profile and details */}
            <div className="flex flex-col justify-between rounded-md p-5 items-center px-4 py-2 w-full">
                <Image
                    preview={false}
                    width={80}
                    height={80}
                    src="https://cdn-icons-png.flaticon.com/128/3177/3177440.png"
                    alt="icon"
                />
                <div className="flex flex-col gap-1 my-5 mb-2 w-full items-center">
                    <div className="flex gap-2 items-center">
                        <span className="font-semibold text-sm"> Phone no:</span>
                        <span>+91 {pendingWithdrawalRequest.user_mobile}</span>
                    </div>
                    <div className="flex gap-2 items-center">
                        <span className="font-semibold text-sm ">
                            User Id:
                        </span>
                        {pendingWithdrawalRequest.user_id}
                    </div>
                    <div className="flex gap-2 items-center">
                        {/* 22 jul 2024, 4:10pm */}
                        {dateTimeFormatter(pendingWithdrawalRequest.created_at)}
                    </div>
                </div>
            </div>

            {/* ... ... User bank details ... ... */}
            <div className="flex flex-col my-5 gap-[3px] justify-center items-start w-full px-5">
                <div className="flex gap-3 items-center w-full">
                    <span className="font-bold text-sm">Bank name:</span>
                    <span> {pendingWithdrawalRequest.bank_name} </span>
                    <div className="grow"></div>
                    <FaCopy className="text-gray-500" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    <span className="font-bold text-sm">Account holder:</span>
                    <span> {pendingWithdrawalRequest.account_holder} </span>
                    <div className="grow"></div>
                    <FaCopy className="text-gray-500" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    <span className="font-bold text-sm">Account number:</span>
                    <span> {pendingWithdrawalRequest.account_number}</span>
                    <div className="grow"></div>
                    <FaCopy className="text-gray-500" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    <span className="font-bold text-sm">IFSC code:</span>
                    <span> {pendingWithdrawalRequest.ifsc_code} </span>
                    <div className="grow"></div>
                    <FaCopy className="text-gray-500" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    <span className="font-bold text-sm text-zinc-500">
                        Amount:
                    </span>
                    <span> {pendingWithdrawalRequest.amount}</span>
                    <div className="grow"></div>
                    <FaCopy className="text-gray-500" />
                </div>
                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>
                <div className="flex w-full item-center justify-center">
                    ({numberToWords(pendingWithdrawalRequest.amount)})
                </div>
            </div>

            {probs.showAdminInfo &&
                <>
                    {/* ... ... Admin info ... ... */}
                    <div className="flex px-4 items-center mb-3 w-full justify-between">
                        <span className="font-semibold text-lg">Admin Info</span>
                        <Tag className="px-4 py-[2px]" color="green">
                            Online
                        </Tag>
                    </div>
                    <div className="px-4 py-2 w-full justify-between items-center flex ">
                        <div className="flex flex-col justify-between items-start gap-2 ">
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <MdSmartphone />
                                </span>
                                {/* <span>+91 {pendingWithdrawalRequest.worker_mobile}</span> */}
                                <span>+91 ***********</span>
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <MdEmail />
                                </span>
                                {/* <span>{pendingWithdrawalRequest.worker_email}</span> */}
                                <span>example@gmail.com</span>
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <BiSolidUser />
                                </span>
                                {/* <span>{pendingWithdrawalRequest.worker_username}</span> */}
                                <span>Admin username</span>
                            </div>
                        </div>

                        <div className="flex flex-col my-2 gap-2 justify-between ">
                            <div className="flex flex-col">
                                <span className="font-semibold text-sm">
                                    Last approved:-
                                </span>
                                <span> one minute ago </span>
                            </div>
                            <div className="flex flex-col">
                                <span className="font-semibold text-sm">
                                    Last rejected:-
                                </span>
                                <span> one minute ago </span>
                            </div>
                        </div>
                    </div>
                </>
            }

            {/* ... ... Action buttons ... ... */}
            <div className="flex justify-between pb-4 px-3 gap-0 mt-5 w-full">
                <ApproveDailouge withdraw={true} />
                <ProcessingDailouge withdraw={true} />
                <RejectDailouge withdraw={true} />
            </div>
        </div>
    )
}

const PendingRequestLoader = (probs: any) => {
    return (
        <div
            className="flex bg-gray-50 shadow-md flex-col w-full justify-start items-center sm:w-[360px] p-0 rounded-lg">
            <div className="min-h-7 bg-zinc-200 w-full flex items-center px-2 justify-start">
                <span className="mx-1">Pending Request </span>
                ( <BsBank className="mx-1" /> )<div className="grow"></div>
                <TransferDailouge />
            </div>

            {/* User profile and details */}
            <div className="flex flex-col justify-between rounded-md p-5 items-center px-4 py-2 w-full">
                {/* <Image
                    preview={false}
                    width={80}
                    height={80}
                    src="https://cdn-icons-png.flaticon.com/128/3177/3177440.png"
                    alt="icon"
                /> */}
                <Skeleton className="h-20 w-20 bg-[#ebebeb] rounded-full" />

                <div className="flex flex-col gap-1 my-5 mb-2 w-full items-center">
                    <div className="flex gap-2 items-center">
                        {/* <span className="font-semibold text-sm"> Phone no:</span>
                        <span>+91 **********</span> */}
                        <Skeleton className="h-[23px] w-48 bg-[#ebebeb] rounded-md" />
                    </div>
                    <div className="flex gap-2 items-center">
                        {/* <span className="font-semibold text-sm ">
                            User Id:
                        </span>
                        234 */}
                        <Skeleton className="h-[23px] w-16 bg-[#ebebeb] rounded-md" />
                    </div>
                    <div className="flex gap-2 items-center">
                        {/* 22 jul 2024, 4:10pm */}
                        <Skeleton className="h-[23px] w-32 bg-[#ebebeb] rounded-md" />
                    </div>
                </div>
            </div>

            {/* ... ... User bank details ... ... */}
            <div className="flex flex-col my-5 gap-[3px] justify-center items-start w-full px-5">
                <div className="flex gap-3 items-center w-full">
                    <Skeleton className="h-[25px] w-full bg-[#ebebeb] rounded-md" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    <Skeleton className="h-[25px] w-full bg-[#ebebeb] rounded-md" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    <Skeleton className="h-[25px] w-full bg-[#ebebeb] rounded-md" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    <Skeleton className="h-[25px] w-full bg-[#ebebeb] rounded-md" />
                </div>

                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>

                <div className="flex gap-3 items-center w-full">
                    {/* <span className="font-bold text-sm text-zinc-500">
                        Amount:
                    </span>
                    <div className="grow"></div> */}
                    <Skeleton className="h-[25px] w-full bg-[#ebebeb] rounded-md" />
                    {/* <span> {pendingWithdrawalRequest.amount}</span> */}
                    {/* <FaCopy className="text-gray-500" /> */}
                </div>
                <div className="h-[0.5px] w-full bg-gray-300 my-1 "></div>
                {/* <div className="flex w-full item-center justify-center">
                    (Twenty three thousand)
                </div> */}
            </div>

            {probs.showAdminInfo &&
                <>
                    {/* ... ... Admin info ... ... */}
                    <div className="flex px-4 items-center mb-3 w-full justify-between">
                        <span className="font-semibold text-lg">Admin Info</span>
                        <Tag className="px-4 py-[2px]" color="green">
                            Online
                        </Tag>
                    </div>
                    <div className="px-4 py-2 w-full justify-between items-center flex ">
                        <div className="flex flex-col justify-between items-start gap-2 ">
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <MdSmartphone />
                                </span>
                                {/* <span>+91 {pendingWithdrawalRequest.worker_mobile}</span> */}
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <MdEmail />
                                </span>
                                {/* <span>{pendingWithdrawalRequest.worker_email}</span> */}
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <BiSolidUser />
                                </span>
                                {/* <span>{pendingWithdrawalRequest.worker_username}</span> */}
                            </div>
                        </div>

                        <div className="flex flex-col my-2 gap-2 justify-between ">
                            <div className="flex flex-col">
                                <span className="font-semibold text-sm">
                                    Last approved:-
                                </span>
                                <span> one minute ago </span>
                            </div>
                            <div className="flex flex-col">
                                <span className="font-semibold text-sm">
                                    Last rejected:-
                                </span>
                                <span> one minute ago </span>
                            </div>
                        </div>
                    </div>
                </>
            }

            {/* ... ... Action buttons ... ... */}
            <div className="flex justify-between pb-4 px-3 gap-0 mt-5 w-full">
                <ApproveDailouge withdraw={true} />
                <ProcessingDailouge withdraw={true} />
                <RejectDailouge withdraw={true} />
            </div>
        </div>
    )
}

export { PendingRequestCard, PendingRequestLoader }
