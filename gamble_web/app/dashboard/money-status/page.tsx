import React from "react";
import { Input, Tag } from "antd";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

const page = () => {
  return (
    <div className="flex flex-col items-start w-full h-full bg-white rounded-md">
      <h1 className="m-auto font-bold text-xl my-3">Money Status</h1>

      <div className="flex flex-col my-3 w-full">
        <div className="flex lg:w-[500px] w-full flex-col gap-4">
          <Label>Select date</Label>
          <Input type="date" />
          <Button className="bg-blue-600 hover:bg-blue-700">Submit</Button>
        </div>
      </div>

      <Table className="border">
        <TableHeader>
          <TableRow className=" bg-zinc-100">
            <TableHead className="font-bold text-base text-center border-r">
              Add money approved
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r">
              {"Withdrawal money \n approved"}
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r">
              Direct Cash
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r">
              Wallet Amount
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {Array.from([1]).map((invoice, index: number) => (
            <TableRow className="" key={index}>
              <TableCell className="border-r text-center">
                <div>Amount: 23</div>
                <div>Request: 1</div>
              </TableCell>
              <TableCell className="border-r text-center">
                <div>Amount: 23</div>
                <div>Request: 1</div>
              </TableCell>
              <TableCell className="border-r text-center">
                <div>Amount: 23</div>
                <div>Request: 1</div>
              </TableCell>
              <TableCell className="border-r text-center">
                <div>Amount: ₹ 2,000</div>
                <div>users: 10</div>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
};

export default page;
