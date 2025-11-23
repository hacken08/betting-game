"use client"

import { Button } from "@/components/ui/button";
import {
    Table,
    TableBody,
    TableCell,
    TableFooter,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Tag } from "antd"; import React from 'react'
import { Switch } from "@/components/ui/switch";

const StatusPage = () => {
    return (
        <div className="flex flex-col items-center w-full h-full bg-white rounded-md">
            <h1 className="m-auto font-bold text-xl my-3">My Status</h1>
            <div className="w-full flex-1 rounded-lg p-3">
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead className="text-center">NO</TableHead>
                            <TableHead className="text-center">Add limit heading</TableHead>
                            <TableHead className="text-center">Withdrawl limit</TableHead>
                            <TableHead className="text-center">Total bonus</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody className="">
                        {games.map((game) => (
                            <TableRow className="" key={game.no}>
                                <TableCell className=" text-center min-w-15">{game.no}</TableCell>
                                <TableCell className=" text-center font-medium">{game.gameName}</TableCell>
                                <TableCell className=" text-center  min-w-28">{game.openTime}</TableCell>
                                <TableCell className=" text-center min-w-28">{game.closeTime}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>

                </Table>
            </div>


            {/* ------------ Urgent gateway --------- */}
            <h1 className="m-auto font-bold text-xl my-3">Add / Withdrawl Urgent Gateways</h1>
            <div className="justify-center flex flex-1 gap-6 rounded-lg p-3">

                <div className="min-h-4 min-w-4 shadow-md bg-zinc-100 gap-2 py-1 px-3 items-center flex rounded-md">
                    <h1 className="m-auto font-bold text-base my-3">Urgent add money</h1>
                    <Switch />
                </div>

                <div className="min-h-4 min-w-4 shadow-md bg-zinc-100 gap-2 py-1 px-3 items-center flex rounded-md">
                    <h1 className="m-auto font-bold text-base my-3">Urgent withdrawl money</h1>
                    <Switch />
                </div>
            </div>

            <h1 className="m-auto font-bold text-xl my-3 mt-10">Approved Gateways</h1>

        </div>
    )
}

export default StatusPage


const columns = [
    { name: "NO", uid: "no" },
    { name: "Gamer Name", uid: "gameName" },
    { name: "Open Time", uid: "openTime" },
    { name: "Close Time", uid: "closeTime" },
    { name: "Status", uid: "status" },
];

const games = [
    {
        no: 1,
        gameName: "23,000",
        openTime: "20",
        closeTime: "10",
    },
];
