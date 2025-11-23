"use client"


import { AlertDialogCancel } from '@/components/ui/alert-dialog'
import { Input } from '@/components/ui/input';
import {
    Select,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select"
import { Label } from "@/components/ui/label";
import React, { useEffect, useState } from 'react'
import { useForm } from 'react-hook-form';
import { IoMdClose } from 'react-icons/io'
import { valibotResolver } from '@hookform/resolvers/valibot';
import { Form, FormField, FormItem } from '@/components/ui/form';
import { Button } from '@/components/ui/button';
import { CreateWorkerAccountForm, CreateWorkerAccountSchema } from '@/schema/createWorkerAcountSchema';
import { toast } from 'react-toastify';
import { handleAccountParamData, HttpMethodType, makeApiRequeest } from '@/lib/api/untils';
import { BASE_URL } from '@/lib/const';
import { User } from '@/models/UserModel';
import { PaymentGateway } from '@/models/paymentGatewayModel';
import { AxiosResponse } from 'axios';
import { getCookie } from 'cookies-next';

const CreateAccount = () => {
    const [accountType, setAccountType] = useState("")
    const [workers, setWorkers] = useState<[User] | []>([])
    const [paymentGateways, setPaymentGateways] = useState<[PaymentGateway] | []>([])
    const [imageFile, setImageFile] = useState<File | undefined>();

    const form = useForm<CreateWorkerAccountForm>({
        resolver: valibotResolver(CreateWorkerAccountSchema)
    })
    const { control, handleSubmit, register, formState: { errors } } = form;

    const handleCreateAccount = async (data: CreateWorkerAccountForm) => {
        const userId = getCookie("id")
        if (userId === undefined) {
            toast.error("error fetching user id")
            return;
        }
        try {
            let responseData: AxiosResponse | undefined;
            if (data.payment_type === "BANK") {
                const bankGateWay = paymentGateways.filter(item => item.payment_type === "BANK")[0];
                data.gateway_id = bankGateWay.id.toString();
            } 
            responseData = await handleAccountParamData(
                data,
                parseInt(data.worker_id),
                parseInt(data.gateway_id!),
                imageFile,
                parseInt(userId)
            );
            toast.success("Account created !!")

        } catch (error: any) {
            console.error(error);
            toast.error(error.response.data.message)
        }
    }

    const onFormError = (error: any) => {
        console.error(error);
    }

    const init = async () => {
        try {
            const workersData = await makeApiRequeest(
                `${BASE_URL}/api/user/role/worker`,
                HttpMethodType.POST,
                { includeToke: true, bodyParam: { skip: 0, take: 20 } }
            )
            const paymentGatewayData = await makeApiRequeest(
                `${BASE_URL}/api/payment_gateway/get`,
                HttpMethodType.POST,
                { includeToke: true, queryParam: { skip: 0, take: 10 } }
            )
            
            setWorkers(workersData?.data.data as [User])
            setPaymentGateways(paymentGatewayData?.data.data as [PaymentGateway])

        } catch (error: any) {
            console.error(error);
            toast.error(error.response.data.message)
        }
    }

    useEffect(() => {
        init();
    }, [])

    return (
        <div>
            <div className="flex flex-col m-0 p-0 gap-5">
                <div className="flex justify-start items-center">
                    <span className="font-medium pr-6">Create Account</span>
                    {/* <img className="w-10 h-10" src="https://cdn-icons-png.flaticon.com/128/6124/6124998.png" alt="" /> */}
                    <div className="grow"></div>

                    <AlertDialogCancel>
                        <IoMdClose />
                    </AlertDialogCancel>
                </div>


                <Form {...form}>
                    <form method='POST' onSubmit={handleSubmit(handleCreateAccount, onFormError)}>
                        {/* Name Field */}
                        <FormField
                            // control={control}
                            name=""
                            render={({ field }) => (
                                <FormItem className='mb-4'>
                                    <Label className=''>Name</Label>
                                    <Input {...field} placeholder='Enter name' />
                                </FormItem>
                            )}
                        />

                        {/* Account Type Field */}
                        <FormField
                            control={control}
                            name="payment_type"
                            render={({ field }) => (
                                <FormItem className='mb-4'>
                                    <Label className=''>Account type</Label>

                                    <Select {...field} defaultValue={field.value} onValueChange={val => {
                                        field.onChange(val)
                                        setAccountType(val);
                                        // form.reset()
                                    }}>
                                        <SelectTrigger defaultValue={"UPI"} className="w-full rounded-none rounded-l-md">
                                            <SelectValue className=' placeholder:text-gray-100' placeholder="Select type" />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectGroup>
                                                <SelectItem value="QR">QR code</SelectItem>
                                                <SelectItem value="BANK">Bank account</SelectItem>
                                                <SelectItem value="UPI">Normal UPI</SelectItem>
                                            </SelectGroup>
                                        </SelectContent>
                                    </Select>
                                    {errors.payment_type && (
                                        <p className="text-xs text-red-500">
                                            {errors.payment_type.message?.toString()}
                                        </p>
                                    )}

                                </FormItem>
                            )}
                        />

                        {/* Conditional Fields Based on Account Type */}
                        {accountType !== "BANK" && (
                            <FormField
                                control={control}
                                name="gateway_id"
                                render={({ field }) => (
                                    <FormItem className='mb-4'>
                                        <Label className=''>Payment Gateway</Label>

                                        <Select {...field} value={field.value!} onValueChange={field.onChange}>
                                            <SelectTrigger className="w-full rounded-none rounded-l-md">
                                                <SelectValue className=' placeholder:text-gray-100' placeholder="Select gateway" />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectGroup>
                                                    {accountType === "QR" ? (
                                                        paymentGateways.filter((val: PaymentGateway) => val.payment_type === "QR").map((gateway: PaymentGateway) => {
                                                            return (
                                                                <>
                                                                    <SelectItem value={gateway.id.toString()}>{gateway.name}</SelectItem>
                                                                </>
                                                            )
                                                        })
                                                    ) : (
                                                        paymentGateways.filter((val: PaymentGateway) => val.payment_type === "UPI").map((gateway: PaymentGateway) => {
                                                            return (
                                                                <>
                                                                    <SelectItem value={gateway.id.toString()}>{gateway.name}</SelectItem>
                                                                </>
                                                            )
                                                        })
                                                    )}
                                                </SelectGroup>
                                            </SelectContent>
                                        </Select>
                                        {errors.gateway_id && (
                                            <p className="text-xs text-red-500">
                                                {errors.gateway_id.message?.toString()}
                                            </p>
                                        )}
                                    </FormItem>
                                )}
                            />
                        )}

                        {accountType === "BANK" && (
                            <>
                                <FormField
                                    control={control}
                                    name="bank_name"
                                    render={({ field }) => (
                                        <FormItem className='mb-4'>
                                            <Label className=''>Bank</Label>
                                            <Input value={field.value!} onChange={field.onChange} id="bank" type="text" placeholder="Enter bank name" />
                                            {errors.bank_name && (
                                                <p className="text-xs text-red-500">
                                                    {errors.bank_name.message?.toString()}
                                                </p>
                                            )}
                                        </FormItem>
                                    )}
                                />
                                <FormField
                                    control={control}
                                    name="account_holder"
                                    render={({ field }) => (
                                        <FormItem className='mb-4'>
                                            <Label className=''>Account holder</Label>
                                            <Input value={field.value!} onChange={field.onChange} id="accountHolder" type="text" placeholder="Enter holder name" />
                                            {errors.account_holder && (
                                                <p className="text-xs text-red-500">
                                                    {errors.account_holder.message?.toString()}
                                                </p>
                                            )}
                                        </FormItem>
                                    )}
                                />
                                <FormField
                                    control={control}
                                    name="account_number"
                                    render={({ field }) => (
                                        <FormItem className='mb-4'>
                                            <Label className=''>Account number</Label>
                                            <Input value={field.value!} onChange={field.onChange} id="accountNumber" placeholder="Enter account number" />
                                            {errors.account_number && (
                                                <p className="text-xs text-red-500">
                                                    {errors.account_number.message?.toString()}
                                                </p>
                                            )}
                                        </FormItem>
                                    )}
                                />
                                <FormField
                                    control={control}
                                    name="ifsc_code"
                                    render={({ field }) => (
                                        <FormItem className='mb-4'>
                                            <Label className=''>IFSC</Label>
                                            <Input value={field.value!} onChange={field.onChange} id="ifsc" type="text" placeholder="Enter IFSC" />
                                            {errors.ifsc_code && (
                                                <p className="text-xs text-red-500">
                                                    {errors.ifsc_code.message?.toString()}
                                                </p>
                                            )}
                                        </FormItem>
                                    )}
                                />
                            </>
                        )}

                        {accountType === "UPI" && (
                            <FormField
                                control={control}
                                name="upi_address"
                                render={({ field }) => (
                                    <FormItem className='mb-4'>
                                        <Label className=''>Mobile/UPI</Label>
                                        <Input {...field} value={field.value!} onChange={field.onChange} id="mobileUpi" type="text" placeholder="Enter mobile/UPI" />
                                        {errors.upi_address && (
                                            <p className="text-xs text-red-500">
                                                {errors.upi_address.message?.toString()}
                                            </p>
                                        )}
                                    </FormItem>
                                )}
                            />
                        )}

                        {accountType === "QR" && (
                            <>
                                <FormField
                                    control={control}
                                    name="qr_image"
                                    render={({ field }) => (
                                        <FormItem className='mb-4'>
                                            <Label className=''>Upload QR image</Label>
                                            <Input
                                                type="file"
                                                onChange={e => {
                                                    setImageFile(e.target.files?.[0])
                                                    field.onChange(e)
                                                }}
                                                value={field.value!}
                                                placeholder="Upload QR code"
                                            />
                                            {errors.qr_image && (
                                                <p className="text-xs text-red-500">
                                                    {errors.qr_image.message?.toString()}
                                                </p>
                                            )}
                                        </FormItem>
                                    )}
                                />
                            </>
                        )}

                        {/* Gmail Field */}
                        <FormField
                            control={control}
                            name="worker_id"
                            render={({ field }) => (
                                <FormItem className='mb-4'>
                                    <Label className=''>Select Gmail</Label>
                                    <Select {...field} value={field.value} onValueChange={field.onChange}>
                                        <SelectTrigger className="w-full rounded-none rounded-l-md">
                                            <SelectValue className=' placeholder:text-gray-100' placeholder="Select worker" />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectGroup>
                                                {workers.map((worker: User) => {
                                                    return <>
                                                        <SelectItem value={worker.id.toString()}>{worker.email}</SelectItem>
                                                    </>

                                                })}
                                            </SelectGroup>
                                        </SelectContent>
                                    </Select>
                                    {errors.worker_id && (
                                        <p className="text-xs text-red-500">
                                            {errors.worker_id.message?.toString()}
                                        </p>
                                    )}
                                </FormItem>
                            )}
                        />

                        <Button type="submit" className="bg-blue-600 mt-5 hover:bg-blue-700">Create</Button>
                    </form>
                </Form>



            </div>

        </div>
    )
}


export default CreateAccount;