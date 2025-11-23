"use client"

import React from 'react'

import { Button } from '@/components/ui/button'

import { Label } from '@/components/ui/label'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'


const NotificationPage = () => {
    return (
        <div className='flex flex-col justify-center items-center'>
            <h1 className="m-auto font-bold text-2xl mb-12 mt-2">Notification Center</h1>

            <div className="grid w-[70%] my-12 max-w-sm items-center gap-3.5">
                <Label htmlFor="picture">Title </Label>
                <Input id="picture" type="text" placeholder="Enter title" />

                <Label htmlFor="description">Message</Label>
                <Textarea placeholder="Enter message" />

                <Label htmlFor="picture">Link</Label>
                <Input id="picture" type="text" placeholder="Enter link" />

                <Button className="flex justify-self-center bg-blue-600 px-8">Sumbit</Button>
            </div>
        </div>
    )
}

export default NotificationPage

