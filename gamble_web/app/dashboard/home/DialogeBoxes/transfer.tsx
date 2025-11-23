import { AlertDialog, AlertDialogCancel, AlertDialogContent, AlertDialogTrigger } from '@/components/ui/alert-dialog'
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox"
import { Button } from '@/components/ui/button'
import { FaSearch } from "react-icons/fa";
import React from 'react'
import { IoMdClose } from "react-icons/io";
import { Input  } from "antd";


const TransferDailouge = () => {
    return (
        <>
            <AlertDialog>
                <AlertDialogTrigger className=''>
                    <Button className="bg-transparent text-red-500 w-full hover:bg-transparent hover:text-red-700 ">
                        {"-> Transfer"}
                    </Button>
                </AlertDialogTrigger>

                {/*  --- Transfer ---  */}
                <AlertDialogContent>
                    <div>
                        <div className="flex flex-col m-0 p-0">
                            <div className="flex justify-start items-center">
                                <span className="font-medium pr-6 text-[#4ca091]">
                                    Transfer Request
                                </span>
                                {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                                <div className="grow"></div>
                                <AlertDialogCancel className="hover:bg-[#4ca091] hover:text-white">
                                    <IoMdClose className="" />
                                </AlertDialogCancel>
                            </div>

                            <div className="grid w-full my-3 mt-10 max-w-sm items-center gap-3.5">
                                <Label htmlFor="picture">Search</Label>
                                <div className="flex w-full">
                                    <Input className="rounded-r-none rounded-l-2xl" id="picture" type="text" placeholder="Search here" />
                                    <Button className="rounded-l-none rounded-r-2xl  flex justify-self-start bg-[#4ca091] px-8">< FaSearch /></Button>
                                </div>
                            </div>

                            {/* ----------- search result ----------- */}
                            <div className="flex flex-col w-full my-3 mt-7 max-w-sm items-start justify-start gap-3">

                                <div className="flex justify-start items-center gap-3">
                                    <Checkbox />
                                    <span className="font-semibold mb-1">name of user</span>
                                </div>
                                <div className="flex justify-start items-center gap-3">
                                    <Checkbox />
                                    <span className="font-semibold mb-1">name of user</span>
                                </div>
                                <div className="flex justify-start items-center gap-3">
                                    <Checkbox />
                                    <span className="font-semibold mb-1">name of user</span>
                                </div>
                                <div className="flex justify-start items-center gap-3">
                                    <Checkbox />
                                    <span className="font-semibold mb-1">name of user</span>
                                </div>
                                <div className="flex justify-start items-center gap-3">
                                    <Checkbox />
                                    <span className="font-semibold mb-1">name of user</span>
                                </div>
                                <div className="flex justify-start items-center gap-3">
                                    <Checkbox />
                                    <span className="font-semibold mb-1">name of user</span>
                                </div>
                            </div>

                            <div className="flex justify-center mt-5">
                                <Button className="bg-[#4ca091] w-[40%] hover:bg-[#4ca091">Transfer</Button>
                            </div>


                        </div>
                    </div>
                </AlertDialogContent>
            </AlertDialog>
        </>
    )
}

export default TransferDailouge
