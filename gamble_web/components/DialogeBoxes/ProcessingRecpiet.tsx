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
import { Input as input } from '@/components/ui/input';
import { Separator } from '@radix-ui/react-select';


const ProcessingRecpiet = (probs: any) => {
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className='w-full m-0 p-0'>
                    <span className="text-blue-500 text-md hover:text-blue-700 cursor-pointer">View Detail</span>

                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent className='p-0 pb-12 sm:w-[470px] max-h-[75%] overflow-auto'>
                    <div className="flex flex-col w-full ">

                        <div className="flex px-4 py-2 justify-start items-center bg-yellow-100">
                            <span className="font-medium pr-6 text-yellow-500">
                                Status Racpiet
                            </span>
                            {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                            <div className="grow"></div>
                            <AlertDialogCancel className="bg-yellow-500 text-white">
                                <IoMdClose className="font-bold" />
                            </AlertDialogCancel>
                        </div>

                        <div className="flex w-full my-3  mt-7 items-center justify-center  gap-3.5">
                            {
                                probs.Withdrawl
                                ? <Label className='text-xl' htmlFor="picture">Processing Withdrawl Request</Label>
                                : <Label className='text-xl' htmlFor="picture">Processing Request</Label>
                            }
                        </div>

                        <div className='flex w-full justify-center my-3 text-lg text-center'>
                            Please wait while we process your request. <br />
                            It take few time.
                        </div>


                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default ProcessingRecpiet
