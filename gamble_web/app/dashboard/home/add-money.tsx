import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

import React, { useEffect, useMemo, useState } from 'react'

//  icons...
import { IoCloseCircleSharp, IoTimeSharp } from "react-icons/io5";
import { FaCircleExclamation } from "react-icons/fa6";
import { FaCheckCircle } from "react-icons/fa";
import { MdPlaylistAddCheckCircle } from "react-icons/md";
import SearchFiedls from "@/components/Dashboard/SearchFiedls";
import PendingRequestCard from "@/components/infoCards/PendingResultCard";
import ProcessingResultCard from "@/components/infoCards/ProcessingResultCard";
import ApproveRequestCard from "@/components/infoCards/ApproveRequestCard";
import FilterField from "@/components/Dashboard/FilterField";
import EnteriesRequestCard from "@/components/infoCards/EnteriesRequestCard";
import RejetedRequestCard from "@/components/infoCards/RejetedRequestCard";
import { init } from "next/dist/compiled/webpack/webpack";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { getCookie } from "cookies-next";
import { toast } from "react-toastify";
import { AxiosError } from "axios";
import { Skeleton } from "antd";
import SkeletonButton from "antd/es/skeleton/Button";
import SkeletonImage from "antd/es/skeleton/Image";
import SkeletonNode from "antd/es/skeleton/Node";
import SkeletonAvatar from "antd/es/skeleton/Avatar";
import { MoneyDepositeModel, MoneyDepositeSearchPayload, MoneyDepositWithRelations, PaymentStatus } from "@/models/MoneyDeposite";

