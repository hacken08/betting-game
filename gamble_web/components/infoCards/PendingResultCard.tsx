import React, { useEffect, useMemo, useState } from 'react';
import { Image } from 'antd';
import { MdEmail, MdSmartphone } from 'react-icons/md';
import { BiSolidUser } from 'react-icons/bi';
import { FaMoneyBill, FaRegCalendar } from 'react-icons/fa';
import { CiCreditCard2 } from 'react-icons/ci';
import { Button } from '../ui/button';
import dynamic from 'next/dynamic';
import { MoneyDepositeModel, MoneyDepositWithRelations, AddMoneyProbParams, PaymentStatus } from '@/models/MoneyDeposite';
import { dateTimeFormatter } from '@/lib/utilsMethod';
import { BASE_URL } from '@/lib/const';
import { updateDepositeRequestApi } from '@/lib/api/moneyDeposte';
import { getCookie } from 'cookies-next';
import { toast } from 'react-toastify';
import { HttpMethodType, makeApiRequeest } from '@/lib/api/untils';
import { AxiosError } from 'axios';
// import ApproveDailouge from '../DialogeBoxes/approve';
// import RejectDailouge from '../DialogeBoxes/reject';

const ApproveDailouge = dynamic(() => import('@/components/DialogeBoxes/approve'), { ssr: false })
const RejectDailouge = dynamic(() => import('@/components/DialogeBoxes/reject'), { ssr: false })

const PendingRequestCard = (probs: AddMoneyProbParams) => {
    const { depositeMoney } = probs;
    const [updateStatusLoading, setUpdateStatusLoading] = useState<boolean>(false)
    const userId: number =  useMemo(() => {
        const userId = getCookie("id")
        if (!userId || isNaN(Number(userId))) {
            toast.error("User id not found. Please login again")
            return -1;
        }
        return parseInt(userId)
    }, []);

    async function handleOnProccessClick() {
        setUpdateStatusLoading(true)
        const isUpdated = await updateDepositeRequestApi({
            id: depositeMoney.id,
            payment_status: PaymentStatus.PROCESSING
        })
        if (!isUpdated) {
            setUpdateStatusLoading(false)
            return;
        }
        setTimeout(async () => {
            probs.setParentState 
            ? await probs.setParentState(depositeMoney.id, PaymentStatus.PROCESSING) 
            : undefined; 
            setUpdateStatusLoading(false)
        }, 500)
    }

    
    return (
        <div className="flex bg-gray-50 shadow-md flex-col justify-start w-full items-center sm:w-[360px] p-0 rounded-lg">
            <div className="min-h-7 bg-zinc-200 w-full flex items-center px-2 justify-start">
                <span className="mx-1">Pending Request </span>
                (
                    <Image
                        preview={false}
                        height={50}
                        width={50}
                        alt="NextUI hero Image"
                        src="https://cdn.iconscout.com/icon/free/png-256/free-paytm-226448.png?f=webp&w=256"
                    />
                )
                <div className="grow"></div>
            </div>

            {/* Payment infomation */}
            <div className="flex justify-between px-4 py-2 w-full">
                <div className="flex flex-col gap-1">
                    <div className="flex gap-3 items-center">
                        <MdSmartphone /> <span>+91 {depositeMoney.user.mobile ?? ""}</span>
                    </div>
                    <div className="flex gap-3 items-center">
                        <BiSolidUser />
                        <span className="font-semibold text-sm "> User Id: </span>
                        {depositeMoney.user.id}
                    </div>
                    <div className="flex gap-3 items-center">
                        <FaMoneyBill />
                        <span className="font-semibold text-sm">
                            {depositeMoney.amount} INR
                        </span>
                    </div>
                    {
                    /* <div className="flex gap-3 items-center">
                        <CiCreditCard2 />
                        <span className="font-semibold text-sm">
                            TXN ID:
                        </span>
                        A7238912IDA
                    </div> */
                    }
                    <div className="flex gap-3 items-center">
                        <FaRegCalendar />
                        <span className="font-semibold text-sm"> {dateTimeFormatter(depositeMoney.created_at)} </span>
                    </div>
                </div>
                <Image
                    // width={80}
                    height={130}
                    className="w-20 h-32 max-w-28" 
                    src={`${BASE_URL}/${depositeMoney.payment_screen_shot}`}
                    alt=""
                />
            </div>

            {/*  ............ admin info ............ */}
            {probs.showAdminInfo &&
                <>
                    {/* ... ... Seprator ... ... */}
                    <div className="h-[0.5px] w-[70%] bg-gray-300 my-5 "></div>

                    <div className="flex px-4 items-center mb-3 w-full justify-between">
                        <span className="font-semibold text-lg">Admin Info</span>
                        {/* <Tag className="px-4 py-[2px]" color="green">Online</Tag> */}
                    </div>

                    <div className="px-4 py-2 w-full justify-between items-center flex ">
                         <div className="flex flex-col justify-between items-start gap-2 ">
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <MdSmartphone />
                                </span>
                                <span>+91 {depositeMoney.worker.mobile ?? ""}</span>
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <MdEmail />
                                </span>
                                <span>{depositeMoney.worker.email ?? ""}</span>
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="font-semibold text-sm">
                                    <BiSolidUser />
                                </span>
                                <span>{depositeMoney.worker.username ?? ""}</span>
                            </div>
                        </div>
                    </div>
                </>
            }


            {/* ... ... Action buttons ... ... */}
            <div className="flex justify-between pb-4 px-3 gap-0 mt-5 w-full">
                <ApproveDailouge withdraw={false} depositeReqest={depositeMoney} setDepositeReqState={probs.setParentState}  />
                {updateStatusLoading 
                    ? <Button  className="bg-blue-300 py-2 m-0 rounded-none hover:bg-blue-300 hover:text-opacity-[0.9] text-white hover:text-white text-opacity-[0.9] w-full" variant={"outline"} >
                        processing
                    </Button>
                    : <Button onClick={e => handleOnProccessClick()} className="bg-blue-500 py-2 m-0 rounded-none hover:bg-blue-700 text-white w-full hover:text-white" variant={"outline"} >
                        processing
                    </Button>
                }
                <RejectDailouge withdraw={false} depositeReqest={depositeMoney} setDepositeReqState={probs.setParentState} />
            </div>

        </div>
    )
}

export default PendingRequestCard
