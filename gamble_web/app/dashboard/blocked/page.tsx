"use client"

import React from 'react'
import {
    Table,
    TableBody,
    TableCell,
    TableFooter,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Button } from '@/components/ui/button';
import { Input, Tag } from 'antd';
import { AlertDialog, AlertDialogContent, AlertDialogTrigger } from '@/components/ui/alert-dialog';
import { useRouter } from 'next/navigation';


const SubAdminPage = () => {

    const route = useRouter()


    return (
        <>
            <div className="flex flex-col items-center w-full h-full bg-white px-3 rounded-md">
                <h1 className="m-auto font-bold text-2xl my-3">Blocked Sub-admins</h1>

                <div className="sm:flex flex sm:flex-row flex-col-reverse justify-between w-full items-center sm:text-base text-sm">

                    <div className="flex gap-3 sm:my-10 my-5 w-full justify-start items-center">
                        <div className="border px-4 py-1  bg-slate-100 shadow-md flex flex-col justify-center items-center">
                            <span className="font-semibold">23,000</span>
                            <span className="sm:text-base text-xs ">Total Withdrawal Balance</span>
                        </div>
                    </div>

                    <div className="flex h-10 sm:w-[400px] mb-1 max-w-sm items-center">
                        <Input className="h-full  rounded-none rounded-l-md placeholder:font-semibold" type="text" placeholder="User I'd" />
                        <Button className="h-full bg-blue-500  rounded-none rounded-r-md w-40" type="submit">Search</Button>
                    </div>
                </div>

                <div className="w-full flex-1 rounded-lg ">
                    <Table className='border-2' >
                        <TableHeader className='bg-zinc-100'>
                            <TableHead className='border-0 border-r text-center'>No</TableHead>
                            <TableHead className='border-0 border-r text-center'>Name</TableHead>
                            <TableHead className='border-0 border-r text-center'>Email</TableHead>
                            <TableHead className='border-0 border-r text-center'>Level</TableHead>
                            <TableHead className='border-0 border-r text-center'>Status</TableHead>
                            <TableHead className='border-0 border-r text-center'>Direct add money</TableHead>
                            <TableHead className='border-0 border-r text-center'>Withdrawal limit (₹)</TableHead>
                            <TableHead className='border-0 border-r text-center'>Add money limit (₹)</TableHead>
                            <TableHead className='border-0 border-r text-center'>Blocked date</TableHead>
                            <TableHead className='border-0 border-r text-center'>Create date</TableHead>
                        </TableHeader>
                        <TableBody className="">
                            {Array.from([12, 3, 4, 5]).map((val, index) => (
                                <TableRow className="" key={index}>
                                    <TableCell className="min-w-20 text-center border-r">{++index}</TableCell>
                                    <TableCell className="min-w-[120px] border-r border-y-0 items-center  gap-2">
                                        <div>Name of worker</div>
                                    </TableCell>
                                    {/* <TableCell className="border-0 border-r items-center font-medium">{}</TableCell> */}
                                    <TableCell className="min-w-[120px] items-left text-center border-0 border-r">
                                        <div className=''>example@gmail.com</div>
                                        <div>+91 ********</div>
                                        <div className='font-semibold text-sm'>User Id: 1</div>
                                    </TableCell>

                                    <TableCell className="min-w-[120px] border-0 border-r texts-center">
                                        <Tag className='w-20 flex justify-center' color="gold">Admin</Tag>
                                    </TableCell>

                                    <TableCell className='min-w-[120px] border-0 border-r text-center'>
                                        <Tag className='w-20 flex justify-center' color="red">Blocked</Tag>
                                    </TableCell>

                                    <TableCell className='border-0 border-r min-w-[120px] text-center'>
                                        <div className='text-green-600 font-semibold'>₹ 7,000</div>
                                    </TableCell>

                                    <TableCell className='border-0 border-r min-w-[120px] text-center'>
                                        <div className='text-green-600 font-semibold'>₹ 7,000</div>
                                    </TableCell>

                                    <TableCell className='border-0 border-r min-w-[120px] text-center'>
                                        <div className='text-green-600 font-semibold'>₹ 7,000</div>
                                    </TableCell>

                                    <TableCell className='border-0 border-r min-w-[120px] text-center'>
                                        <div>8/28/2024</div>
                                        <div>10:44pm</div>
                                    </TableCell>

                                    <TableCell className='border-0 border-r min-w-[120px] text-center'>
                                        <div>8/28/2024</div>
                                        <div>10:44pm</div>
                                    </TableCell>



                                </TableRow>
                            ))}
                        </TableBody>

                    </Table>

                    <Button className="w-full mt-4">View All</Button>
                </div>
            </div>
        </>
    )
}

export default SubAdminPage
