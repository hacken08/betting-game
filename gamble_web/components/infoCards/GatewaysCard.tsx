import React, { MutableRefObject, useEffect, useRef, useState } from 'react'
import { Image, Tag, Switch } from 'antd';
import { AlertDialog, AlertDialogCancel, AlertDialogContent, AlertDialogTrigger, AlertDialogTitle } from '../ui/alert-dialog'
import { Button } from '../ui/button';
import { IoMdClose } from 'react-icons/io';
// import { Switch } from '../ui/switch';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '../ui/table';
import { WorkersAccount } from '@/models/workerAccountModel';
import { BASE_URL } from '@/lib/const';
import { toast } from 'react-toastify';
import { getCookie, getCookies } from 'cookies-next';
import { boolean, set } from 'valibot';
import { HttpMethodType, makeApiRequeest } from '@/lib/api/untils';
import { cookies } from 'next/headers';
import { AxiosError } from 'axios';


const gatewaySwitchHandler = async (
    val: boolean,
    gatewayId: number,
    statuses: string[],
    setMakePayment: (val: boolean) => void,
    setStatuses: (val: string[]) => void): Promise<boolean> => {

    const userId = getCookie("id")
    if (userId === undefined) {
        toast.error("error fetching user id")
        return false;
    }

    try {
         await makeApiRequeest(
            `${BASE_URL}/api/account/update_account_status`,
            HttpMethodType.POST,
            {
                makeNewTokenReq: true, includeToke: true,
                bodyParam: { worker_id: parseInt(userId), gateway_id: gatewayId, status: "INACTIVE" }
            }
        )
        setMakePayment(val);
        setStatuses(statuses.map(e => "INACTIVE"))
        return true;
    } catch (error) {
        console.log(error as AxiosError);
        toast.error("Error turning payment off")
    }
    return false;
}


const updateAccountStatusHandler = async (
    newStatus: string,
    accountId: number,
    statuses: string[],
    index: number,
    gatewayId: number,
    previousActiveId: MutableRefObject<number>,
    stateFn: (val: boolean) => void,
    setStatuses: (val: any[]) => void) => {
    const userId = getCookie("id")
    if (userId === undefined) {
        toast.error("error fetching user id")
        return;
    }
    try {
        const response = await makeApiRequeest(
            `${BASE_URL}/api/account/update_account_status`,
            HttpMethodType.POST,
            {
                makeNewTokenReq: true, includeToke: true,
                bodyParam: {
                    id: accountId,
                    worker_id: parseInt(userId),
                    gateway_id: gatewayId,
                    status: newStatus
                }
            }
        )
        //  Memorzing previous active id
        previousActiveId.current = accountId

        //  making other aacount inactive
        const updatedStatuses = statuses.map(e => "INACTIVE")
        updatedStatuses[index] = newStatus
        setStatuses(updatedStatuses);

        //  Updating switch state based on if active account
        for (let val of updatedStatuses) {
            if (val === "ACTIVE") {
                stateFn(true);
                return true;
            }
        }
        stateFn(false);


    } catch (error) {
        console.log(error);
        toast.error("Error turning payment off")
    }

    return false;
}


