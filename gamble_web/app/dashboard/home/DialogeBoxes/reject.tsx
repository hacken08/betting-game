import React from 'react'
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
import { Input } from "antd";
// import { Input } from '@/components/ui/input';


const RejectDailouge = () => {
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className='w-full'>
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
                            <AlertDialogCancel className="bg-[#fc7371] text-white">
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
                                        {/* <SelectLabel>Select a reason</SelectLabel> */}
                                        <SelectItem value="Today">Today</SelectItem>
                                        <SelectItem value="Yesterday">Yesterday</SelectItem>
                                        <SelectItem value="Last 7 days">Last 7 days</SelectItem>
                                        <SelectItem value="Last 30 days">Last 30 days</SelectItem>
                                        <SelectItem value="This month">This month</SelectItem>
                                        <SelectItem value="Last month">Last month</SelectItem>
                                        <SelectItem value="Custom range">Custom range</SelectItem>
                                    </SelectContent>
                                </Select>
                            </div>


                        </div>

                        <div className="flex justify-center my-5">
                            <Button className="bg-[#fc7371] w-[68%] hover:bg-[#fc7371] rounded-full">Sumbit</Button>
                        </div>


                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default RejectDailouge
