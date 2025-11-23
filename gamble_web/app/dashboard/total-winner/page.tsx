"use client";

import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { cn } from "@/lib/utils";
import { DailyGame } from "@/models/DailyGameModel";
import { Game } from "@/models/GameModel";
import { GameResult, UserGameResult } from "@/models/GameResultModel";
import { Divider } from "@nextui-org/react";
import { useQuery } from "@tanstack/react-query";
import { Select } from "antd";
import { format } from "date-fns";
import dayjs, { Dayjs } from "dayjs";
import { Calendar as CalendarIcon } from "lucide-react";
import { useRouter } from "next/navigation";
import { use, useRef, useState } from "react";
import { toast } from "react-toastify";

export default function TotalWinner() {
  const [date, setDate] = useState<Date>();
  const [game, setGame] = useState("");
  const [submit, setSubmit] = useState(false);
  const [searchedGame, setSearchedGame] = useState<DailyGame>();
  const [gameWinners, setGameWinners] = useState<UserGameResult[]>([]);
  const [games, setGames] = useState<Game[]>([])
  const [totalWinners, setTotalWinners] = useState(0)
  const [currentPage, setCurrentPage] = useState(1);
  const currentGame = useRef<Game>()

  const getGameData = () => {
    // setUserData(userGameFetchedData);
    setSubmit(true);
  };

  
  const pageSize = 1;
  const route = useRouter();

  const { isPending, error, data } = useQuery({
    queryKey: ["getAllCreatedGames", currentPage],
    queryFn: async () => {
     try {
        const response = await makeApiRequeest(
          `${BASE_URL}/api/game`,
          HttpMethodType.GET,
          { queryParam: {take: 6, skip: 0} }
        );
        if (response?.data) setGames(response.data?.data?.result ?? []);
        return response?.data.data ? response.data.data : response?.data;
      } catch (error: any) {
        console.error(error);
        toast.error(error.response?.data.message ?? error.message)
      }
    },
    staleTime: 0,
  });
    
  async function getDailyGame(parms: any) {
    if (currentGame.current === undefined || date === undefined) {
      return;
    }
    if (typeof date === 'string') return []
    let dateWithoutTime = `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`
    console.log("search params", { 
      game_id: currentGame.current?.id ?? 0 ,
      created_at: dateWithoutTime
    });
    
    try { 
      const response = await makeApiRequeest(
        `${BASE_URL}/api/daily_game/search`,
        HttpMethodType.GET,
        {queryParam: { 
          game_id: currentGame.current?.id ?? 0 ,
          created_at: dateWithoutTime
        }}
      );
      console.log(response);
      setSearchedGame(response?.data.data[0] as DailyGame);
      getGameWinners(response?.data.data[0].id)
      return;
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
      return;
    } 
  }

  async function getGameWinners(dailyGameId: number) {
    try { 
      const response = await makeApiRequeest(
        `${BASE_URL}/api/game_result/search`,
        HttpMethodType.GET,
        {queryParam: { 
          daily_game_id: dailyGameId ,
          result: "WIN"
        }}
      );
      console.log(response);
      const fetchedWinners = response?.data.data as UserGameResult[]
      let totalWinAmount: number = 0;
      for (const winner of fetchedWinners) {
        totalWinAmount = totalWinAmount + (parseInt(winner.amount) - parseInt(winner.user_bet.amount ?? "0"))
      }
      setTotalWinners(totalWinAmount)
      setGameWinners(fetchedWinners);
      return;
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
      return;
    } 
  }
  // console.log(gameWinners);
  

  return (
    <>
      <div className="bg-white w-full rounded-md p-3 px-6 ">
        <h1>Winners Record</h1>
        <Divider />

        <div className="relative w-full flex items-center gap-3 my-3">
          <p className="w-24">Select Date: </p>
          <Popover>
            <PopoverTrigger asChild>
              <Button
                variant={"outline"}
                className={cn(
                  "w-full lg:max-w-sm justify-start text-left font-normal",
                  !date && "text-muted-foreground"
                )}
              >
                <CalendarIcon className="mr-2 h-4 w-4" />
                {date ? format(date, "PPP") : <span>Pick a date</span>}
              </Button>
            </PopoverTrigger>
            <PopoverContent className="w-auto p-0">
              <Calendar
                mode="single"
                selected={date}
                onSelect={setDate}
                initialFocus
              />
            </PopoverContent>
          </Popover>
        </div>

        <div className="flex gap-3 items-center">
          <p className="w-24">Select Game: </p>
          <Select
            placeholder="Select a game"
            onChange={e=>currentGame.current = JSON.parse(e)}
            className="w-1/4"
            options={
              games.map((game: Game) => {
                return { label: game.name, value: JSON.stringify(game) }
              })
            }
          />
        </div>

        <div className="flex items-center justify-end">
          <Button
            variant="default"
            className="bg-blue-600 hover:bg-blue-700"
            onClick={async e=>{
              await getDailyGame({}); 
              // setTimeout(async ()=> , 1000)
            }}
          >
            Fetch
          </Button>
        </div>

        {searchedGame && (
          <div className="border border-indigo-600 rounded-md p-3 my-3 bg-indigo-600 mb-6 text-white ">
            <p>Winning Number: {searchedGame.result ?? "__"}</p>
            <p>Total Winner: {gameWinners.length}</p>
            <p>Total Winning amount: {totalWinners}</p>
          </div>
        )}

        {searchedGame && (
          <div className="flex flex-wrap justify-start gap-5 items-center">
            {gameWinners.map((user: UserGameResult, index: number) => {
              const creditAmount = parseInt(user.amount ?? "0") - parseInt(user.user_bet.amount ?? "0") ;
              // console.log(`${parseInt(user.amount ?? "0")} - ${parseInt(user.user_bet.amount ?? "0")}`);
              return (
                <div
                  key={index}
                  className="flex bg-gray-50 shadow-md flex-col justify-start items-center min-w-20 py-4 px-4 rounded-lg"
                >
                  <img
                    className="w-14 rounded-full"
                    src="https://cdn-icons-png.flaticon.com/128/3177/3177440.png"
                    alt=""
                  />
                  <div className="flex items-center my-2 text-base font-semibold gap-1">
                    <p className="">User Id: </p>
                    <div>{user.user_id}</div>
                  </div>

                  <div className="flex flex-wrap justify-center my-1 text-gray-400 text-xs gap-1">
                    <div className="  font-bold">Bidding Amt:</div>
                    <span className="font-semibold">{user.user_bet.bid_number}</span>
                  </div>

                  <div className="flex flex-wrap justify-center text-gray-400 text-xs gap-1">
                    <div className="  font-bold">Credit Amt:</div>
                    <span className="font-semibold">{creditAmount}</span>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </>
  );
}

const players = [
  {
    userId: 0,
    bidAmount: 231,
    winAmount: 34234,
  },
  {
    userId: 2,
    bidAmount: 231,
    winAmount: 34234,
  },
  {
    userId: 3,
    bidAmount: 231,
    winAmount: 34234,
  },
  {
    userId: 4,
    bidAmount: 231,
    winAmount: 34234,
  },
];

type GameType = {
  key: string;
  name: string;
  participant: number;
  totalBet: number;
  winners: number;
};

type Players = {
  userId: number;
  bidAmount: number;
  winAmount: number;
};

const gamesData: GameType[] = [
  {
    key: "1",
    name: "Monday Mania",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "2",
    name: "Monday Mania",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "3",
    name: "Monday Mania",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "4",
    name: "Monday Mania",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "5",
    name: "Monday Mania",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "6",
    name: "Monday Mania",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "7",
    name: "Monday Mania",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
];

type UserGameType = {
  userId: number;
  winAmount: number;
};

const userGameFetchedData = [
  { userId: 1, winAmount: 234 },
  { userId: 2, winAmount: 234 },
  { userId: 3, winAmount: 234 },
  { userId: 4, winAmount: 234 },
  { userId: 5, winAmount: 234 },
  { userId: 6, winAmount: 234 },
  { userId: 7, winAmount: 234 },
  { userId: 8, winAmount: 234 },
];
