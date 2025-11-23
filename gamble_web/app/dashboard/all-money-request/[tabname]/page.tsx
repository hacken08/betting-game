'use client'
import { BiMoneyWithdraw } from "react-icons/bi";
import React from 'react'
import { TbReload } from "react-icons/tb";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
// import { Divider, Tag } from "antd";

import AddMoney from '../add-money';
import WithdrawMoney from '../withdraw-mony';
import { FaMoneyBillTrendUp } from 'react-icons/fa6';
import { useRouter } from "next/navigation";

const AllAddMoney = ({ params }: { params: { tabname: string } }) => {
    const route = useRouter()

    return (
        <div>
            <div className="flex gap-2 items-center my-5 flex-row justify-between md:flex-row">
                <button className="mr-4 text-white text-sm bg-blue-500 hover:bg-blue-600 h-8 py-1 px-2 rounded-md">
                    <TbReload className="text-lg" />
                </button>
                {
                    <button className="w-full md:w-32  mr-2 text-white h-8 text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md">
                        Generate request
                    </button>
                }
            </div>
            <div className=" bg-white px-4 rounded-md w-full justify-center gap-3 items-center">
                {/* <TableHead className="border text-center">GPay</TableHead>
                  <TableHead className="border text-center">Phone Pay</TableHead>
                  <TableHead className="border text-center">Paytm</TableHead>
                  <TableHead className="border text-center">PayPal QR</TableHead> */}
                {/* <Switch id="toggle-add" /> */}
                {/* withdraw and add money tabs */}
                <Tabs defaultValue={params.tabname} className="w-full flex flex-col mt-2 ">
                    <TabsList className=" sm:m-auto m-0 sm:mb-3 ">
                        <TabsTrigger className="text-sm sm:text-lg" value="add" onClick={e => route.replace('/dashboard/all-money-request/add')}>
                            <FaMoneyBillTrendUp className="text-green-500 mr-3" />
                            <span className="break-words text-ellipsis">All add Money</span>
                        </TabsTrigger>
                        <TabsTrigger className="text-sm sm:text-lg" value="withdraw" onClick={e => route.replace('/dashboard/all-money-request/withdraw')}>
                            <BiMoneyWithdraw className="text-yellow-500 text-xl mr-3" />
                            <span className="break-words text-ellipsis">All withdraw Money</span>
                        </TabsTrigger>
                    </TabsList>

                    <TabsContent className="" value="add">
                        <AddMoney />
                    </TabsContent>

                    <TabsContent value="withdraw">
                        <WithdrawMoney />
                    </TabsContent>
                </Tabs>

            </div>
        </div>
    )
}

export default AllAddMoney
