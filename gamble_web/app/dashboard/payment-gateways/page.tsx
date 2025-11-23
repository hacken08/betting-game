"use client";

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { PaymentGateway } from "@/models/paymentGatewayModel";
import { Tag, Image, Skeleton, Dropdown, Button } from "antd";
import axios, { AxiosError } from "axios";
import { getCookie } from "cookies-next";
import { jwtDecode } from "jwt-decode";
import { List } from "postcss/lib/list";
import React, { useEffect, useState } from "react";
import { toast } from "react-toastify";

const PaymentGatewayPage = () => {
  const [paymentGateways, setPaymentGateways] = useState<[PaymentGateway] | []>(
    []
  );
  const [isLoading, setIsLoading] = useState(false);
  const [statuses, setStatuses] = useState<string[] | []>(
    paymentGateways.map((gateway) => gateway.status)
  );

  const updateStatusHandler = async (
    id: number,
    status: string,
    index: number
  ) => {
    try {
      const updated_by = getCookie("id");
      if (updated_by === undefined) {
        toast.error("Error fetching user id");
        return;
      }
      await makeApiRequeest(
        `${BASE_URL}/api/payment_gateway/status`,
        HttpMethodType.POST,
        {
          includeToke: true,
          bodyParam: { id, status, updated_by: parseInt(updated_by) },
        }
      );
      const updatedStatuses = [...statuses];
      updatedStatuses[index] = status;
      setStatuses(updatedStatuses);
    } catch (error: any) {
      console.error(error);
      toast.error("Failed to change status");
    }
  };

  async function init() {
    setIsLoading(true);
    setTimeout(async () => {
      try {
        const responseData = await makeApiRequeest(
          `${BASE_URL}/api/payment_gateway/get`,
          HttpMethodType.POST,
          {
            queryParam: { skip: 0, take: 10 },
            includeToke: true,
            makeNewTokenReq: true,
          }
        );
        setPaymentGateways(responseData?.data.data ?? []);
        setStatuses(
          responseData?.data.data.map(
            (gateway: PaymentGateway) => gateway.status
          )
        );
        setIsLoading(false);
      } catch (error: any) {
        console.error(error);
        toast.error(error.response?.data.message);
      }
    }, 1000);
  }

  useEffect(() => {
    init();
  }, []);

  return (
    <div className="w-full h-full flex flex-col items-center justify-between px-4 py-2">
      <h1 className="text-xl mb-6 font-bold text-gray-800 uppercase tracking-wide leading-normal whitespace-pre-wrap break-words">
        Payment Gateways
      </h1>

      <Table className="border-2">
        <TableHeader>
          <TableRow className=" bg-zinc-100">
            <TableHead className="font-bold text-base text-center border-r-2">
              No.
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r-2">
              Name
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r-2">
              Image
            </TableHead>
            <TableHead className="font-bold text-base text-center border-r-2">
              Status
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {isLoading ? (
            <>
              {Array.from([1, 2, 3, 4, 5]).map((val, idx) => {
                return (
                  <TableRow key={idx}>
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
          ) : (
            paymentGateways.map((gateway: PaymentGateway, index) => {
              const currentStatus = statuses[index];

              return (
                <TableRow className="" key={index}>
                  <TableCell className="border-r text-center">
                    {++index}.
                  </TableCell>
                  <TableCell className="gap-2 border-r text-center ">
                    <span className="font-semibold text-lg">
                      {gateway.name}
                    </span>
                  </TableCell>
                  <TableCell className=" text-center border-r">
                    <Image
                      width={gateway.payment_type === "QR" ? 120 : 40}
                      preview={false}
                      src={`${BASE_URL}/${gateway.image}`}
                    />
                  </TableCell>
                  <TableCell className="text-center  border-r">
                    {/* <Tag color={`${gateway.status === "ACTIVE" ? "green" : "red"}`}>
                      {gateway.status}
                    </Tag> */}
                    <Dropdown
                      menu={{
                        items: [
                          {
                            key: "1",
                            label: (
                              <span
                                onClick={(e) => {
                                  // const updatedStatuses = [...statuses];
                                  // updatedStatuses[--index] = "INACTIVE";
                                  // setStatuses(updatedStatuses);
                                  updateStatusHandler(
                                    gateway.id,
                                    "INACTIVE",
                                    --index
                                  );
                                }}
                              >
                                INACTIVE
                              </span>
                            ),
                          },
                          {
                            key: "2",
                            label: (
                              <span
                                onClick={(e) => {
                                  // const updatedStatuses = [...statuses];
                                  // updatedStatuses[--index] = 'ACTIVE';
                                  // setStatuses(updatedStatuses);
                                  updateStatusHandler(
                                    gateway.id,
                                    "ACTIVE",
                                    --index
                                  );
                                }}
                              >
                                ACTIVE
                              </span>
                            ),
                          },
                        ],
                      }}
                      placement="bottomLeft"
                      className="w-20"
                    >
                      {currentStatus === "ACTIVE" ? (
                        <Button className="bg-[#f6ffed] hover:bg-[#f6ffed] text-[#389e0d]  border-[0.05px] border-[#389e0d] font-normal text-xs h-6 m-0 p-0 px-3">
                          {currentStatus}
                        </Button>
                      ) : (
                        <Button className="bg-[#fff1f0] hover:bg-[#fff1f0] text-[#cf1322]  border-[0.05px] border-[#cf1322] font-normal text-xs h-6 m-0 p-0 px-3">
                          {currentStatus}
                        </Button>
                      )}
                    </Dropdown>
                  </TableCell>
                </TableRow>
              );
            })
          )}
        </TableBody>
      </Table>
    </div>
  );
};

export default PaymentGatewayPage;

const tableValues = [
  {
    gatewayName: "Paytm",
    logoPath: "",
    imagePath:
      "https://cdn.iconscout.com/icon/free/png-256/free-paytm-226448.png?f=webp&w=256",
    width: 40,
    height: 40,
    status: "Active",
  },
  {
    gatewayName: "Phone pe",
    logoPath: "",
    imagePath:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo4x8kSTmPUq4PFzl4HNT0gObFuEhivHOFYg&s",
    width: 40,
    height: 40,
    status: "Active",
  },
  {
    gatewayName: "Google pay",
    logoPath: "",
    imagePath: "https://cdn-icons-png.flaticon.com/128/6124/6124998.png",
    width: 50,
    height: 50,
    status: "Active",
  },
  {
    gatewayName: "UPI",
    logoPath: "",
    imagePath:
      "https://cdn.icon-icons.com/icons2/2699/PNG/512/upi_logo_icon_169316.png",
    width: 60,
    height: 40,
    status: "Active",
  },
  {
    gatewayName: "Paytm qr",
    logoPath: "",
    imagePath: "/paytm qr.png",
    width: 160,
    status: "Active",
  },
  {
    gatewayName: "Phone pe qr",
    logoPath: "",
    imagePath: "/phone pe qr.png",
    width: 160,
    height: 40,
    status: "Inactive",
  },
  {
    gatewayName: "Google pay qr",
    logoPath: "",
    imagePath: "/gpay qr.png",
    width: 50,
    height: 50,
    status: "Active",
  },
  {
    gatewayName: "QR code",
    logoPath: "",
    imagePath: "/all qr.jpeg",
    width: 160,
    height: 40,
    status: "Active",
  },
  {
    gatewayName: "Bank account",
    logoPath: "",
    imagePath:
      "https://www.clipartkey.com/mpngs/m/84-841013_bank-png-blue-bank-icon.png",
    width: 40,
    height: 40,
    status: "InActive",
  },
];
