"use client";
import { TbReload } from "react-icons/tb";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import AddMoney from "./add-money";
import WithdrawMoney from "./withdraw-money";
// import { Skeleton } from "antd";
// import { useTab } from "@/state/tabState";
import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { BankGatewayCard, QRGatewaysCard, UpiGatewaysCard } from "@/components/infoCards/GatewaysCard";
import { useTab } from "@/state/tabState";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { toast } from "react-toastify";
import { PaymentGateway } from "@/models/paymentGatewayModel";
import { Skeleton } from "@/components/ui/skeleton";
import { getCookie } from "cookies-next";
import { WorkersAccount } from "@/models/workerAccountModel";


export default function Home() {
  const { currentTab, setCurrentTab } = useTab();
  const [isLoading, setIsLoading] = useState(false)
  const [PaymentGateways, setPaymentGateways] = useState<PaymentGateway[]>([])
  const [workerAccounts, setWorkerAccounts] = useState<WorkersAccount[]>([])

  const handleUploadFile = async () => {
    
  }

  async function init() {
    setIsLoading(true);
    const userId = getCookie("id")
    if (userId === undefined) {
      toast.error("error fetching user id")
      return;
    }
    try {
      const responseData = await makeApiRequeest(
        `${BASE_URL}/api/payment_gateway/get`,
        HttpMethodType.POST,
        {
          queryParam: { skip: 0, take: 10 },
          includeToke: true,
          makeNewTokenReq: true
        }
      )
      console.log(responseData?.data.data);
      const workerAccountResponse = await makeApiRequeest(
        `${BASE_URL}/api/account/get_workers_account/${userId}`,
        HttpMethodType.POST,
        {
          queryParam: { skip: 0, take: 10 },
          includeToke: true,
          makeNewTokenReq: true
        }
      )
      setWorkerAccounts(workerAccountResponse?.data.data);
      setPaymentGateways(responseData?.data.data)
      setIsLoading(false);
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
    }
  } 

  useEffect(() => {
    init();
  }, [])


  return (
    <div className="">
      {/* <LoadingBar progress={50} className="text-blue-600" /> */}
      <div className="">
        <div className="flex gap-2 items-center my-5 flex-row justify-between md:flex-row ">
          <Button className="mr-4 text-white text-sm bg-blue-500 hover:bg-blue-600 h-8 py-1 px-2 rounded-md">
            <TbReload className="text-lg" />
          </Button>
          {
            currentTab === "add" && (
              <Button onClick={handleUploadFile} className="w-full md:w-32  mr-2 text-white h-8 text-sm bg-blue-500 hover:bg-blue-600 py-1 px-2 rounded-md">
                Upload file
              </Button>
            )
          }
        </div>
        <div className=" bg-white px-4 rounded-md w-full justify-center gap-3 items-center">
          {/* <TableHead className="border text-center">GPay</TableHead>
                  <TableHead className="border text-center">Phone Pay</TableHead>
                  <TableHead className="border text-center">Paytm</TableHead>
                  <TableHead className="border text-center">PayPal QR</TableHead> */}
          {/* <Switch id="toggle-add" /> */}

          {currentTab === "add" &&
            (
              <div
                className="flex gap-6 sm:justify-center overflow-auto "
                style={{ scrollbarWidth: "none" }}
              >
                {
                  isLoading
                    ? Array.from([12, 3, 4, 5, 6, 7, 8, 0]).map((val, idx) => {
                      return <>
                        <Skeleton key={idx} className="h-[95px] w-[85px] bg-[#f0f0f0] rounded-xl" />
                      </>
                    })
                    : PaymentGateways.map((gateway: PaymentGateway, idx) => {
                      if (gateway.payment_type === "QR") {
                        const accountList = workerAccounts.filter(acc => acc.gateway_id === gateway.id);
                        return <>
                          <QRGatewaysCard
                            key={idx}
                            img={`${BASE_URL}/${gateway.short_image}`}
                            width={60}
                            gatewayName={gateway.name}
                            gatewayId={gateway.id}
                            accounts={accountList}
                          />
                        </>
                      } else if (gateway.payment_type === "UPI") {
                        const accountList = workerAccounts.filter(acc => acc.gateway_id === gateway.id);
                        return <>
                          <UpiGatewaysCard
                            key={idx}
                            img={`${BASE_URL}/${gateway.image}`}
                            width={45}
                            gatewayName={gateway.name}
                            gatewayId={gateway.id}
                            accounts={accountList}
                          />
                        </>
                      } else {
                        const accountList = workerAccounts.filter(acc => acc.gateway_id === gateway.id);
                        return <>
                          <BankGatewayCard
                            key={idx}
                            img={`${BASE_URL}/${gateway.image}`}
                            width={45}
                            gatewayName={gateway.name}
                            gatewayId={gateway.id}
                            accounts={accountList}
                          />
                        </>
                      }
                    })
                }

              </div>
            )
          }

          {/* ************************** withdraw and add money tabs ************************** */}
          <Tabs
            defaultValue={currentTab}
            className="w-full flex flex-col mt-7 sm:mt-14 mb-0 sm:mb-12"
          >
            <TabsList className=" m-auto mb-0  ">
              <TabsTrigger
                className=" text-lg"
                value="add"
                onClick={() => setCurrentTab("add")} >
                Add Money
              </TabsTrigger>
              <TabsTrigger
                className=" text-lg"
                value="withdraw"
                onClick={() => setCurrentTab("withdraw")}
              >
                Withdraw Money
              </TabsTrigger>
            </TabsList>

            <TabsContent className="m-0 p-0" value="add">
              <AddMoney />
            </TabsContent>

            <TabsContent value="withdraw">
              <WithdrawMoney />
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
}
