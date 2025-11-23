"use client"


import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import React, { useEffect, useMemo, useState } from 'react'


// Icons ....
import { IoTimeSharp } from "react-icons/io5";
import { FaCheckCircle } from "react-icons/fa";
import { FaCircleExclamation } from "react-icons/fa6";
import { MdPlaylistAddCheckCircle } from "react-icons/md";
import { MdOutlinePendingActions } from "react-icons/md";
import { IoCloseCircleSharp } from "react-icons/io5";
import { GoGraph } from "react-icons/go";
import PendingRequestCard from "@/components/infoCards/PendingResultCard";
import SearchFiedls from "@/components/Dashboard/SearchFiedls";
import ProcessingResultCard from "@/components/infoCards/ProcessingResultCard";
import FilterField from "@/components/Dashboard/FilterField";
import ApproveRequestCard from "@/components/infoCards/ApproveRequestCard";
import EnteriesRequestCard from "@/components/infoCards/EnteriesRequestCard";
import PendingEntriesRequestCard from "@/components/infoCards/PendingEntriesRequestCard";
import RejectedRequestCard from "@/components/infoCards/RejectedRequestCard";
import HightToLowCard from "@/components/infoCards/hightToLowCard";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { MoneyDepositWithRelations } from "@/models/MoneyDeposite";
import { AxiosError } from "axios";
import { toast } from "react-toastify";
import { getCookie } from "cookies-next";



export default function AddMoney() {
    const [currentTab, setTab] = useState("pending");
    const [depositeRequests, setDepositeRequests] = useState<MoneyDepositWithRelations[]>([]);
    const [isLoading, setIsLoading] = useState(false)
    // fetching user id of logined user
    const userId: number =  useMemo(() => {
        const userId = getCookie("id")
        if (!userId || isNaN(Number(userId))) {
            toast.error("User id not found. Please login again")
            return 0;
        }
        return parseInt(userId)
    }, []);

    
    
    const init = async (): Promise<void> => {
        setIsLoading(true)
        try {
            const response = await makeApiRequeest(
                `${BASE_URL}/api/deposite/get`,
                HttpMethodType.POST,
                {  includeToke: true, 
                    bodyParam: { 
                        "worker_id": userId
                    } 
                }
            )
            setDepositeRequests(response?.data.data as MoneyDepositWithRelations[])
        } catch (error) {
            const asioError: AxiosError = error as AxiosError;
            toast.error(asioError.message);
        } 
        setIsLoading(false)
    }   

    console.log(depositeRequests);
    
    
    useEffect(() => {init()}, []) 


    return (
        <div>
            <Tabs value={currentTab} className="w-full  flex flex-col sm:mt-2">
                <TabsList className=" mx-auto sm:mb-0 mb-24 bg-transparent w-full flex flex-wrap">
                    <TabsTrigger
                        onClick={e => setTab("pending")}
                        value="pending" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-orange-700 flex items-center gap-1 font-semibold text-xs sm:text-sm shadow-sm ">
                        <IoTimeSharp className="text-base" />
                        <span className="pb-[2px]">Pending</span>
                    </TabsTrigger>
                    <TabsTrigger
                        onClick={e => setTab("processing")}
                        value="processing" className="bg-gray-100 px-5 flex items-center gap-1  mx-0 py-2 rounded-sm text-blue-400 font-semibold  text-xs sm:text-sm shadow-sm ">
                        < FaCircleExclamation />
                        <span className="pb-[2px]">Processing</span>
                    </TabsTrigger>
                    <TabsTrigger
                        onClick={e => setTab("approved")}
                        value="approved"
                        className="bg-gray-100 px-5  mx-0 py-2 flex items-center gap-1 rounded-sm  text-green-400 font-semibold text-xs sm:text-sm shadow-sm ">
                        <FaCheckCircle />
                        <span className="pb-[2px]">Approved</span>
                    </TabsTrigger>
                    <TabsTrigger
                        onClick={e => setTab("entries")}
                        value="entries" className="bg-gray-100 px-5  flex items-center gap-1 mx-0 py-2 rounded-sm text-zinc-600 font-semibold  text-xs sm:text-sm shadow-sm ">
                        < MdPlaylistAddCheckCircle className="text-lg" />
                        Entries
                    </TabsTrigger>
                    <TabsTrigger
                        onClick={e => setTab("pending entries")}
                        value="pending entries" className="bg-gray-100 px-5 flex items-center gap-1  mx-0 py-2 rounded-sm text-purple-400 font-semibold  text-xs sm:text-sm shadow-sm ">
                        <MdOutlinePendingActions className="text-lg" />
                        Pending entries
                    </TabsTrigger>
                    <TabsTrigger
                        onClick={e => setTab("rejected")}
                        value="rejected" className="bg-gray-100 px-5  flex items-center gap-1 mx-0 py-2 rounded-sm  text-red-500 font-semibold text-xs sm:text-sm shadow-sm ">
                        <IoCloseCircleSharp className="text-base" />
                        Rejected
                    </TabsTrigger>
                    <TabsTrigger
                        onClick={e => setTab("hight to low")}
                        value="hight to low" className="bg-gray-100 px-5  flex items-center gap-1 mx-0 py-2 rounded-sm  text-purple-500 font-semibold text-xs sm:text-sm shadow-sm ">
                        <GoGraph className="text-base" />
                        High to low
                    </TabsTrigger>
                </TabsList>

                {/* ---- pending content ---- */}
                <TabsContent value="pending" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {depositeRequests.filter((depositeReq) => depositeReq.payment_status === "PENDING")
                            .map((val, index) => {
                                return (
                                    <PendingRequestCard depositeMoney={val} key={index} showAdminInfo={true} />
                                );
                            })
                        }
                    </div>
                </TabsContent>

                {/* ---- Processing content ---- */}
                <TabsContent value="processing" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {depositeRequests.filter((depositeReq) => depositeReq.payment_status === "PROCESSING")
                            .map((val, index) => {
                            return (
                                <ProcessingResultCard depositeMoney={val} key={index} showAdminInfo={true} />
                            );
                        })
                        }
                    </div>
                </TabsContent>

                {/* ---- approved content ---- */}
                <TabsContent value="approved" className="flex flex-col w-full m-0 justify-center items-center">
                    <div className="w-[250px] sm:w-[400px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="Enter UTR" />
                        <FilterField />
                        <SearchFiedls placeholder="User I'd" />
                    </div>
                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {
                            depositeRequests.filter((depositeReq) => depositeReq.payment_status === "ACCEPT")
                                .map((val, index) => {
                                return (
                                    <ApproveRequestCard depositeMoney={val} key={index} showAdminInfo={true} />
                                );
                            })
                        }
                    </div>

                </TabsContent>

                {/* ---- entries content ---- */}
                <TabsContent value="entries" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>
                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <EnteriesRequestCard key={index} showAdminInfo={true} />
                            );
                        })
                        }
                    </div>
                </TabsContent>

                {/* ---- pending entries content ---- */}
                <TabsContent value="pending entries" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <PendingEntriesRequestCard key={index} showAdminInfo={true} />
                            );
                        })
                        }
                    </div>
                </TabsContent>

                {/* ---- rejected content ---- */}
                <TabsContent value="rejected" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <RejectedRequestCard key={index} showAdminInfo={true} />
                            );
                        })
                        }
                    </div>
                </TabsContent>

                {/* ---- hight to low content ---- */}
                <TabsContent value="hight to low" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <HightToLowCard key={index} showAdminInfo={true} />
                            );
                        })
                        }
                    </div>
                </TabsContent>
            </Tabs>

        </div>
    )
}

