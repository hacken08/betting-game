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


const ApproveDailouge = () => {
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className='w-full'>
                    <Button className="bg-green-500 w-full rounded-none rounded-l-lg m-0 hover:bg-green-700 text-white " variant={"default"}>
                        Approve
                    </Button>
                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent className='p-0 sm:w-[470px] w-full'>
                    <div className="flex flex-col w-full ">

                        <div className="flex px-4 py-2 justify-start items-center bg-[#e3ffde]">
                            <span className="font-medium pr-6 text-[#7cb673]">
                                Enter Transaction ID
                            </span>
                            {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                            <div className="grow"></div>
                            <AlertDialogCancel className="bg-[#9ad897] text-white">
                                <IoMdClose className="font-bold" />
                            </AlertDialogCancel>
                        </div>

                        <div className="flex w-full my-3  mt-7 items-center justify-center  gap-3.5">
                            <Label className='text-xl' htmlFor="picture">Sending Amount</Label>
                        </div>

                        {/* ----------- search result ----------- */}
                        <div className="flex flex-col w-full px-4  my-3 mt-3 items-center justify-start gap-3">

                            <div className="flex w-[70%]">
                                <Input placeholder={"500.00"} className="rounded-r-none rounded-l-2xl" id="picture" type="text" />
                                <Button className="rounded-l-none rounded-r-2xl  flex justify-self-start bg-[#7cb673] px-8">Edit</Button>
                            </div>

                            <Label className='text-md font-bold mb-2 text-red-600' htmlFor="picture">FIVE HUNDRED</Label>

                            <div className="flex w-[70%]">
                                <Input placeholder="Enter transaction ID" className="rounded-full h-11" id="picture" type="text" />
                            </div>

                            <div className="flex w-[70%]">
                                <Select>
                                    <SelectTrigger className="w-full rounded-full h-11 focus:out">
                                        <SelectValue defaultValue={"Today"} placeholder="Time" />
                                    </SelectTrigger>
                                    <SelectContent>
                                        {/* <SelectLabel>Date</SelectLabel> */}
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
                            <Button className="bg-[#7cb673] w-[68%] hover:bg-[#7cb673] rounded-full">Sumbit</Button>
                        </div>


                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default ApproveDailouge