const UpiGatewaysCard = (probs: any) => {
    const workerAccout = probs.accounts as WorkersAccount[];
    const [makePayment, setMakePayment] = useState<boolean>(false)
    const [statuses, setStatuses] = useState(workerAccout.map(val => val.status))
    const [displayGatewayMethod, setDisplayGatewayMethod] = useState<string>("UPI'd")

    const previousActiveId = useRef(-1);
    const height = probs.height ? probs.height : 43;

    function findingActiveAccount() {
        for (let val of workerAccout) {
            if (val.status === "ACTIVE") {
                setDisplayGatewayMethod(val.upi_address)
                setMakePayment(true);
                break;
            }
        }
    }

    useEffect(() => {
        findingActiveAccount()
    }, [])

    return (
        <div className="flex flex-col  gap-3 items-center">
            <Switch
                checked={makePayment}
                onChange={async value => {
                    if (value) {
                        const newActiveGateway = workerAccout.filter((item, index) => item.id === previousActiveId.current)[0]
                        const indexOfprevActiveGateay = workerAccout.indexOf(newActiveGateway)
                        await makeApiRequeest(
                            `${BASE_URL}/api/account/update_account_status`,
                            HttpMethodType.POST,
                            {
                                makeNewTokenReq: true, includeToke: true,
                                bodyParam: {
                                    id: newActiveGateway.id,
                                    worker_id: parseInt(getCookie("id")!),
                                    gateway_id: newActiveGateway.gateway_id,
                                    status: "ACTIVE"
                                }
                            }
                        )
                        console.log("upi on");
                        setDisplayGatewayMethod(newActiveGateway.upi_address)
                        setStatuses(statuses.map((value, index) => index === indexOfprevActiveGateay ? "ACTIVE" : "INACTIVE"))
                        setMakePayment(value)
                        return;
                    }

                    gatewaySwitchHandler(
                        value,
                        parseInt(probs.gatewayId),
                        statuses,
                        setMakePayment,
                        setStatuses,
                    )
                    setDisplayGatewayMethod("UPI'd")
                }}
                className='bg-gray-200 hover:bg-gray-300' >
            </Switch>
            <AlertDialog>
                <AlertDialogTrigger>
                    <div className="border text-center overflow-hidden flex items-center flex-col justify-start py-1 px-3 h-24 rounded-md w-20">
                        <Image
                            width={probs.width}
                            height={height}
                            preview={false}
                            className="my-2 flex"
                            src={probs.img}
                            alt=""
                        />
                        <div className="grow"></div>
                        <div className="h-[0.5px] w-full bg-black my-1"></div>
                        <div className="flex gap-3 items-center">
                            <span className={`text-center mb-1 ${displayGatewayMethod !== "UPI'd" && " animate-marquee relative left-0"}`}>{displayGatewayMethod}</span>
                            {displayGatewayMethod !== "UPI'd" &&
                                <span className={`text-center mb-1 ${displayGatewayMethod !== "UPI'd" && " animate-marquee relative left-0"}`}>{displayGatewayMethod}</span>
                            }
                        </div>
                    </div>
                </AlertDialogTrigger>

                {/* Gpay upi options  */}
                <AlertDialogContent>
                    <div className="flex flex-col m-0 p-0">

                        <AlertDialogTitle>
                            <div className="flex justify-start items-center">
                                <span className="font-medium pr-6">
                                    Gateway details ({probs.gatewayName})
                                </span>
                                {/* Imageg className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                                <div className="grow"></div>

                                <Button className="rounded-md py-1 px-4 bg-red-500 mr-4 text-white">
                                    Clear
                                </Button>
                                <AlertDialogCancel>
                                    <IoMdClose />
                                </AlertDialogCancel>
                            </div>
                        </AlertDialogTitle>

                        <div className="flex justify-start my-7 border border-x-white">
                            <span className=" pr-12">No.</span>
                            <div className="grow">UPI I&apos;d</div>
                            <div className="grow"></div>
                            <div>Status</div>
                        </div>

                        {
                            workerAccout.map((account: WorkersAccount, index: number) => {
                                const currentStatus = statuses[index];
                                return <div key={index} className="flex mb-5 justify-start border-x-white">
                                    <span className=" pr-12"> {++index}.</span>
                                    <div className="grow">{account.upi_address}</div>
                                    <div className="grow"></div>
                                    <Tag
                                        onClick={async e => {
                                            const isSuccess = await updateAccountStatusHandler(
                                                currentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE",
                                                account.id,
                                                statuses,
                                                --index,
                                                parseInt(probs.gatewayId),
                                                previousActiveId,
                                                setMakePayment, setStatuses);
                                            isSuccess
                                                ? setDisplayGatewayMethod(account.upi_address)
                                                : setDisplayGatewayMethod("UPI'd")

                                        }}
                                        color={currentStatus === "ACTIVE" ? `green` : `red`}
                                        className=' cursor-pointer'
                                    >
                                        {currentStatus}
                                    </Tag>
                                </div>
                            })
                        }
                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </div >
    )
}


const QRGatewaysCard = (probs: any) => {
    const [makePayment, setMakePayment] = useState<boolean>(false)
    const workerAccout = probs.accounts as WorkersAccount[];
    const [statuses, setStatuses] = useState(workerAccout.map(val => val.status))
    const previousActiveId = useRef(-1);

    useEffect(() => {
        for (let val of workerAccout) {
            if (val.status === "ACTIVE") {
                setMakePayment(true);
                break;
            }
        }
    }, [])
    return (
        <div>
            <div className="flex flex-col gap-3 items-center">
                <Switch
                    checked={makePayment}
                    onChange={async value => {
                        if (value) {
                            const newActiveGateway = workerAccout.filter((item, index) => {
                                const updatedStatuses = statuses.map(e => "INACTIVE")
                                updatedStatuses[index] = "ACTIVE"
                                setStatuses(updatedStatuses);
                                return item.id === previousActiveId.current;
                            })[0]
                            setMakePayment(value)
                            return;
                        }

                        gatewaySwitchHandler(
                            value,
                            parseInt(probs.gatewayId),
                            statuses,
                            setMakePayment,
                            setStatuses)
                    }}
                    className='bg-gray-200 hover:bg-gray-300' ></Switch>
                <AlertDialog>
                    <AlertDialogTrigger>
                        <div className="border text-center overflow-hidden flex items-center flex-col justify-start py-1 px-3 h-24 rounded-md w-20">
                            <Image
                                width={probs.width}
                                height={probs.width}
                                preview={false}
                                className="my-2 flex w-30 "
                                src={probs.img}
                                alt=""

                            />
                            <div className="grow"></div>
                            <div className="h-[0.5px] w-full bg-black my-1"></div>
                            <span className="text-center text-sm mb-1">QR code</span>
                        </div>
                    </AlertDialogTrigger>
                    <AlertDialogContent>
                        <div className="flex flex-col m-0 p-0">
                            <div className="flex justify-start items-center">
                                <span className="font-medium pr-6">
                                    Gateway details ({probs.gatewayName})
                                </span>
                                {/* Imageg className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                                <div className="grow"></div>

                                <Button className="rounded-md py-1 px-4 bg-red-500 mr-4 text-white">
                                    Clear
                                </Button>
                                <AlertDialogCancel>
                                    <IoMdClose />
                                </AlertDialogCancel>
                            </div>

                            <div className="flex justify-start my-7 border border-x-white">
                                <span className=" pr-12">No.</span>
                                <div className="grow">QRs</div>
                                <div className="grow">Name</div>
                                <div>Status</div>
                            </div>

                            {
                                workerAccout.map((account: WorkersAccount, index: number) => {
                                    const currentStatus = statuses[index];

                                    return <div key={index} className="flex mb-3 justify-start items-center border-x-white">
                                        <span className=" pr-12"> {++index}.</span>
                                        {/* <div className="grow"></div> */}
                                        <Image
                                            width={50}
                                            className=" w-20"
                                            src={`${BASE_URL}/${account.qr_image}`}
                                            alt=""
                                        />
                                        <div className="grow"></div>
                                        <div className="grow">QR name</div>
                                        <Tag
                                            onClick={e => updateAccountStatusHandler(
                                                currentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE",
                                                account.id,
                                                statuses,
                                                --index,
                                                parseInt(probs.gatewayId),
                                                previousActiveId,
                                                setMakePayment, setStatuses)}
                                            color={currentStatus === "ACTIVE" ? `green` : `red`}
                                            className=' cursor-pointer'
                                        >
                                            {currentStatus}
                                        </Tag>
                                    </div>
                                })
                            }
                        </div>
                    </AlertDialogContent>
                </AlertDialog>
            </div>
        </div>
    )
}


