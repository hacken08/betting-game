import React, { useEffect, useRef, useState } from 'react'
import {
    Select,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectLabel,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select"
import { AlertDialog, AlertDialogCancel, AlertDialogContent, AlertDialogTrigger } from '@/components/ui/alert-dialog'
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox"
import { Button } from '@/components/ui/button'
import { FaSearch } from "react-icons/fa";
import { IoMdClose } from "react-icons/io";
import { Input } from "antd";
import { Input as input } from '@/components/ui/input';
import { MoneyDepositWithRelations, PaymentStatus } from '@/models/MoneyDeposite';
import { numberToWords } from 'amount-to-words';
import { updateDepositeRequestApi, updateUserWalletApi } from '@/lib/api/moneyDeposte';
import { toast } from 'react-toastify';
import { getUserByIdApi } from '@/lib/api/userApis';

type ProbsParam = {
    withdraw?: boolean,
    depositeReqest?: MoneyDepositWithRelations,
    setDepositeReqState?: (
        depositeReqId: number,
        status: PaymentStatus,
        workerId?: number,
    ) => Promise<void>;
}


const ApproveDailouge = (probs: ProbsParam ) => {
    const [sendingAmount, setsendingAmount] = useState<string>("0")
    const [isAmountedSended, setIsAmountedSended] = useState<boolean>(false)
    const [amountInWords, setAmountInWords] = useState<string>(numberToWords(sendingAmount))
    const alertDialogRef = useRef<HTMLButtonElement | null>(null)

    const handleOnSubmitButtonCall = async () => {
        if (isAmountedSended) {
            toast.error("Already sended once")
            return;
        }
        if (!probs.depositeReqest) return;
        const user =  await getUserByIdApi(probs.depositeReqest.user.id);
        if (!user) return;
        const prevWalletAmount: number = Number(user.wallet)
        const isWalletUpdated = await updateUserWalletApi(
            (probs.depositeReqest?.user_id ?? 0),
            `${prevWalletAmount + Number(sendingAmount)}`
        );
        const isPaymentAccept = await updateDepositeRequestApi({
            id: probs.depositeReqest?.id ?? 0,
            payment_status: PaymentStatus.ACCEPT
        })
        if (!isWalletUpdated || !isPaymentAccept) return;
        setIsAmountedSended(true)
        probs.setDepositeReqState 
            ? probs.setDepositeReqState(probs.depositeReqest.id, PaymentStatus.ACCEPT) 
            : undefined;
        alertDialogRef.current?.click()
        toast.success(`Money has been added to ${probs.depositeReqest?.user.username}`)
    }


    useEffect(() => {
        if (probs.depositeReqest) {
            setsendingAmount(probs.depositeReqest.amount ?? "")
            setAmountInWords(numberToWords(probs.depositeReqest.amount ?? "0"))
        }
    }, [])
    
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className='w-full m-0 p-0'>
                    <Button className="bg-green-500 w-full rounded-none m-0 rounded-l-lg hover:bg-green-700 text-white " variant={"default"}>
                        Approve
                    </Button>
                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent className='p-0 sm:w-[470px] w-full'>
                    <div className="flex flex-col w-full ">
                        {/* ================ Top nav bar ================ */}
                        <div className="flex px-4 py-2 justify-start items-center bg-[#e3ffde]">
                            <span className="font-medium pr-6 text-[#7cb673]">
                                Enter Transaction ID
                            </span>
                            {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                            <div className="grow"></div>
                            <AlertDialogCancel ref={alertDialogRef} className="bg-[#9ad897] text-white">
                                <IoMdClose className="font-bold" />
                            </AlertDialogCancel>
                        </div>

                        <div className="flex w-full my-3  mt-7 items-center justify-center  gap-3.5">
                            <Label className='text-xl' htmlFor="picture">{!probs.withdraw ? "Sending Amount" : "Payment screenshot"}</Label>
                        </div>

                        <div className="flex flex-col w-full px-4  my-3 mt-3 items-center justify-start gap-3">
                            {!probs.withdraw &&
                                <div className="flex w-[70%]">
                                    <Input 
                                        value={sendingAmount} 
                                        onChange={(e) => {
                                            // if (isNaN(Number(e))) return;
                                            setsendingAmount(e.target.value);
                                            setAmountInWords(numberToWords(e.target.value))
                                        }} 
                                        placeholder={"500.00"} className="rounded-r-none rounded-l-2xl" id="picture" type="text" />
                                    <Button className="rounded-l-none rounded-r-2xl  flex justify-self-start bg-[#7cb673] px-8">Edit</Button>
                                </div>
                            }
                            {probs.withdraw &&
                                <div className="flex   w-[70%]">
                                    <Input type="file" placeholder="Upload QR code" />
                                </div>
                            }
                            <Label className='text-md font-bold mb-2 text-red-600' htmlFor="picture">{amountInWords}</Label>
                            {probs.withdraw &&
                                <Input readOnly className='w-[70%] placeholder:text-black' placeholder='23,000  holder name' />
                            }
                            {!probs.withdraw &&
                                <div className="flex w-[30%]">
                                    <Input placeholder="Enter transaction ID" className="rounded-full h-11" id="picture" type="text" />
                                </div>
                            }
                            {/* <div className="flex w-[70%]">
                                <Select>
                                    <SelectTrigger className="w-full rounded-full h-11 focus:out">
                                        <SelectValue defaultValue={"Today"} placeholder="Time" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        <SelectItem value="Today">Today</SelectItem>
                                        <SelectItem value="Yesterday">Yesterday</SelectItem>
                                        <SelectItem value="Last 7 days">Last 7 days</SelectItem>
                                        <SelectItem value="Last 30 days">Last 30 days</SelectItem>
                                        <SelectItem value="This month">This month</SelectItem>
                                        <SelectItem value="Last month">Last month</SelectItem>
                                        <SelectItem value="Custom range">Custom range</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div> */}
                        </div>

                        <div className="flex justify-center my-5">
                            <Button 
                                onClick={e=>handleOnSubmitButtonCall()} 
                                className="bg-[#7cb673] w-[68%] hover:bg-[#7cb673] rounded-full">
                                Sumbit
                            </Button>
                        </div>


                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default ApproveDailouge
