import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

import React, { useEffect, useState } from 'react'
import { Input } from "antd";
import { FaCheckCircle, FaFileExcel } from "react-icons/fa";
import { IoCloseCircleSharp, IoTimeSharp } from "react-icons/io5";
import { FaArrowsRotate, FaCircleExclamation } from "react-icons/fa6";
import SearchFiedls from "@/components/Dashboard/SearchFiedls";
import ProcessingRequestCard from "@/components/WithdrawlCards/ProcessingRequestCard";
import FilterField from "@/components/Dashboard/FilterField";
import ApprovedRequestCard from "@/components/WithdrawlCards/ApprovedRequestCard";

import {
    Select,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import RejectedRequestCard from "@/components/WithdrawlCards/RejectedRequestCard";
import RefundRequestCard from "@/components/WithdrawlCards/RefundRequestCard";
import PendingExcelRequestCard from "@/components/WithdrawlCards/PendingExcelRequestCard";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { toast } from "react-toastify";
import { getCookie } from "cookies-next";
import { GetWithdrawalRequestSchema } from "@/models/WithdrawalModel";
import { PendingRequestCard, PendingRequestLoader } from "@/components/WithdrawlCards/PendingRequestCard";

export default function WithdrawMoney() {
    const [currentTab, setTab] = useState("add");
    const [isLoading, setIsLoading] = useState(false);
    const [withdrawalRequests, setWithdrawalRequests] = useState<GetWithdrawalRequestSchema[]>([]);

    const init = async () => {
        setIsLoading(true);
        const userId = getCookie("id")
        if (userId === undefined) {
            toast.error("error fetching user id")
            return;
        }
        try {
            const responseData = await makeApiRequeest(
                `${BASE_URL}/api/withdraw/get_workers_requests/${parseInt(userId)}`,
                HttpMethodType.POST,
                {
                    includeToke: true,
                    makeNewTokenReq: true
                }
            )
            
            setWithdrawalRequests(responseData?.data.data);
            setIsLoading(false);
        } catch (error: any) {
            console.error(error);
            toast.error(error.response?.data.message ?? error.message)
        }
    }

    useEffect(() => {
        init()
        return;
    }, [])

    return (
        <div className="flex flex-col items-center">

            <Tabs defaultValue="pending" className="w-full flex flex-col mt-6 ">
                {/* ---- navigation buttons ---- */}
                <TabsList className=" m-auto bg-transparent sm:mb-0 mb-12 flex flex-wrap">
                    <TabsTrigger value="excel" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-grey-400 font-semibold text-sm shadow-sm ">
                        <FaFileExcel className="mr-1" />
                        Excel
                    </TabsTrigger>
                    <TabsTrigger value="pending" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-orange-700 font-semibold text-sm shadow-sm ">
                        <IoTimeSharp className="text-base mr-1" />
                        <span className="pb-[2px]">Pending</span>
                    </TabsTrigger>
                    <TabsTrigger value="processing" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-blue-400 font-semibold  text-sm shadow-sm ">
                        < FaCircleExclamation className="mr-1" />
                        <span className="pb-[2px]">Processing</span>
                    </TabsTrigger>
                    <TabsTrigger value="approved" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-green-400 font-semibold text-sm shadow-sm ">
                        <FaCheckCircle className="mr-1" />
                        <span className="pb-[2px]">Approved</span>
                    </TabsTrigger>
                    <TabsTrigger value="rejected" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-red-400 font-semibold  text-sm shadow-sm ">
                        <IoCloseCircleSharp className="text-base mr-1" />
                        Rejected
                    </TabsTrigger>
                    <TabsTrigger value="refunded" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-purple-500 font-semibold text-sm shadow-sm ">
                        <FaArrowsRotate className="text-sm mr-1" />
                        Refunded
                    </TabsTrigger>
                    <TabsTrigger value="pending excel" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-red-400 font-semibold text-sm shadow-sm ">
                        <FaFileExcel className="mr-1" />
                        Pending excel
                    </TabsTrigger>
                </TabsList>


                {/* ---- Excel  content ---- */}
                <TabsContent value="excel" className="flex flex-col w-full justify-center items-center" >
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <Input className="" placeholder="Minimum Amount"></Input>
                        <Input className="" placeholder="Maximum Amount"></Input>

                        <div className="h-2 "></div>
                        <button className="w-full bg-green-500 py-1 rounded-md  text-white font-normal">  Sumbit</button>
                        <button className="w-full bg-zinc-400  py-1 rounded-md text-white font-normal">  Cancel</button>

                        <div className="h-2"></div>
                        <div className="w-full flex justify-between items-start">
                            <button className="bg-blue-400 text-white py-1 px-2 rounded-md">Generate</button>
                            <span className="">Total amount: 230</span>
                        </div>
                    </div>
                </TabsContent>

                {/* ---- pending content ---- */}
                <TabsContent value="pending" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start w-full gap-5 my-9 items-center">
                        {
                            isLoading
                                ? Array.from([1, 2, 3]).map((val, index) => {
                                    return (
                                        <>
                                            <PendingRequestLoader />
                                        </>
                                    )
                                })
                                : withdrawalRequests.map((withdrawalRequest: GetWithdrawalRequestSchema, index: number) => {
                                    return (
                                        <PendingRequestCard pendingWithdrawalRequest={withdrawalRequest} key={index} showAdminInfo={false} />
                                    );
                                })
                        }
                    </div>
                </TabsContent>

                {/* ---- processing content ---- */}
                <TabsContent value="processing" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <ProcessingRequestCard key={index} showAdminInfo={false} />
                            );
                        })}
                    </div>
                </TabsContent>

                {/* ---- Approved content ---- */}
                <TabsContent value="approved" className="flex flex-col w-full justify-center items-center" >
                    <div className="w-[250px] sm:w-[400px] flex flex-col gap-2 mt-10 items-center">
                        <FilterField />
                        <SearchFiedls placeholder="User Id" />
                        <div className="flex h-10 w-full mb-3 max-w-sm items-center">
                            <Select>
                                <SelectTrigger className="w-[180px] rounded-none rounded-l-md mb-1 focus:out">
                                    <SelectValue placeholder="ACC" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectGroup>
                                        <SelectItem value="apple">Account number</SelectItem>
                                        <SelectItem value="banana">Account holder name</SelectItem>
                                        <SelectItem value="blueberry">Amount</SelectItem>
                                    </SelectGroup>
                                </SelectContent>
                            </Select>
                            <SearchFiedls placeholder="Enter" className="rounded-l-none" />
                        </div>
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <ApprovedRequestCard key={index} showAdminInfo={false} />
                            );
                        })}
                    </div>
                </TabsContent>

                {/* ---- Rejcted content ---- */}
                <TabsContent value="rejected" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <RejectedRequestCard key={index} showAdminInfo={false} />
                            );
                        })}
                    </div>
                </TabsContent>

                {/* ---- Refunded content ---- */}
                <TabsContent value="refunded" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <RefundRequestCard key={index} showAdminInfo={false} />
                            );
                        })}
                    </div>
                </TabsContent>

                {/* ---- Pending excel content ---- */}
                <TabsContent value="pending excel" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <PendingExcelRequestCard key={index} showAdminInfo={false} />
                            );
                        })}
                    </div>
                </TabsContent>
            </Tabs>

        </div>
    )
}