export default function AddMoney() {
    const [depositeRequests, setDepositeRequests] = useState<MoneyDepositWithRelations[]>([]);
    const [isLoading, setIsLoading] = useState(false)
    const [currentTab, setTab] = useState("add");

    // fetching user id of logined user
    const userId: number =  useMemo(() => {
        const userId = getCookie("id")
        if (!userId || isNaN(Number(userId))) {
            toast.error("User id not found. Please login again")
            return 0;
        }
        return parseInt(userId)
    }, []);

    
    async function init(): Promise<void> {
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
            console.log(response);
            setDepositeRequests(response?.data.data as MoneyDepositWithRelations[])
        } catch (error) {
            const asioError: AxiosError = error as AxiosError;
            toast.error(asioError.message);
        } 
        setIsLoading(false)
    }    

    async function searchDepositeRequests(query: MoneyDepositeSearchPayload): Promise<void> {
        setIsLoading(true)
        try {
            const response = await makeApiRequeest(
                `${BASE_URL}/api/deposite/get`,
                HttpMethodType.POST,
                {  includeToke: true, 
                    bodyParam: query
                }
            )
            console.log(response);
            setDepositeRequests(response?.data.data as MoneyDepositWithRelations[])
        } catch (error) {
            const asioError: AxiosError = error as AxiosError;
            toast.error(asioError.message);
        } 
        setIsLoading(false)
    }   

    const stateUpdateForDepositeRequest = async (
        depositeReqId: number, 
        status: PaymentStatus, 
        workerId?: number
    ) => {
        console.log("Updating parent's deposite list state");
        let existedRequest = depositeRequests;
        const updatedRequest = existedRequest.map((req, index) => {
            if (req.id === depositeReqId) req.payment_status = status;
            if (workerId && depositeReqId === req.id) req.worker_id = workerId;
            return req;
        }).filter((req) => req.worker_id === userId);
        setDepositeRequests(updatedRequest);
        console.log("After state change  -> ", depositeRequests);
    }

    useEffect(() => {
        init();
    }, []);

    return (
        <div>
            <div className="flex gap-5 justify-between items-center">
                <div className="flex gap-2 items-center my-5 flex-row justify-center md:flex-row">
                </div>
                {/* <div className="p-2 text-center">
                    <div className=" text-[12px]  sm:text-medium"> Add limit: 234</div>
                </div> */}
            </div>


            <Tabs defaultValue="pending" className="w-full flex flex-col mt-0 ">
                {/* ---- navigation buttons ---- */}
                <TabsList className=" mx-auto bg-transparent sm:mb-0 mb-12 flex flex-wrap">
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
                    <TabsTrigger value="entries" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-red-400 font-semibold  text-sm shadow-sm ">
                        < MdPlaylistAddCheckCircle className="text-lg mr-1" />
                        Entries
                    </TabsTrigger>
                    <TabsTrigger value="rejected" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-purple-500 font-semibold text-sm shadow-sm ">
                        <IoCloseCircleSharp className="text-base mr-1" />
                        Rejected
                    </TabsTrigger>
                </TabsList>

                {/* ---- pending content ---- */}
                <TabsContent value="pending" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls onSearch={(query) => {}} placeholder="All" />
                        <SearchFiedls onSearch={(query) => {
                            searchDepositeRequests({
                                user_id: parseInt(query ?? "0"), 
                                payment_status: PaymentStatus.PENDING
                            });
                        }} 
                        onChange={(event) => { 
                            if (event.target.value.length === 0) init(); 
                        }}
                        placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        { isLoading 
                            ? Array.from([1,2,3,4,5,6,7,8,9]).map((val, index) => {
                                return <SkeletonNode key={index} active className="w-[100px] h-64 rounded-md"/>
                            }) 
                            : depositeRequests.filter((depositeReq) => depositeReq.payment_status === "PENDING")
                                .map((val: MoneyDepositWithRelations, index) => {
                            return (
                                <PendingRequestCard 
                                    key={index} 
                                    depositeMoney={val} 
                                    setParentState={stateUpdateForDepositeRequest} 
                                    showAdminInfo={false} 
                                />
                            );
                        })
                        }
                    </div>
                </TabsContent>

                {/* ---- Processing content ---- */}
                <TabsContent value="processing" className="flex flex-col w-full justify-center items-center">
                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        { depositeRequests.filter((depositeReq) => depositeReq.payment_status === "PROCESSING")
                            .map((val: MoneyDepositWithRelations, index) => {
                                return (
                                    <ProcessingResultCard key={index} setParentState={stateUpdateForDepositeRequest}  depositeMoney={val}  showAdminInfo={false} />
                                );
                            })
                        }
                    </div>
                </TabsContent>

                {/* ---- approved content ---- */}
                <TabsContent value="approved" className="flex flex-col w-full m-0 justify-center items-center">
                    <div className="w-[250px] sm:w-[400px] flex flex-col gap-2 m-2 sm:mt-10 items-center">
                        <SearchFiedls placeholder="Enter UTR" />
                        <FilterField />
                        <SearchFiedls 
                            onSearch={(query) => {
                                searchDepositeRequests({
                                    worker_id: parseInt(query ?? "0"),
                                    payment_status: PaymentStatus.ACCEPT
                                });
                            }}     
                            onChange={(event) => {
                                if (event.target.value.length === 0) init();
                            }}
                            placeholder="User id" 
                        />
                    </div>
                    <div className="flex flex-wrap justify-center gap-5 my-5 items-center">
                        { depositeRequests.filter((depositeReq) => depositeReq.payment_status === "ACCEPT")
                            .map((val: MoneyDepositWithRelations, index)=> {
                            return (
                                <ApproveRequestCard key={index} depositeMoney={val} showAdminInfo={false} />
                            );
                        })}
                    </div>
                </TabsContent>

                {/* ---- entries content ---- */}
                <TabsContent value="entries" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User id" />
                    </div>
                    <div className="flex flex-wrap justify-center gap-5 my-9">
                        { depositeRequests.filter((depositeReq) => depositeReq.payment_status === "REFUNDED")
                            .map((val: MoneyDepositWithRelations, index)=> {
                            return (
                                <EnteriesRequestCard key={index} showAdminInfo={false} />
                            );
                        })}
                    </div>
                </TabsContent>

                {/* ---- Rejected content ---- */}
                <TabsContent value="rejected" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        { depositeRequests.filter((depositeReq) => depositeReq.payment_status === "REJECT")
                            .map((val: MoneyDepositWithRelations, index) => {
                            return (
                                <RejetedRequestCard key={index} depositeMoney={val} showAdminInfo={false}/>
                            );
                        })}
                    </div>
                </TabsContent>
            </Tabs>

        </div>
    )
}

