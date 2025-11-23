"use client";
import { useTab } from "@/state/tabState";
import Sidebar from "@/components/Dashboard/Sidebar";
import { IoReload } from "react-icons/io5";
import { TbReload } from "react-icons/tb";
import {
  FluentHome12Regular,
  MaterialSymbolsLightMenu,
} from "@/components/Icon";
// import { Avatar } from "antd";
import Link from "next/link";
import { useEffect, useState } from "react";
import { IoMenu } from "react-icons/io5";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Button } from "@/components/ui/button";
import { usePathname, useRouter } from "next/navigation";
import LoadingPageIndicator from "@/components/LoadingPageIndicator";
import { Modal } from "antd";
import { deleteCookie } from "cookies-next";
import { Replace } from "lucide-react";

export default function DashboardLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const [isSidebarOpen, setSidebar] = useState(false);
  const pathname = usePathname();
  const { currentTab, setCurrentTab } = useTab();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const route = useRouter();

  const handleLogout = () => {
    deleteCookie("session");
    route.replace("/login");
  };

  return (
    <div className="w-full flex bg-[#efefef] h-screen">
      <Sidebar isSidebarOpen={isSidebarOpen} setSidebar={setSidebar} />

      <div className="w-full p-1 sm:pb-5 py-0 flex flex-col h-full overflow-auto bg-white m-0">
        <div className=" bg-white sticky top-0 z-50 md:py-4 py-1 lg:px-4 px-0 lg:pb-1 pb-0 ">

          <div className=" lg:mb-3 mb-0 flex flex-col bg-[#341c8c] p-4 md:px-6 px-3 py-3 rounded-md">
            <div className="flex mb-4 justify-between">
              <div className="flex items-center  space-x-2">
                <Label
                  htmlFor="toggle-add"
                  className="text-sm sm:text-base text-white "
                >
                  Add
                </Label>
                <Switch className="" id="toggle-add" />
              </div>
              <div className="grow"></div>

              <div className="grow"></div>
              <div className="flex items-center space-x-2">
                <Label
                  htmlFor="toggle-withdraw"
                  className="text-sm sm:text-base text-white"
                >
                  Withdraw
                </Label>
                <Switch id="toggle-withdraw" />
              </div>
            </div>

            <div className="w-full mb-3 bg-white h-[0.5px]"></div>

            <div className="flex justify-between items-center ">
              <button
                className="bg-transparent sm:px-2 rounded-md hover:bg-[#4b30b0]"
                onClick={(e) => setSidebar(!isSidebarOpen)}
              >
                <IoMenu className=" text-3xl text-white" />
              </button>

              {pathname === "/dashboard/home" && currentTab !== "add" ? (
                <div className=" text-sm font-semibold sm:text-medium text-white">
                  WD limit: 234
                </div>
              ) : (
                <div className=" text-sm font-semibold sm:text-medium text-white">
                  Add limit: 234
                </div>
              )}
              <button
                onClick={(e) => setIsModalOpen(true)}
                className="md:w-32 sm:mr-2 text-black font-semibold h-8 text-sm bg-white hover:bg-zinc-100 py-1 px-2 rounded-md"
              >
                Log out
              </button>

              <Modal
                animation={false}
                centered
                title="Confirm logout"
                open={isModalOpen}
                onOk={handleLogout}
                onCancel={(e) => setIsModalOpen(false)}
              >
                <p>Are you sure you want to logout?</p>
              </Modal>
            </div>
          </div>
        </div>
        <div className="">{children}</div>
      </div>
    </div>
  );
}