const BankGatewayCard = (probs: any) => {
    const [makePayment, setMakePayment] = useState<boolean>(false)
    const workerAccout = probs.accounts as WorkersAccount[];
    const [statuses, setStatuses] = useState(workerAccout.map(val => val.status))
    const previousActiveId = useRef(-1);

    useEffect(() => {
        for (let val of workerAccout) {
            if (val.status === "ACTIVE") {
                setMakePayment(true);
                break;
            }
        }
    }, [])

    return (
        <div>
            <div className="flex flex-col gap-3 items-center">
                <Switch checked={makePayment}
                    onChange={async value => {
                        if (value) {
                            workerAccout.filter((item, index) => {
                                const updatedStatuses = statuses.map(e => "INACTIVE")
                                updatedStatuses[--index] = "ACTIVE"
                                setStatuses(updatedStatuses);
                                return item.id === previousActiveId.current;
                            })[0]
                            setMakePayment(value)
                            return;
                        }

                        gatewaySwitchHandler(
                            value,
                            parseInt(probs.gatewayId),
                            statuses,
                            setMakePayment,
                            setStatuses)
                    }}
                    className='bg-gray-200 hover:bg-gray-300' ></Switch>
                <AlertDialog>
                    <AlertDialogTrigger>
                        <div className="border text-center flex items-center flex-col justify-start py-1 px-3 h-24 rounded-md w-20">
                            <Image
                                width={probs.width}
                                height={probs.width}
                                preview={false}
                                className="my-2 flex"
                                src={probs.img}
                                alt=""

                            />
                            <div className="grow"></div>
                            <div className="h-[0.5px] w-full bg-black my-1"></div>
                            <span className="text-center text-sm mb-1">BANK</span>
                        </div>
                    </AlertDialogTrigger>
                    <AlertDialogContent className='p-0 px-2'>
                        <div className="flex justify-start items-center px-4 pt-4">
                            <span className="font-medium pr-6">
                                Gateway details ({probs.gatewayName})
                            </span>
                            <div className="grow"></div>

                            <Button className="rounded-md py-1 px-4 bg-red-500 mr-4 text-white">
                                Clear
                            </Button>
                            <AlertDialogCancel>
                                <IoMdClose />
                            </AlertDialogCancel>
                        </div>
                        <Table className="">
                            <TableHeader className=' h-0'>
                                <TableRow className="">
                                    <TableHead className="text-left">No</TableHead>
                                    <TableHead className="text-left">Bank Details</TableHead>
                                    <TableHead className="text-right">Status</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody className="">
                                {workerAccout.map((account: WorkersAccount, index) => {
                                    const currentStatus = statuses[index];

                                    return (
                                        <TableRow className="" key={index}>
                                            <TableCell className="text-left min-w-15">{++index}. </TableCell>
                                            <TableCell className="text-left font-medium">
                                                <div className="font-normal">
                                                    <span className='text-sm font-semibold'>Bank: </span>
                                                    {account.bank_name}
                                                </div>
                                                <div className="font-normal">
                                                    <span className='text-sm font-semibold'>AC number: </span>
                                                    {account.account_number}
                                                </div>
                                                <div className="font-normal">
                                                    <span className='text-sm font-semibold'>AC holder: </span>
                                                    {account.account_holder}
                                                </div>
                                                <div className="font-normal">
                                                    <span className='text-sm font-semibold'>IFCE: </span>
                                                    {account.ifsc_code}
                                                </div>
                                            </TableCell>
                                            <TableCell className="text-right">
                                                <Tag
                                                    onClick={e => updateAccountStatusHandler(
                                                        currentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE",
                                                        account.id,
                                                        statuses,
                                                        --index,
                                                        parseInt(probs.gatewayId),
                                                        previousActiveId,
                                                        setMakePayment, setStatuses)}
                                                    color={currentStatus === "ACTIVE" ? `green` : `red`}
                                                    className=' cursor-pointer'
                                                >
                                                    {currentStatus}
                                                </Tag>
                                            </TableCell>
                                        </TableRow>
                                    )
                                })}
                            </TableBody>

                        </Table>
                        {/* <div className="flex flex-col m-0 p-0">
                            <div className="flex justify-start items-center">
                                <span className="font-medium pr-6">
                                    Payment gateway details (GPay)
                                </span>
                                <div className="grow"></div>

                                <Button className="rounded-md py-1 px-4 bg-red-500 mr-4 text-white">
                                    Clear
                                </Button>
                                <AlertDialogCancel>
                                    <IoMdClose />
                                </AlertDialogCancel>
                            </div>

                            <div className="flex justify-start my-7 border border-x-white">
                                <span className=" pr-12">No.</span>
                                <div className="grow">UPI I&apos;d</div>
                                <div className="grow"></div>
                                <div>Status</div>
                            </div>

                            <div className="flex mb-3 justify-start items-center border-x-white">
                                <span className=" pr-12"> 1.</span>
                                <Image
                                    width={50}
                                    className=" w-20"
                                    src="https://upload.wikimedia.org/wikipedia/commons/d/d0/QR_code_for_mobile_English_Wikipedia.svg"
                                    alt=""
                                />
                                <div className="grow"></div>
                                <div>Active</div>
                            </div>
                        </div> */}
                    </AlertDialogContent>
                </AlertDialog>
            </div>
        </div>
    )
}

export { QRGatewaysCard, BankGatewayCard, UpiGatewaysCard };


