import React, { useRef } from 'react'
import { UploadOutlined } from '@ant-design/icons';
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
import { Input, Upload, UploadProps } from "antd";
import { MoneyDepositWithRelations, PaymentStatus } from '@/models/MoneyDeposite';
import { updateDepositeRequestApi } from '@/lib/api/moneyDeposte';
import { toast } from 'react-toastify';
// import { Input } from '@/components/ui/input';
type ProbsParam = {
    withdraw?: boolean,
    depositeReqest?: MoneyDepositWithRelations,
    setDepositeReqState?: (
        depositeReqId: number,
        status: PaymentStatus,
        workerId?: number,
    ) => Promise<void>;
}

const RejectDailouge = (probs: ProbsParam) => {
    const alertDialogRef = useRef<HTMLButtonElement | null>(null)
    const handleSubmitRejectRequest = async () => {
        if (!probs.depositeReqest) return;
        const isRejected = await updateDepositeRequestApi({
            id: probs.depositeReqest.id,
            payment_status: PaymentStatus.REJECT 
        })
        if (!isRejected) return;
        toast.success(`Deposite request is with id ${probs.depositeReqest.id} reject`)
        probs.setDepositeReqState 
            ? probs.setDepositeReqState(probs.depositeReqest.id, PaymentStatus.REJECT,) 
            : undefined
        alertDialogRef.current?.click()
    }

    const props: UploadProps = {
        action: '//jsonplaceholder.typicode.com/posts/',
        listType: 'picture',
        previewFile(file: any) {
          console.log('Your upload file:', file, " ", typeof file);
          // Your process logic. Here we just mock to the same file
          return fetch('https://next.json-generator.com/api/json/get/4ytyBoLK8', {
            method: 'POST',
            body: file,
          })
            .then((res) => res.json())
            .then(({ thumbnail }) => thumbnail);
        },
    };
    
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className='m-0 w-full p-0'>
                    <Button className="bg-red-500 rounded-none rounded-r-lg m-0 hover:bg-red-700 w-full" variant={"destructive"}>
                        Rejected
                    </Button>
                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent className='p-0 sm:w-[470px] w-full'>
                    <div className="flex flex-col w-full ">

                        <div className="flex px-4 py-2 justify-start items-center bg-[#ffe3e5]">
                            <span className="font-medium pr-6 text-[#ac0713]">
                                Enter Transaction ID
                            </span>
                            {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                            <div className="grow"></div>
                            <AlertDialogCancel ref={alertDialogRef} className="bg-[#fc7371] text-white">
                                <IoMdClose className="font-bold" />
                            </AlertDialogCancel>
                        </div>

                        {/* ----------- search result ----------- */}
                        <div className="flex flex-col w-full px-4  my-3 mt-10 items-center justify-start gap-3">
                            <div className="flex w-[70%]">
                                <Select>
                                    <SelectTrigger className="w-full rounded-full h-11 focus:out">
                                        <SelectValue defaultValue={"Today"} placeholder="Select a reason" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        {
                                            rejectedReason.map((value, index) => {
                                                return <SelectItem key={index} value={value}>{value}</SelectItem> 
                                            })
                                        }
                                    </SelectContent>
                                </Select>
                            </div>
                            { probs.withdraw &&
                                <div className="flex w-[70%]">
                                    <Upload {...props}>
                                        <Button ><UploadOutlined /> Upload</Button>
                                    </Upload>

                                    {/* <Input
                                        type="file"
                                        placeholder="Upload QR code"
                                    /> */}
                                </div>
                            }
                        </div>

                        <div className="flex justify-center my-5">
                            <Button onClick={e=> handleSubmitRejectRequest()} className="bg-[#fc7371] w-[68%] hover:bg-[#fc7371] rounded-full">Sumbit</Button>
                        </div>
                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

const rejectedReason = [
    "Invalid payment method",
    "Transaction limit exceeded",
    "Incorrect payment screenshot",
    "Duplicate deposit request detected",
    "Third-party payment service failure",
    "Regulatory or compliance restrictions",
    "User account under review or restricted",
    "Insufficient balance in sender's account",
    "Suspicious or fraudulent activity detected",
    "Technical error during transaction processing",
    "Deposit amount does not meet the minimum requirement",
];


export default RejectDailouge
