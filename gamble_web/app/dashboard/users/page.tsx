"use client";

import { Button } from "@/components/ui/button";
import {
  HoverCard,
  HoverCardContent,
  HoverCardTrigger,
} from "@/components/ui/hover-card";
import { Input } from "@/components/ui/input";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { encryptURLData, HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { ApiResponseType } from "@/models/responseModel";
import { User } from "@/models/UserModel";
import { Divider, Select } from "@nextui-org/react";
import { Pagination, Skeleton, Tag } from "antd";
import { Axios, AxiosError, AxiosResponse } from "axios";
import { useRouter } from "next/navigation";
import { Suspense, useEffect, useRef, useState } from "react";
import { toast } from "react-toastify";

export default function Users() {
  const [open, setOpen] = useState(false);
  const [userId, setuserId] = useState("");
  const [mobileNumber, setMobileNumber] = useState("");
  const [allUsers, setAllUsers] = useState<[User] | []>([]);
  const [searchedUser, setSearcheduser] = useState<[User] | []>([]);
  const [isLoading, setIsLoading] = useState(false);
  const pageSize = useRef(3);
  const route = useRouter();

  const init = async (page: number, pageSize: number) => {
    setIsLoading(true);
    try {
      const responseData = await makeApiRequeest(
        `${BASE_URL}/api/user/get`,
        HttpMethodType.POST,
        {
          bodyParam: { skip: (page - 1) * pageSize, take: page * pageSize },
          // bodyParam: { skip: 0, take: 5 },
          includeToke: true,
        }
      );
      setAllUsers((responseData?.data.data as [User]) ?? []);
      setIsLoading(false);
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.data.message);
    }
  };

  const userSearchHandler = async () => {
    try {
      let responseData: AxiosResponse | undefined;
      if (userId !== "") {
        responseData = await makeApiRequeest(
          `${BASE_URL}/api/user/${userId}`,
          HttpMethodType.GET
        );
      } else if (mobileNumber !== "") {
        responseData = await makeApiRequeest(
          `${BASE_URL}/api/user/number/${mobileNumber}`,
          HttpMethodType.GET
        );
      } else {
        toast.error("Enter mobile number or user id");
        return;
      }
      console.log(responseData);
      setSearcheduser([responseData?.data.data]);
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message);
    }
  };

  useEffect(() => {
    init(1, pageSize.current);
  }, []);

  console.log(searchedUser);

  return (
    <Suspense>
      <main>
        <div className="shadow bg-white p-4 rounded-md">
          <h2 className="mx-auto text-lg font-medium text-left">Users</h2>
          <Divider className="my-2" />
          <div className="flex gap-2 md:flex-row flex-col">
            <Input
              value={userId}
              placeholder="User Id"
              className="w-full md:w-60"
              onChange={(e) => setuserId(e.target.value)}
            />
            <Input
              value={mobileNumber}
              onChange={(e) => setMobileNumber(e.target.value)}
              placeholder="Mobile number"
              className="w-full md:w-60"
            />
            <Button
              onClick={userSearchHandler}
              className="w-full md:w-32 text-white text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md"
            >
              Search
            </Button>
            <div className="grow"></div>
          </div>
        </div>

        <div className="shadow bg-white p-4 rounded-md mt-4">
          <Table className="border mt-2">
            <TableHeader>
              <TableRow className="bg-gray-100">
                <TableHead className="border text-center">Mobile</TableHead>
                <TableHead className="border text-center">
                  Wallet Amount (&#x20b9;)
                </TableHead>
                <TableHead className="border text-center">Status</TableHead>
                <TableHead className="w-28 border text-center">
                  Cash deducation
                </TableHead>
                <TableHead className="w-28 border text-center">
                  Set Password
                </TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading ? (
                <>
                  {Array.from([1, 2, 3, 4, 5, 6]).map((val, index) => {
                    return (
                      <TableRow key={index}>
                        <TableCell className="text-center border-r">
                          <Skeleton.Input className="w-52 rounded-full" active />
                        </TableCell>
                        <TableCell className="text-center border-r">
                          <Skeleton.Input className="w-52 rounded-full" active />
                        </TableCell>
                        <TableCell className="text-center border-r">
                          <Skeleton.Input className="w-52 rounded-full" active />
                        </TableCell>
                        <TableCell className="text-center border-r">
                          <Skeleton.Input className="w-52 rounded-full" active />
                        </TableCell>
                      </TableRow>
                    );
                  })}
                </>
              ) : searchedUser.length !== 0 ? (
                searchedUser.map((user: User, index) => {
                  return (
                    <TableRow key={index}>
                      <TableCell
                        className="p-2 cursor-pointer hover:bg-slate-200 border text-center ">
                        <button onClick={() => {
                          console.log("go to statmenst");
                          route.push(`/dashboard/users/profile/${encryptURLData(user.id.toString())}`);
                        }} >
                          <div className="pb-1">+91 {user.mobile ?? ""}</div>
                          <span className="font-bold">{`UserID: \n${user.id}`}</span>
                        </button>
                      </TableCell>
                      <TableCell className="p-2 border text-center">
                        {user.wallet}
                      </TableCell>
                      <TableCell className="p-2 border text-center">
                        <Input className="Enter Amount" />
                        <button className="w-full md:w-32 mt-1 text-white h-8 text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md">
                          Submit
                        </button>
                      </TableCell>
                      <TableCell className="p-2 border text-center">
                        <Input className="Enter new passwordS" />
                        <button className="w-full md:w-32 mt-1 text-white h-8 text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md">
                          Submit
                        </button>
                      </TableCell>
                    </TableRow>
                  );
                })
              ) : (
                allUsers.map((user: User, index) => {
                  return (
                    <TableRow key={index}>
                      <TableCell
                        className="p-2 cursor-pointer  border text-center "
                        onClick={() => {
                          console.log("go to statmenst");
                          route.push(`/dashboard/users/profile/${encryptURLData(user.id.toString())}`);
                        }}
                      >
                        <div className="pb-1 hover:text-blue-600">
                          +91 {user.mobile ?? ""}
                        </div>
                        <span className="font-bold">{`UserID: \n${user.id}`}</span>
                      </TableCell>
                      <TableCell className="p-2 border text-center">
                        {user.wallet}
                      </TableCell>
                      <TableCell className="p-2 border text-center">
                        <Tag color="green" className="h-auto">
                          ACTIVE
                        </Tag>
                      </TableCell>
                      <TableCell className="p-2 border text-center">
                        <Input className="Enter Amount" />
                        <button className="w-full md:w-32 mt-1 text-white h-8 text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md">
                          Submit
                        </button>
                      </TableCell>
                      <TableCell className="p-2 border text-center">
                        <Input className="Enter new passwordS" />
                        <button className="w-full md:w-32 mt-1 text-white h-8 text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md">
                          Submit
                        </button>
                      </TableCell>
                    </TableRow>
                  );
                })
              )}
            </TableBody>
          </Table>

          <div className="flex justify-start items-center">
            <Pagination
              className="my-3 mt-5"
              // current={currentPage}
              pageSize={pageSize.current}
              total={12}
              onChange={(page, pageSize) => {
                init(page, pageSize);
              }}
            />
          </div>

          <div className="w-full flex justify-start items-center">
            <button
              className="sm:w-full mt-2 md:w-32 text-white h-8 text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md"
              onClick={() => {
                route.push("/dashboard/users/profile");
              }}
            >
              Statement option
            </button>
          </div>
        </div>
      </main>
    </Suspense>
  );
}
