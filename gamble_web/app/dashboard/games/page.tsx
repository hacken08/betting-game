"use client";

import { MaterialSymbolsLightDeleteRounded, MaterialSymbolsLightEdit } from "@/components/Icon";
import { Button } from "@/components/ui/button";
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
import { Game } from "@/models/GameModel";
import { useQuery } from "@tanstack/react-query";
import { Modal, Tag } from "antd";
import axios from "axios";
import { useState } from "react";
import { toast } from "react-toastify";

interface DisplayGame  {
  no: number,
  gameName: string,
  openTime: string,
  closeTime: string,
  status: string,
}


export default function AdminPanel() {
  const [gameData, setGameData] = useState<DisplayGame[]>([]);
  const [currentPage, setCurrentPage] = useState(1);
  const pageSize = 6;

  async function init() {
    let listOfGames: DisplayGame[] = [];
    const response = await makeApiRequeest(
      `${BASE_URL}/api/game`,
      HttpMethodType.GET,
      { queryParam: {take: pageSize, skip: (currentPage - 1) * pageSize,} }
    );
    if (!response) return;
    const fetchedGames =  (response.data?.data?.result ?? []) as Game[];

    for (const games of fetchedGames) {
      const response = await makeApiRequeest( `${BASE_URL}/api/daily_game/status/${games.id}`, HttpMethodType.GET, )
      let liveStatus: string = response?.data;
      listOfGames.push({
        no: games.id,
        gameName: games.name,
        openTime: games.start_time,
        closeTime: games.end_time,
        status: liveStatus
      })
    }

    setGameData(listOfGames)
    return listOfGames;
  }

  const { isPending, error, data } = useQuery({
    queryKey: ["getAllCreatedGames", currentPage],
    queryFn: async () => init(),
    staleTime: 0,
  });
  
  return (
    <>
      <div className="flex flex-col items-center w-full h-full bg-white rounded-md">
        <div className="flex items-center w-full justify-between">
          <h1 className="m-auto font-bold text-xl my-3 pl-20">All Games</h1>
            <Button
              className=""  
              onClick={() => window.location.replace(`/dashboard/create-game/create`)}
            >
              + Create New Game
            </Button>
            <div className="w-4"></div>
        </div>

        <div className="w-full flex-1 rounded-lg p-3">
          <Table className="border">
            <TableHeader>
              <TableRow className="bg-zinc-100">
                <TableHead className="text-center">No</TableHead>
                <TableHead className="text-center">Gamer Name</TableHead>
                <TableHead className="text-center">Open Time</TableHead>
                <TableHead className="text-center">Close Time</TableHead>
                <TableHead className="text-center">Status</TableHead>
                <TableHead className="text-left">Action</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody className="">
              {gameData.map((game: DisplayGame, index) => {
                return  (
                  <TableRow className="" key={index}>
                    <TableCell className="text-center min-w-15">{game.no}</TableCell>
                    <TableCell className="text-center   font-medium">{game.gameName}</TableCell>
                    <TableCell className="text-center  min-w-28">{new Date(game.openTime).toLocaleTimeString()}</TableCell>
                    <TableCell className="text-center min-w-28">{new Date(game.closeTime).toLocaleTimeString()}</TableCell>
                    <TableCell className="text-center min-w-28">
                    <Tag
                      color={
                        game.status === "ACTIVE"
                          ? "green"
                          : game.status === "UPCOMING"
                          ? "blue"
                          : "red"
                      }
                    >
                      {game.status}
                    </Tag>
                    </TableCell>
                    <TableCell className="text-right flex gap-5">
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
                            async onOk() {
                              try {
                                const response = await axios.delete(
                                  `${BASE_URL}/api/game/${game.no}`,
                                  { params: { deleted_by: "1", game_id: game.no }, }
                                );
                                if (!response) return;
                                init();
                                toast.success("Game is deleted")
                              } catch (error) {
                                console.error("Something went wrong ", error);
                                toast.error("Unable to deleted game")
                              }
                            },
                            onCancel() {},
                          });
                        }}
                      />
                    </TableCell>
                  </TableRow>
                )
              })}
            </TableBody>

          </Table>

          <Button className="w-full mt-4">View All</Button>
        </div>
      </div>
    </>
  );
}
