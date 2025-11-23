import React from 'react'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select'
import { Button } from '../ui/button'
import { Input } from '../ui/input'

const FilterField = () => {
    return (
        <div className="flex h-10 w-full mb-1 max-w-sm items-center">
            <Select>
                <SelectTrigger className="w-[180px] rounded-none rounded-l-md focus:out">
                    <SelectValue placeholder="Time" />
                </SelectTrigger>
                <SelectContent>
                    {/* <SelectLabel>Date</SelectLabel> */}
                    <SelectItem value="apple">Today</SelectItem>
                    <SelectItem value="banana">Yesterday</SelectItem>
                    <SelectItem value="blueberry">Last 7 days</SelectItem>
                    <SelectItem value="blueberry">Last 30 days</SelectItem>
                    <SelectItem value="blueberry">This month</SelectItem>
                    <SelectItem value="blueberry">Last month</SelectItem>
                    <SelectItem value="blueberry">Custom range</SelectItem>
                </SelectContent>
            </Select>
            <Input className="h-full  rounded-none placeholder:font-semibold" type="date" />
            <Button className="h-full bg-blue-500  rounded-none rounded-r-md w-56" type="submit">Filter</Button>
        </div>
    )
}

export default FilterField
