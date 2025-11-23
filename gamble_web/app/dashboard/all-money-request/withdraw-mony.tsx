import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

import React, { useState } from 'react'

//  icons...
import { FaArrowsRotate } from "react-icons/fa6";
import { IoCloseCircleSharp, IoTimeSharp } from "react-icons/io5";
import { FaCircleExclamation } from "react-icons/fa6";
import { FaCheckCircle } from "react-icons/fa";
import { FaFileExcel } from "react-icons/fa";
import SearchFiedls from "@/components/Dashboard/SearchFiedls";
import ProcessingRequestCard from "@/components/WithdrawlCards/ProcessingRequestCard";
import FilterField from "@/components/Dashboard/FilterField";
import { Select, SelectContent, SelectGroup, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import ApprovedRequestCard from "@/components/WithdrawlCards/ApprovedRequestCard";
import RejectedRequestCard from "@/components/WithdrawlCards/RejectedRequestCard";
import RefundRequestCard from "@/components/WithdrawlCards/RefundRequestCard";
import PendingExcelRequestCard from "@/components/WithdrawlCards/PendingExcelRequestCard";
import { PendingRequestCard } from "@/components/WithdrawlCards/PendingRequestCard";

export default function WithdrawMoney() {
    const [currentTab, setTab] = useState("add");

    return (
        <div className="flex flex-col items-center">
            <div className="flex gap-5 justify-between">
                {/* <div className="flex gap-5">
                    <div className="flex items-center space-x-2">
                        <Label htmlFor="toggle-add">Add</Label>
                        <Switch id="toggle-add" />
                    </div>
                    <div className="flex items-center space-x-2">
                        <Label htmlFor="toggle-withdraw">Withdraw</Label>
                        <Switch id="toggle-withdraw" />
                    </div>
                </div> */}
            </div>

            <Tabs defaultValue="pending" className="w-full flex flex-col mt-6 ">
                {/* ---- navigation buttons ---- */}
                <TabsList className=" m-auto bg-transparent sm:mb-0 mb-12 flex flex-wrap">

                    <TabsTrigger value="pending" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-orange-700 font-semibold text-xs sm:text-sm shadow-sm ">
                        <IoTimeSharp className="text-base mr-1" />
                        <span className="pb-[2px]">Pending</span>
                    </TabsTrigger>
                    <TabsTrigger value="processing" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-blue-400 font-semibold  text-xs sm:text-sm shadow-sm ">
                        < FaCircleExclamation className="mr-1" />
                        <span className="pb-[2px]">Processing</span>
                    </TabsTrigger>
                    <TabsTrigger value="approved" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-green-400 font-semibold text-xs sm:text-sm shadow-sm ">
                        <FaCheckCircle className="mr-1" />
                        <span className="pb-[2px]">Approved</span>
                    </TabsTrigger>
                    <TabsTrigger value="rejected" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm text-red-400 font-semibold  text-xs sm:text-sm shadow-sm ">
                        <IoCloseCircleSharp className="text-base mr-1" />
                        Rejected
                    </TabsTrigger>
                    <TabsTrigger value="refunded" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-purple-500 font-semibold text-xs sm:text-sm shadow-sm ">
                        <FaArrowsRotate className="text-sm mr-1" />
                        Refunded
                    </TabsTrigger>
                    <TabsTrigger value="pending excel" className="bg-gray-100 px-5  mx-0 py-2 rounded-sm  text-red-400 font-semibold text-xs sm:text-sm shadow-sm ">
                        <FaFileExcel className="mr-1" />
                        Pending excel
                    </TabsTrigger>
                </TabsList>


                {/* ---- pending content ---- */}
                <TabsContent value="pending" className="flex flex-col w-full justify-center items-center">
                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {/* {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                            return (
                                <PendingRequestCard  key={index} showAdminInfo={true} />
                            );
                        })} */}
                    </div>
                </TabsContent>

                {/* ---- processing content ---- */}
                <TabsContent value="processing" className="flex flex-col w-full justify-center items-center">

                    <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <SearchFiedls placeholder="User Id" />
                    </div>

                    <div className="flex flex-wrap justify-start gap-5 my-9 items-center">
                        {Array.from([1, 2, 3, 4, 6, 5]).map((val, index) => {
                            return (
                                <ProcessingRequestCard key={index} showAdminInfo={true} />
                            );
                        })}
                    </div>
                </TabsContent>

                {/* ---- Approved content ---- */}
                <TabsContent value="approved" className="flex flex-col w-full justify-center items-center" >
                    <div className="w-[250px] sm:w-[400px] flex flex-col gap-2 mt-10 items-center">
                        <SearchFiedls placeholder="All" />
                        <FilterField />
                        <SearchFiedls placeholder="User Id" />
                        <div className="flex h-10 w-full mb-3 max-w-sm items-center">
                            <Select>
                                <SelectTrigger className="w-[120px] mb-1 rounded-none rounded-l-md focus:out">
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
                                <ApprovedRequestCard key={index} showAdminInfo={true} />
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
                                <RejectedRequestCard key={index} showAdminInfo={true} />
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
                                <RefundRequestCard key={index} showAdminInfo={true} />
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
                                <PendingExcelRequestCard key={index} showAdminInfo={true} />
                            );
                        })}
                    </div>
                </TabsContent>
            </Tabs>


        </div>
    )
}


