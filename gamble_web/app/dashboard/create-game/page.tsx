"use client";

import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { TimePicker, Input, TableProps, Table, Modal } from "antd";
import React, { useState } from "react";

import { toast } from "react-toastify";
import axios from "axios";
import { useMutation, useQuery } from "@tanstack/react-query";
import {
  MaterialSymbolsLightDeleteRounded,
  MaterialSymbolsLightEdit,
} from "@/components/Icon";
import { BASE_URL } from "@/lib/const";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";

// const Page = () => {
//   const route = useRouter();

//   return (
//     <div className="flex flex-col items-start w-full h-full bg-white rounded-md">
//       <h1 className="m-auto font-bold text-xl my-3">Daily work record</h1>

//       <form className="flex flex-col mt-3 w-[500px] gap-5">
//         <div className="flex  flex-col gap-2">
//           <Label>Game name</Label>
//           <Input type="text" placeholder="Enter game name" />
//         </div>

//         <div className="flex  gap-2">
//           <div className="flex flex-col gap-2  w-full">
//             <Label>Start time:</Label>
//             <TimePicker
//               className="w-full"
//               placeholder="Select start time"
//               defaultOpenValue={dayjs("00:00:00", "HH:mm:ss")}
//             />
//           </div>
//           <div className="flex flex-col w-full gap-2">
//             <Label>End time:</Label>
//             <TimePicker
//               className=""
//               placeholder="Select end time"
//               defaultOpenValue={dayjs("00:00:00", "HH:mm:ss")}
//             />
//           </div>
//         </div>
//         <div className="flex flex-col w-full gap-2">
//           <Label>Result time:</Label>
//           <TimePicker
//             className=""
//             placeholder="Select result time"
//             defaultOpenValue={dayjs("00:00:00", "HH:mm:ss")}
//           />
//         </div>

//         <Button
//           onClick={(e) => {
//             route.replace("/dashboard/result-securite-page");
//           }}
//           className="bg-blue-600 mt-2 hover:bg-blue-700"
//         >
//           Submit
//         </Button>
//       </form>
//     </div>
//   );
// };

interface DataType {
  key: string;
  name: string;
  start_time: string;
  end_time: string;
  max_number: number;
  max_price: string;
}

// TODO: add pagination
const Page = () => {
  const [gameData, setGameData] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);

  const pageSize = 6;

  const { isPending, error, data } = useQuery({
    queryKey: ["getAllCreatedGames", currentPage],
    queryFn: async () => {
      const response = await makeApiRequeest(
        `${BASE_URL}/api/game`,
        HttpMethodType.GET,
        { queryParam: {take: pageSize, skip: (currentPage - 1) * pageSize,} }
      );
      if (response?.data) setGameData(response.data?.data?.result ?? []);
      return response?.data.data ? response.data.data : response?.data;
    },
    staleTime: 0,
  });

  // if (isPending) {
  //   return <div>Loading...</div>;
  // }

  const columns: TableProps<DataType>["columns"] = [
    {
      title: "Name",
      dataIndex: "name",
      key: "uid",
    },
    {
      title: "Start Time",
      dataIndex: "start_time",
      key: "uid",
    },
    {
      title: "End Time",
      dataIndex: "end_time",
      key: "uid",
    },
    {
      title: "Max Number",
      dataIndex: "max_number",
      key: "uid",
    },
    {
      title: "Max Price",
      dataIndex: "max_price",
      key: "uid",
    },
    {
      title: "Action",
      dataIndex: "id",
      render: (id) => {
        return (
          <div className="flex gap-4 items-center justify-center">
            <MaterialSymbolsLightEdit
              fontSize={24}
              color="green"
              className="cursor-pointer"
            />
            <MaterialSymbolsLightDeleteRounded
              fontSize={24}
              color="red"
              className="cursor-pointer"
              onClick={() => {
                // delete game
                Modal.confirm({
                  title: "Do you want to delete this item?",
                  content: "Click Ok to continue",
                  onOk() {
                    return new Promise(async (resolve, reject) => {
                      const response = await axios.delete(
                        `${BASE_URL}/api/game/${id}`,
                        {
                          params: {
                            deleted_by: 1, // TODO: add genuine user
                          },
                        }
                      );
                      setGameData(
                        gameData.filter((item: any) => item.id != id)
                      );
                      resolve(response.data);
                    }).catch((e) => toast.error("Error deleting game: ", e));
                  },
                  onCancel() {},
                });
              }}
            />
          </div>
        );
      },
    },
  ];

  return (
    <div>
      <Table<DataType>
        columns={columns}
        dataSource={gameData}
        rowKey={"uid"}
        pagination={{
          total: data?.count ?? 0,
          pageSize: pageSize,
          current: currentPage,
          onChange: async (newPage) => {
            setCurrentPage(newPage);
          },
        }}
      ></Table>
      <Button
        className="w-full"
        onClick={() => window.location.replace(`/dashboard/create-game/create`)}
      >
        + Create New Game
      </Button>
    </div>
  );
};

export default Page;
