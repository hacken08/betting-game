"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { FaMoneyBillTrendUp } from "react-icons/fa6";

import {
  FluentWalletCreditCard16Regular,
  MaterialSymbolsBubbleChartOutlineRounded,
  MaterialSymbolsDashboard,
  MaterialSymbolsHeadsetMicOutlineRounded,
  MaterialSymbolsLightCloseSmallOutlineRounded,
  MaterialSymbolsLightFeatureSearchOutline,
  MaterialSymbolsManageHistory,
  SystemUiconsBell,
  SystemUiconsBook,
  SystemUiconsUserAdd,
  SystemUiconsUserMale,
} from "../Icon";

import { Drawer, Image } from "antd";
import { Dispatch, SetStateAction } from "react";
import { BiMoneyWithdraw } from "react-icons/bi";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";
import { getCookie } from "cookies-next";
import { toast } from "react-toastify";

const navLinks = [
  {
    name: "Dashboard",
    url: "/dashboard/home",
    icon: <MaterialSymbolsDashboard />,
    role: ["USER", "ADMIN", "WORKER"],
  },
  {
    name: "Games",
    url: "/dashboard/games",
    icon: <MaterialSymbolsBubbleChartOutlineRounded />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Submit Result",
    url: "/dashboard/submit-result",
    icon: <SystemUiconsBook />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Cancle Result Number",
    url: "/dashboard/cancle-result",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Total bid amount",
    url: "/dashboard/total-bid",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Excel Record",
    url: "/dashboard/excel-record",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Total winner",
    url: "/dashboard/total-winner",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Set Amount",
    url: "/dashboard/set-amount",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Create User",
    url: "/dashboard/create-user",
    icon: <SystemUiconsUserAdd />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Testing page(payment gateway)",
    url: "/dashboard/create-temp",
    icon: <SystemUiconsUserAdd />,
  },
  {
    name: "X Customer care direct chat",
    url: "/dashboard/customer-care-chat",
    icon: <MaterialSymbolsHeadsetMicOutlineRounded />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Users",
    url: "/dashboard/users",
    icon: <SystemUiconsUserMale />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Payment Gateways",
    url: "/dashboard/payment-gateways",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Withdraw Record",
    url: "/dashboard/withdraw-record",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Money status",
    url: "/dashboard/money-status",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "All money Request",
    url: "/dashboard/all-money-request/add",
    icon: <FaMoneyBillTrendUp className="text-sm" />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "All withdraw Request",
    url: "/dashboard/all-money-request/withdraw",
    icon: <BiMoneyWithdraw className="text-xl p-0 m-0" />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Admin panel",
    url: "/dashboard/admin-panel",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Daily work record",
    url: "/dashboard/daily-work-record",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Manage account",
    url: "/dashboard/manage-account",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "X Automatic approval",
    url: "/dashboard/automatic-approval",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "status",
    url: "/dashboard/status",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Statement",
    url: "/dashboard/statement",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Notification and Updates",
    url: "/dashboard/notification-and-updates",
    icon: <SystemUiconsBell />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Direct Add Cash",
    url: "/dashboard/direct-add-cash",
    icon: <FluentWalletCreditCard16Regular />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "P&L record",
    url: "/dashboard/p-and-l-record",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "Create Game",
    url: "/dashboard/create-game",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "X Approve gateway",
    url: "/dashboard/approve-gateway",
    icon: <MaterialSymbolsManageHistory />,
    role: ["USER", "ADMIN"],
  },
  {
    name: "OCR",
    url: "/dashboard/ocr",
    icon: <MaterialSymbolsLightFeatureSearchOutline />,
    role: ["USER", "ADMIN"],
  },
];

type SidebarProps = {
  isSidebarOpen: boolean;
  setSidebar: Dispatch<SetStateAction<boolean>>;
};

