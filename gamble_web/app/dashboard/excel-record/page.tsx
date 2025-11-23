"use client";

import { FaDownload } from "react-icons/fa";
import {
    Table,
    TableBody,
    TableCaption,
    TableCell,
    TableFooter,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import React, { useState } from 'react'
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { create } from "domain";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Tag } from "antd";
import { Input } from "@/components/ui/input";


const ExcelRecord = () => {

    const [currentTab, setCurrentTab] = useState("pending")


    return (
        <div className='flex flex-col w-full justify-start item-center'>
            <Tabs
                defaultValue={currentTab}
                className="w-full flex flex-col mt-7 sm:mt-14 mb-0 sm:mb-12"
            >
                <TabsList className=" m-auto mb-5 ">
                    <TabsTrigger
                        className=" text-lg"
                        value="pending"
                        onClick={() => setCurrentTab("pending")}
                    >
                        Pending
                    </TabsTrigger>

                    <TabsTrigger
                        className=" text-lg"
                        value="approve"
                        onClick={() => setCurrentTab("approv")}
                    >
                        Approve
                    </TabsTrigger>

                    <TabsTrigger
                        className=" text-lg"
                        value="delete"
                        onClick={() => setCurrentTab("delete")}
                    >
                        Delete
                    </TabsTrigger>
                </TabsList>

                {/* ............ Pending ............ */}
                <TabsContent className="m-0 p-0  w-full flex flex-col items-center" value="pending">
                    <h1 className='font-bold text-xl mt-5'>Pending excel record (1)</h1>

                    <Table className="mt-4 border-2" >
                        <TableHeader>
                            <TableRow className=" bg-zinc-100">
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    No.
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Sheet name / Create name
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Total Amount
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    No. of request
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Transfer
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Benificery
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Status
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Approve excel
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Delete excel
                                </TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {pendingExcelInfoList.map((excelInfo: any, index: number) => (
                                <TableRow className="" key={index}>
                                    <TableCell className="text-center border-r">{++index}</TableCell>
                                    <TableCell className="text-center gap-1 border-r">
                                        <Link className="text-blue-500 block font-semibold" href={'/dashboard/excel-record/excel-withrawl-requests'}>{excelInfo.sheeNameOrDate}</Link>
                                        <span className="font-semibold text-xs">24 Jan 2004, 4:00pm</span>
                                    </TableCell>
                                    <TableCell className="text-center border-r">{excelInfo.totalAmount}</TableCell>
                                    <TableCell className="text-center border-r">
                                        {excelInfo.noOfReqests}
                                    </TableCell>
                                    <TableCell className=" gap-1 border-r">
                                        <span className="font-semibold block mb-2 ">{excelInfo.transfer}</span>
                                        <Button className="bg-blue-600 w-full hover:bg-blue-800 py-1 px-2">< FaDownload /></Button>
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        <span className="font-semibold block mb-2">{excelInfo.benificery}</span>
                                        <Button className="bg-blue-600 w-full hover:bg-blue-800 py-1 px-2">< FaDownload /></Button>
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        <Tag color="gold">{excelInfo.status}</Tag>
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        {excelInfo.approveExcel}
                                        <Input placeholder="Enter remark" className="w-28 mb-1" />
                                        <Button className="bg-green-600 w-full hover:bg-green-800 py-1 px-2">Approve excel  </Button>
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        <Button className="bg-red-600 w-full hover:bg-green-800 py-1 px-2">Delete excel  </Button>
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </TabsContent>

                {/* ............ approve ............ */}
                <TabsContent className="m-0 p-0  w-full flex flex-col items-center" value="approve">
                    <h1 className='font-bold text-xl mt-5'>Approve excel record (1)</h1>

                    <Table className="mt-4 border">
                        <TableHeader>
                            <TableRow className=" bg-zinc-100">
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    No.
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Sheet name
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Total Amount
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    No. of request
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Transfer
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Benificery
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Status
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Remarks
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Create date
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Approve date
                                </TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {approveExcelInfoList.map((excelInfo: any, index: number) => (
                                <TableRow className="" key={index}>
                                    <TableCell className="text-center border-r">{++index}</TableCell>
                                    <TableCell className="text-center gap-1 border-r">
                                        <Link className="text-blue-500 block font-semibold" href={`/dashboard/excel-record/${excelInfo.url}`}>{excelInfo.sheetname}</Link>
                                    </TableCell>
                                    <TableCell className="text-center border-r">{excelInfo.totalAmount}</TableCell>
                                    <TableCell className="text-center border-r">
                                        {excelInfo.noOfReqests}
                                    </TableCell>
                                    <TableCell className="text-center pl-12">
                                        <span className="font-semibold block mb-2">{excelInfo.benificery}</span>
                                        <Button className="bg-blue-600 w-full hover:bg-blue-800 py-1 px-2">< FaDownload /></Button>
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        <span className="font-semibold block mb-2">{excelInfo.benificery}</span>
                                        <Button className="bg-blue-600 w-full hover:bg-blue-800 py-1 px-2">< FaDownload /></Button>
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        <Tag color="green">{excelInfo.status}</Tag>
                                    </TableCell>
                                    <TableCell className="text-center border-r">{excelInfo.remarks}</TableCell>
                                    <TableCell className="text-center border-r">{excelInfo.createdAt}</TableCell>
                                    <TableCell className="text-left">{excelInfo.deletedAt}</TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </TabsContent>

                {/* ............ delete ............ */}
                <TabsContent className="m-0 p-0 my-6 w-full flex flex-col items-center" value="delete">

                    <h1 className='font-bold text-xl '>Delete excel record (1)</h1>
                    <Table className="mt-4 overflow-auto border">
                        <TableHeader>
                            <TableRow className=" bg-zinc-100">
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    No.
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base border-r text-center">
                                    Sheet name
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Total Amount
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    No. of request
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Transfer
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Benificery
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Status
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Create date
                                </TableHead>
                                <TableHead className="font-bold text-sm sm:text-base text-center border-r">
                                    Delete date
                                </TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {deleteExcelInfoList.map((excelInfo: any, index: number) => (
                                <TableRow className="" key={index}>
                                    <TableCell className="text-center border-r">{++index}</TableCell>
                                    <TableCell className="text-center gap-1 border-r">
                                        <Link className="text-blue-500 block font-semibold" href={'/dashboard/excel-record/delete-excel-record'}>{excelInfo.sheetname}</Link>
                                    </TableCell>
                                    <TableCell className="text-center border-r">{excelInfo.totalAmount}</TableCell>
                                    <TableCell className="text-center border-r">
                                        {excelInfo.noOfReqests}
                                    </TableCell>
                                    <TableCell className="text-left pl-12">
                                        {excelInfo.transfer}
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        <span className="font-semibold block mb-2">{excelInfo.benificery}</span>
                                    </TableCell>
                                    <TableCell className="text-center border-r">
                                        <Tag color="red">{excelInfo.status}</Tag>
                                    </TableCell>
                                    <TableCell className="text-center border-r">{excelInfo.createdAt}</TableCell>
                                    <TableCell className="text-center border-r">{excelInfo.deletedAt}</TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </TabsContent>
            </Tabs>
        </div>
    )
}

export default ExcelRecord

const deleteExcelInfoList: any = [
    {
        sheetname: "example file 1",
        totalAmount: 2,
        noOfReqests: 5,
        transfer: "file name",
        benificery: "example file 1",
        status: "Delete",
        createdAt: "24 Jan 2004, 4:00pm",
        deletedAt: "24 Jan 2004, 4:00pm"
    }
]

const approveExcelInfoList: any = [
    {
        sheetname: "example file 1",
        totalAmount: 2,
        noOfReqests: 5,
        transfer: 5,
        benificery: "example file 1",
        status: "Approve",
        remarks: "bank remakrs",
        createdAt: "24 Jan 2004, 4:00pm",
        approveAt: "24 Jan 2004, 4:00pm",
        url: "approve-excel-record"
    }
]

const pendingExcelInfoList: any = [
    {
        sheeNameOrDate: "example file 1",
        totalAmount: "50,000",
        noOfReqests: 50,
        transfer: "tranfer file 1.xlsx",
        benificery: "benif file 1.xlsx",
        status: "Pending",
        approveExcel: "",
        deleteExcel: ""
    },

]
