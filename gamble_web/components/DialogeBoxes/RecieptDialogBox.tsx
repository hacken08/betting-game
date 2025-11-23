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
import { StatementScheme } from '@/models/StatementModel';
import { dateTimeFormatter } from '@/lib/utilsMethod';


const RecieptDialoge = (probs: {statement: StatementScheme}) => {
    const { statement } = probs;
    
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className='w-full m-0 p-0'>
                    <span className="text-blue-500 text-md hover:text-blue-700 cursor-pointer">View Detail</span>

                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent className='p-0 pb-12 sm:w-[470px]'>
                    <div className="flex flex-col w-full ">

                       { statement.game_result?.result === "WIN" 
                        ? <div className="flex px-4 py-2 justify-start items-center bg-[#e3ffde]">
                            <span className={`font-medium pr-6 text-[#7cb673]`}>
                                Reciept
                            </span>
                            {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                            <div className="grow"></div>
                            <AlertDialogCancel className="bg-[#9ad897] text-white">
                                <IoMdClose className="font-bold" />
                            </AlertDialogCancel>
                        </div>
                        : <div className="flex px-4 py-2 justify-start items-center bg-red-100">
                            <span className={`font-medium pr-6 text-red-500`}>
                                Reciept
                            </span>
                            {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                            <div className="grow"></div>
                            <AlertDialogCancel className="bg-[#d87397] text-white">
                                <IoMdClose className="font-bold" />
                            </AlertDialogCancel>
                        </div>
                       }

                        <div className="flex w-full my-3  mt-7 items-center justify-center  gap-3.5">
                            <Label className='text-xl' htmlFor="picture">Silver guru {statement.game_result?.result}</Label>
                        </div>

                        <div className='flex  justify-between mx-8 items-center'>
                            <div className='flex flex-col'>
                                <span className='font-semibold'>Game name:</span>
                                <span>Silver guru</span>
                            </div>
                            <div className='flex flex-col items-end'>
                                <span className='font-semibold '>Amount:</span>
                                <span>{statement.game_result?.amount}</span>
                            </div>
                        </div>
                        <div className="w-full h-[0.4px] my-3 bg-zinc-300"></div>

                        <div className='flex  justify-between mx-8 items-center'>
                            <div className='flex flex-col'>
                                <span className='font-semibold'>Status:</span>
                                <span>{statement.game_result?.result == "WIN" ? "CREDIT" : "DEBIT"}</span>
                            </div>
                            <div className='flex flex-col items-end'>
                                <span className='font-semibold'>Txn ID:</span>
                                <span>3248732342</span>
                            </div>
                        </div>
                        <div className="w-full h-[0.4px] my-3 bg-zinc-300"></div>

                        <div className='flex  justify-between mx-8 items-center'>
                            <div className='flex flex-col'>
                                <span className='font-semibold'>Playe Date:</span>
                                <span>09 sept 2024</span>
                            </div>
                            <div className='flex flex-col items-end'>
                                <span className='font-semibold'>Win time:</span>
                                <span className='text-sm'>{dateTimeFormatter(new Date(statement.game_result?.created_at ?? ""))}</span>
                            </div>
                        </div>

                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default RecieptDialoge