export default function Sidebar({ isSidebarOpen, setSidebar }: SidebarProps) {
  const pathname = usePathname();
  const userRole = getCookie("role")



  return (
    <div>
      {/* Mobile navigation */}
      <Drawer
        closeIcon={false}
        title={
          <div className="flex items-center gap-1 justify-between w-full">
            <div className="flex items-center gap-2">
              <Image
                preview={false}
                height={30}
                width={30}
                alt="NextUI hero Image"
                src="https://images.vexels.com/content/142789/preview/multicolor-swirls-circle-logo-41322f.png"
              />
              Gamble Zone
            </div>
            <MaterialSymbolsLightCloseSmallOutlineRounded
              className="text-3xl cursor-pointer"
              onClick={() => setSidebar(false)}
            />
          </div>
        }
        onClose={() => setSidebar(false)}
        open={isSidebarOpen}
        placement="left"
      >
        {/* ------------------ Mobile navigation ------------------ */}
        <div className="flex flex-col  gap-2 ">
          {navLinks.map((links: any, index: number) => {
            const route = links.url;
            const isActive = pathname === route;

            return (
              <div
                key={index}
                className={`${isActive ? " border-l-4 bg-slate-100 border-blue-500" : ""}  flex p-2 rounded gap-2`}>

                {
                  links.url === "/dashboard/admin-panel"
                    ? <Collapsible>
                      <CollapsibleTrigger className="flex gap-3">
                        <span className={`${isActive ? "text-[#3f2632]" : "text-black"} text-xl`}>
                          {links.icon}
                        </span>
                        {links.name}
                      </CollapsibleTrigger>
                      <CollapsibleContent className=" flex flex-col pl-8">
                        <Link onClick={e => setSidebar(false)} className="text-md   my-3" href={`/dashboard/sub-admin`}>Subadmin</Link>
                        <Link onClick={e => setSidebar(false)} className="text-md  " href={"/dashboard/blocked"}>
                          Blocked
                        </Link>
                      </CollapsibleContent>
                    </Collapsible>

                    :
                    <>
                      <span className={`${isActive ? "text-[#3f2632]" : "text-black"} text-xl`}>
                        {links.icon}
                      </span>

                      <Link onClick={e => setSidebar(false)} className={`text-md`}
                        href={links.url}>
                        {links.name}
                      </Link>
                    </>
                }
              </div>
            );
          })}
          <div className="mx-2">
            <button className="text-white bg-red-500 w-full mb-4 rounded py-2">
              Logout
            </button>
          </div>
        </div>
      </Drawer>

      {/* ------------------ Desktop navigation ------------------ */}
      <div className="hidden flex-col lg:flex min-w-64">
        <div className="flex items-center p-4 gap-2 justify-center">
          <Image
            preview={false}
            height={30}
            width={30}
            alt="NextUI hero Image"
            src="https://images.vexels.com/content/142789/preview/multicolor-swirls-circle-logo-41322f.png"
          />
          Gamble Zone
        </div>
        <div className=" h-[90vh] overflow-scroll" style={{ scrollbarWidth: "none" }} >
          {navLinks.map((item, index) => {
            // if (!item.role?.includes(userRole!)) {
            //   return null;
            // } 

            const route = item.url;
            const isActive = pathname === route;

            return (
              <div
                key={index}
                className={`flex gap-2 items-center justify-start cursor-pointer py-2 pr-2 pl-4 rounded-r-md ${isActive
                  ? "text-black bg-white border-blue-500 border-l-4"
                  : "text-gray-500  hover:text-black "
                  }`}>
                {
                  item.url === "/dashboard/admin-panel"
                    ? <Collapsible>
                      <CollapsibleTrigger className="text-gray-500 flex items-center gap-2 hover:text-black">
                        <span
                          className={`${isActive ? "text-blue-400" : "text-blue-600"} text-xl`}>
                          {item.icon}
                        </span>
                        {item.name}
                      </CollapsibleTrigger>
                      <CollapsibleContent className=" flex flex-col items-start pl-8 ">
                        <Link className="text-md my-3 text-gray-500  hover:text-black" href={`/dashboard/sub-admin`}>
                          Subadmin
                        </Link>
                        <Link className="text-md text-gray-500  hover:text-black" href={"/dashboard/blocked"}>
                          Blocked
                        </Link>
                      </CollapsibleContent>
                    </Collapsible>
                    :
                    <>
                      <span
                        className={`${isActive ? "text-blue-400" : "text-blue-600"} text-xl`}>
                        {item.icon}
                      </span>
                      <Link className={`text-md`} href={item.url}>
                        {item.name}
                      </Link>
                    </>
                }
              </div>
            );
          })}

          <div className="flex-1 py-4"></div>
          <div className="mx-2 ">
            <button className="text-white bg-red-500 w-full mb-4 rounded py-2">
              Logout
            </button>
          </div>
        </div>
      </div>

    </div>
  );
}

function SidebarLogo() {
  return (
    <h1 className="flex text-center items-center justify-center">
      <Image
        preview={false}
        height={50}
        width={50}
        alt="NextUI hero Image"
        src="https://static.vecteezy.com/system/resources/thumbnails/031/768/202/small/bird-feathers-logo-template-image-free-png.png"
      />
    </h1>
  );
}
