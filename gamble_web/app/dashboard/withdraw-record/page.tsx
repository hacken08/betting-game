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
      <h1 className="m-auto font-bold text-xl my-3">Withrawal Record</h1>

      <div className="flex flex-col mt-3 w-full">
        <div className="flex lg:w-[500px] w-full flex-col gap-4">
          <Label>Select date</Label>
          <Input type="date" />
          <Button className="bg-blue-600 hover:bg-blue-700">Submit</Button>
        </div>

        <div className=" md:gap-8 gap-1 flex flex-col md:flex-row mt-4 justify-start items-start mb-5 border-none">
          <div className="flex flex-col items-start text-sm outline outline-[0.5px] p-3 rounded-md shadow-md">
            <span className="  m-auto font-semibold ">Total</span>
            <div className="mx-2">234,123,5</div>
          </div>
        </div>
      </div>

      <Table className="border">
        <TableHeader>
          <TableRow className=" bg-zinc-100">
            <TableHead className="font-bold text-base text-center border-r">
              No.
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r">
              Date
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r">
              Level
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r">
              Id info
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r">
              Total Amount
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {Array.from([1, 3, 4, 5, 6]).map((invoice, index: number) => (
            <TableRow className="" key={index}>
              <TableCell className="border-r text-center">{++index}</TableCell>
              <TableCell className="border-r text-center">8/27/2024</TableCell>
              <TableCell className="border-r text-center">
                <Tag color="blue">Sub Admin</Tag>
              </TableCell>
              <TableCell className="border-r text-center pl-12">
                <span className=" block">example@gmail.com</span>
                <span className=" block">+91 ************</span>
                <span className=" block text-red-700 font-semibold">
                  User Id: 1274
                </span>
              </TableCell>
              <TableCell className="border-r text-center">₹ 2,000</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
};

export default page;
