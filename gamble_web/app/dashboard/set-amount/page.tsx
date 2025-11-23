import { Button } from "@/components/ui/button";
import React from 'react'
import { Input } from "antd";
import {
    Select,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectLabel,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select"
import { Label } from "@/components/ui/label";

const setAmount = () => {
    return (
        <div className='flex flex-col items-center justify-start'>
            <h1 className=' font-semibold mt-3 text-2xl'>Set Amount</h1>

            {/* .....INput fields. ....  */}
            <div className="grid w-[70%] my-12 max-w-sm items-center gap-3.5">
                <Label htmlFor="picture">Numbers: 1 x </Label>
                <Input id="picture" type="text" placeholder="₹ 95.00" />

                <Label htmlFor="picture">Harup: 1 x </Label>
                <Input id="picture" type="text"  placeholder="₹ 9.50" />

                <Label htmlFor="picture">Referral percent</Label>
                <Input id="picture" type="text" placeholder="4.00%" />

                <Button className="flex justify-self-start bg-blue-600 px-8">Fixed</Button>
            </div>

            
        </div>
    )
}

export default setAmount
