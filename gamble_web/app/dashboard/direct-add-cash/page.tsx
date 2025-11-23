"use client"
import { Divider } from "@nextui-org/react";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

export default function DirectAdd() {
  return (
    <div className="bg-white rounded-md p-3 flex items-center flex-col gap-3">
      <h2 className="mx-auto text-lg font-medium text-center">
        Direct Add Cash
      </h2>
      <Divider />

      <div className="flex gap-3 flex-col w-full sm:w-[400px]">
        <div className="flex-1">
          <p className="text-sm font-normal">User Id: </p>
          <Input type="text" placeholder="Enter User Id" />
        </div>
        <div className="flex-1">
          <p className="text-sm font-normal">Transaction Id: </p>
          <Input type="text" placeholder="Enter Transaction Id" />
        </div>

        <div className="flex-1">
          <p className="text-sm font-normal">Gateway: </p>
          <div className="flex">
            <Select>
              <SelectTrigger className="w-full rounded-none rounded-l-md focus:out">
                <SelectValue placeholder="Select gateway" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="apple">Google pay</SelectItem>
                <SelectItem value="apple">Phone pe</SelectItem>
                {/* <SelectItem value="apple">Paytm</SelectItem> */}
                {/* <SelectItem value="apple">UPI</SelectItem>
                <SelectItem value="apple">Bank Account</SelectItem>
                <SelectItem value="apple">Google pay Qr</SelectItem>
                <SelectItem value="apple">Paytm Qr</SelectItem>
                <SelectItem value="apple">Phone Pe QR</SelectItem> */}
              </SelectContent>
            </Select>
            {/* <Input type="text" placeholder="Enter gateway" /> */}
          </div>

        </div>
        <div className="flex-1">
          <p className="text-sm font-normal">Amount: </p>
          <Input type="text" placeholder="Enter amount" />
        </div>



        <div className="flex">
          <div className="grow"></div>
          <button className="px-4 py-1 bg-blue-600 hover:bg-blue-700 rounded text-sm text-white">
            Send Payment
          </button>
        </div>
      </div>

    </div>
  );
}
