"use client";

import { IoShareSocial } from "react-icons/io5";
import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Modal, notification } from 'antd';
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { AxiosResponse } from "axios";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { ApiErrorType } from "@/models/responseModel";
import { CreateUserForm, CreateUserSchema } from "@/schema/create";
import { valibotResolver } from "@hookform/resolvers/valibot";
import { useMutation } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { toast } from "react-toastify";
import { useRef, useState } from "react";
import { Label } from "@/components/ui/label";
import { CopyIcon } from "lucide-react";
export default function CreateUser() {
  const [openDialog, setOpenDialog] = useState(false);
  const [password, setPassword] = useState('');
  const [api, contextHolder] = notification.useNotification();
  const apiResponse = useRef<AxiosResponse>();

  const form = useForm<CreateUserForm>({
    resolver: valibotResolver(CreateUserSchema),
  });

  const { register, handleSubmit, control, formState: { errors } } = form;
  const { mutate } = useMutation({
    mutationKey: ["create_user"],
    mutationFn: async (data: CreateUserForm) => {
      const responsedata = await makeApiRequeest(
        `${BASE_URL}/api/user/create`,
        HttpMethodType.POST,
        { bodyParam: data, includeToke: false, makeNewTokenReq: false, }
      );
      apiResponse.current = responsedata;
      setOpenDialog(true);
      form.reset();
      toast.success("User Create success");
    },
    onError: (error: ApiErrorType) => {
      toast.error(error.response.data.message);
    },
  });

  const openNotification = (value: string) => {
    api.success({
      message: `${value} copied !!`,
      description: "",
      placement: "top"
    });
  };

  return (
    <>
      {contextHolder}
      <Modal
        open={openDialog}
        onOk={() => setOpenDialog(false)}
        onCancel={() => setOpenDialog(false)}
        centered
        closable={false}
        footer={[
          <Button key="close" onClick={() => setOpenDialog(false)} className="border hover:bg-slate-200" variant="secondary">
            Close
          </Button>,
          <Button key="share" onClick={() => setOpenDialog(false)} className="ml-3 bg-blue-600 hover:bg-blue-700" variant="default">
            <IoShareSocial className="mr-2" />
            <span>Share</span>
          </Button>
        ]}
      >
        <h1 className="text-black font-semibold text-xl mb-5">User Created ✅</h1>
        <div className="flex items-center justify-between mb-1">
          <span className="font-semibold mx-2">Email :</span>
          <span>{apiResponse.current?.data.data.email}</span>
          <Button onClick={() => {
            navigator.clipboard.writeText(apiResponse.current?.data.data.email);
            openNotification("Email");
          }} size="sm" className="px-3 text-black bg-transparent hover:bg-slate-100">
            <CopyIcon className="h-4 w-4" />
          </Button>
        </div>
        <div className="flex items-center justify-between mt-1">
          <span className="font-semibold mx-2">Password:</span>
          <span className="truncate">{password}</span>
          <Button onClick={() => {
            navigator.clipboard.writeText(password);
            openNotification("Password");
          }} size="sm" className="px-3 bg-transparent text-black hover:bg-slate-100">
            <CopyIcon className="h-4 w-4" />
          </Button>
        </div>
      </Modal>

      <div className="p-3 bg-white rounded-md w-full flex flex-col items-start gap-3">
        <h1 className="text-2xl font-semibold">Create User</h1>
        <Form {...form}>
          <form
            onSubmit={handleSubmit(e => mutate(e))}
            className="space-y-6 mt-3 w-full"
          >

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-5 sm:w-[612px] w-full">
              <div className="flex flex-col">
                <Label htmlFor="name" className="text-sm font-medium text-gray-600 mb-1">Name</Label>
                <Input id="name" placeholder="Name" {...register("name")} className="h-10" />
                {errors.name && <p className="text-xs text-red-500 mt-1">{errors.name.message?.toString()}</p>}
              </div>
              <div className="flex flex-col">
                <Label htmlFor="email" className="text-sm font-medium text-gray-600 mb-1">Email</Label>
                <Input id="email" placeholder="Email" {...register("email")} className="h-10" />
                {errors.email && <p className="text-xs text-red-500 mt-1">{errors.email.message?.toString()}</p>}
              </div>
              <div className="flex flex-col">
                <Label htmlFor="number" className="text-sm font-medium text-gray-600 mb-1">Number</Label>
                <Input id="number" placeholder="Number" {...register("number")} className="h-10" />
                {errors.number && <p className="text-xs text-red-500 mt-1">{errors.number.message?.toString()}</p>}
              </div>
              <div className="flex flex-col">
                <Label htmlFor="password" className="text-sm font-medium text-gray-600 mb-1">Password</Label>
                <Input id="password" type="password" placeholder="Password" {...register("password")} onChange={(e) => setPassword(e.target.value)} className="h-10" />
                {errors.password && <p className="text-xs text-red-500 mt-1">{errors.password.message?.toString()}</p>}
              </div>
            </div>

            <div className="flex flex-col sm:w-[300px] w-full">
              <Label htmlFor="role" className="text-sm font-medium text-gray-600 mb-1">User Type</Label>
              <FormField
                control={control}
                name="role"
                render={({ field }) => (
                  <Select onValueChange={field.onChange} defaultValue={field.value}>
                    <FormControl>
                      <SelectTrigger className="w-full">
                        <SelectValue placeholder="Select role" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      <SelectGroup>
                        {userType.map((user, index) => (
                          <SelectItem key={index} value={user}>
                            {user.charAt(0).toUpperCase() + user.slice(1).toLowerCase()}
                          </SelectItem>
                        ))}
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                )}
              />
              {errors.role && <p className="text-xs text-red-500">{errors.role.message?.toString()}</p>}
            </div>
            <Button type="submit" className="w-full sm:w-[130px] mt-5">Create</Button>
          </form>
        </Form>
      </div>
    </>
  );
}

const userType: string[] = ["SYSTEM", "ADMIN", "WORKER", "USER"];
