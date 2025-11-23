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


const RejectMoneyrecpiet = (probs: any) => {
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className='w-full m-0 p-0'>
                    <span className="text-blue-500 text-md hover:text-blue-700 cursor-pointer">View Detail</span>

                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent className='p-0 pb-12 sm:w-[470px] max-h-[75%] overflow-auto'>
                    <div className="flex flex-col w-full ">

                        <div className="flex px-4 py-2 justify-start items-center bg-red-100">
                            <span className="font-medium pr-6 text-red-500">
                                Reject Recpiet
                            </span>
                            {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                            <div className="grow"></div>
                            <AlertDialogCancel className="bg-red-500 text-white">
                                <IoMdClose className="font-bold" />
                            </AlertDialogCancel>
                        </div>

                        <div className="flex w-full my-3  mt-7 items-center justify-center  gap-3.5">
                            <Label className='text-xl' htmlFor="picture">Rejected Request</Label>
                        </div>

                        <div className='flex  justify-between mx-8 mt-5 items-center'>
                            <div className='flex flex-col'>
                                <span className='font-semibold'>Time:</span>
                                <span>09 sept 2024, 12:00pm</span>
                            </div>
                        </div>
                        <div className="w-full h-[0.4px] my-3 bg-zinc-300"></div>

                        <div className='flex  justify-between mx-8 mt-3 items-center'>
                            <div className='flex flex-col'>
                                <span className='font-semibold'>Reason:</span>
                                <div className='flex w-full justify-center text-sm text-left'>
                                   Here is reason to reject money 
                                </div>
                            </div>
                        </div>


                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default RejectMoneyrecpiet
