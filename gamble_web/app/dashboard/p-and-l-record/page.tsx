"use client";

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
import React from "react";
import { Input } from "antd";
import { Button } from "@/components/ui/button";

const ProfitAndLoss = () => {
  return (
    <div className="flex flex-col items-center justify-start w-full mt-3 bg-white rounded-md">
      <h1 className="m-auto font-bold text-xl my-8">Profit & Loss</h1>

      <div className="flex flex-col lg:w-[400px] w-full items-start justify-center h-full">
        {/* <div className="flex h-10 w-full mb-1 max-w-sm items-center">
                <Input className="h-full  rounded-none rounded-l-md placeholder:font-semibold" type="text" placeholder="Enter UTR" />
                </div> */}

        <div className="flex h-10 w-full mb-1 max-w-sm items-center">
          <Input
            className="h-full  rounded-none placeholder:font-semibold"
            type="date"
          />
        </div>

        {/* <div className="flex h-10 w-full mb-1 max-w-sm items-center">
          <Input className="h-full  rounded-none rounded-l-md placeholder:font-semibold" type="text" placeholder="User I'd" />
        </div> */}

        <Button className="bg-blue-700 mt-4 w-full flex justify-self-start">
          Submit
        </Button>
      </div>

      <div className="flex gap-3 my-10 w-full justify-start items-center">
        <div className="border px-4 py-2  bg-slate-100 shadow-md flex flex-col justify-center items-center">
          <span className="font-semibold">Total bid Amount</span>
          <span className="">23,000</span>
        </div>

        <div className="border px-4 py-2 bg-slate-100 shadow-md flex flex-col justify-center items-center">
          <span className="font-semibold">Total win amount</span>
          <span className="">23,000</span>
        </div>

        <div className="border px-5 py-2 bg-slate-100 shadow-md flex flex-col justify-center items-center">
          <span className="font-semibold">P&L</span>
          <span className="">23,000</span>
        </div>
      </div>

      <Table className="">
        <TableHeader>
          <TableRow className=" bg-zinc-100">
            <TableHead className="font-bold text-base text-center">
              No.
            </TableHead>
            <TableHead className="font-bold text-base text-center">
              Games
            </TableHead>
            <TableHead className="font-bold text-base text-center">
              Bidding amount
            </TableHead>
            <TableHead className="font-bold text-base text-left">
              Winning amonut
            </TableHead>
            <TableHead className="font-bold text-base text-left">P&L</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {invoices.map((invoice, index: number) => (
            <TableRow className="" key={index}>
              <TableCell className="text-center">{invoice.no}</TableCell>
              <TableCell className="text-center">{invoice.gameName}</TableCell>
              <TableCell className="text-center">
                {invoice.biddingAmount}
              </TableCell>
              <TableCell className="text-left pl-12">
                {invoice.winningAmount}
              </TableCell>
              <TableCell className="text-left">{invoice.pAndL}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
};
export default ProfitAndLoss;

const invoices = [
  {
    no: 1,
    gameName: "Desawar",
    biddingAmount: "₹ 2341",
    winningAmount: "₹ 234",
    pAndL: "453",
  },
  {
    no: 2,
    gameName: "Silver guru",
    biddingAmount: "₹ 2341",
    winningAmount: "₹ 234",
    pAndL: "453",
  },
  {
    no: 3,
    gameName: "Faridabad",
    biddingAmount: "₹ 2341",
    winningAmount: "₹ 234",
    pAndL: "453",
  },
  {
    no: 4,
    gameName: "Gaziabad",
    biddingAmount: "₹ 2341",
    winningAmount: "₹ 234",
    pAndL: "453",
  },
  {
    no: 5,
    gameName: "Gali",
    biddingAmount: "₹ 2341",
    winningAmount: "₹ 234",
    pAndL: "453",
  },
];
