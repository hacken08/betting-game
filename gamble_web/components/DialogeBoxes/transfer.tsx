import { AlertDialog, AlertDialogCancel, AlertDialogContent, AlertDialogTrigger } from '@/components/ui/alert-dialog'
import { Label } from "@/components/ui/label";
// import { Checkbox } from "@/components/ui/checkbox"
import { Button } from '@/components/ui/button'
import { FaSearch } from "react-icons/fa";
import React, { useEffect, useMemo, useRef, useState } from 'react'
import { IoMdClose } from "react-icons/io";
import { Input, Checkbox } from "antd";
import { User } from '@/models/UserModel';
import { Role } from '@/schema/create';
import { getUserByRole } from '@/lib/api/userApis';
import { toast } from 'react-toastify';
import { updateDepositeRequestApi } from '@/lib/api/moneyDeposte';
import { AddMoneyProbParams, MoneyDepositWithRelations, PaymentStatus } from '@/models/MoneyDeposite';
import { getCookie } from 'cookies-next';


type ProbsParam = {
    withdraw?: boolean,
    depositeReqest?: MoneyDepositWithRelations,
    setDepositeReqState?: (
        depositeReqId: number,
        status: PaymentStatus,
        workerId?: number,
    ) => Promise<void>;
}


const TransferDailouge = ({depositeReqest, setDepositeReqState}: ProbsParam) => {
    const [workers, setWorkers] = useState<User[]>([])
    const [loading, setLoading] = useState<boolean>(false);
    const [workerToTransfer, setWorkerToTransfer] = useState<User>()
    const [selectedWorkerId, setSelectedWorkerId] = useState<number | null>(null);
    const alertDialogRef = useRef<HTMLButtonElement  | null>(null)
    const userId: number =  useMemo(() => {
        const userId = getCookie("id")
        if (!userId || isNaN(Number(userId))) {
            toast.error("User id not found. Please login again")
            return 0;
        }
        return parseInt(userId)
    }, []);
    
    const init = async () => {
        setLoading(true);
        const workers = await getUserByRole(Role.WORKER, 0, 10);
        if (!workers) return;
        setWorkers(workers.filter((value) => value.id !== userId));
        setLoading(false);
    }
    
    const onSelect = (checked: boolean, workerSelected: User) => {
        if (checked) {
            setWorkerToTransfer(workerSelected);
            setSelectedWorkerId(workerSelected.id);
        } else {
            setWorkerToTransfer(undefined);
            setSelectedWorkerId(null);
        }
    };

    const handleOnTranfer = () => {
        if (!depositeReqest) {
            toast.error("Something went wrong");
            return;
        }
        if (!workerToTransfer) {
            toast.error("Please select a worker to transfer");
            return;
        }
        updateDepositeRequestApi({
            id: depositeReqest.id,
            worker_id: workerToTransfer.id,
        })
        setDepositeReqState 
            ? setDepositeReqState(
                depositeReqest.id,
                depositeReqest.payment_status,
                workerToTransfer.id
              ) 
            : undefined
        alertDialogRef.current?.click()
        toast.success(`Request is tranfer to ${workerToTransfer?.username ?? ""}`)
    }

    useEffect(() => {
        init();        
        return undefined;
    }, [])
    
    
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger>
                    <Button className="bg-transparent text-red-500 hover:bg-transparent hover:text-red-700 ">
                    {"-> Transfer"}
                    </Button>
                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent>
                    <div>
                        <div className="flex flex-col m-0 p-0">
                            <div className="flex justify-start items-center">
                                <span className="font-medium pr-6 text-[#4ca091]">
                                    Transfer Request
                                </span>
                                {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                                <div className="grow"></div>
                                <AlertDialogCancel ref={alertDialogRef} className="hover:bg-[#4ca091] hover:text-white">
                                    <IoMdClose className="" />
                                </AlertDialogCancel>
                                </div>

                                <div className="grid w-full my-3 mt-10 max-w-sm items-center gap-3.5">
                                <Label htmlFor="picture">Search</Label>
                                <div className="flex w-full">
                                    <Input className="rounded-r-none rounded-l-2xl" id="picture" type="text" placeholder="Search here" />
                                    <Button className="rounded-l-none rounded-r-2xl  flex justify-self-start bg-[#4ca091] px-8">< FaSearch /></Button>
                                </div>
                            </div>

                            {/* ----------- search result ----------- */}
                            <div className="flex flex-col w-full my-3 mt-7 max-w-sm items-start justify-start gap-3">
                                {loading ? (
                                    <div>Loading...</div>
                                ) : (
                                    workers.map((worker) => (
                                    <div key={worker.id} className="flex justify-start items-center gap-3">
                                        <Checkbox 
                                            checked={worker.id === selectedWorkerId}
                                            onChange={(e) => onSelect(e.target.checked, worker)} 
                                        />
                                        <span className="font-semibold mb-1">{worker.username}</span>
                                    </div>
                                    ))
                                )}
                                </div>

                                <div className="flex justify-center mt-5">
                                <Button onClick={e=>handleOnTranfer()} className="bg-[#4ca091] w-[40%] hover:bg-[#4ca091">Transfer</Button>
                            </div>
                        </div>
                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default TransferDailouge
