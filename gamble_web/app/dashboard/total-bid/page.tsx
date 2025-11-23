"use client";

import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import {
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { cn } from "@/lib/utils";
import { DailyGame } from "@/models/DailyGameModel";
import { Game } from "@/models/GameModel";
import { UserBet } from "@/models/UserBetModels";
import { useQuery } from "@tanstack/react-query";
import { DatePicker, Form, Input, Select } from "antd";
import { format } from "date-fns";
import { Calendar as CalendarIcon } from "lucide-react";
import { useState } from "react";
import { toast } from "react-toastify";

export default function TotalBidAmount() {
  const [date, setDate] = useState<Date>();
  const [games, setGames] = useState<Game[]>([])
  const [selectedGame, setSelectedGame] = useState<Game | undefined>(games[0])
  const [totalUserBets, setTotalUserBets] = useState<UserBet[]>([ ])
  const [form] = Form.useForm();
  const [sumbit, setSumbit] = useState(false);
  let counter = 0;

  const array = [...Array(10)];

  
  async function getUserbet(parms: any): Promise<UserBet[]> {
    // const selectedGame: Game = JSON.parse(values.game)
    try { 
      const response = await makeApiRequeest(
        `${BASE_URL}/api/user_bet/search`,
        HttpMethodType.GET,
        {
          queryParam: parms
        }
      );
      return response?.data.data as UserBet[]
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
      return []
    } 
  }

  async function getDailyGame(parms: any): Promise<DailyGame[]> {
    // const selectedGame: Game = JSON.parse(values.game)
    try { 
      
      const response = await makeApiRequeest(
        `${BASE_URL}/api/daily_game/search`,
        HttpMethodType.GET,
        {
          queryParam: parms
        }
      );
      return response?.data.data as DailyGame[]
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
      return []
    } 
  }

  const { isPending, error, data } = useQuery({
    queryKey: ["getAllCreatedGames"],
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

  async function handleSubmit() {
    if (selectedGame == undefined) return;
    const usersBet = await getUserbet({
      game_id: selectedGame?.id,
      created_at: date?.toJSON().split("T")[0]
    })
    usersBet.sort((a, b) => parseInt(a.bid_number) - parseInt(b.bid_number))
    const groupedBets = usersBet.reduce<Record<string, UserBet>>((acc, bet) => {
      const uniqueSearchKey = bet.bid_number + ` ${bet.game_type}`;
      // const uniqueSearchKey = bet.bid_number;
      const amount = parseFloat(bet.amount ?? "0.0"); 
      if (!acc[uniqueSearchKey]) {
        acc[uniqueSearchKey] = { ...bet, amount: amount.toString() };
      } else {
        acc[uniqueSearchKey].amount = (amount + parseFloat(acc[uniqueSearchKey].amount ?? "0.0")).toString();
      }
      return acc;
    }, {});
    const intoUserBets = Object.values(groupedBets)
    intoUserBets.sort((a, b) => parseInt(a.bid_number) - parseInt(b.bid_number))
    setTotalUserBets(intoUserBets)
    setSumbit(true)
  }

  console.log(totalUserBets);

  return (
    <>
      {/* <div className="flex bg-white p-3 rounded-md lg:items-end flex-col lg:flex-row gap-3 "> */}
        <Form className="flex px-3 mt-5 rounded-md lg:items-center flex-col lg:flex-row gap-3">
          <Form.Item name="date" rules={[{ required: true }]} className="m-0 ">
            <DatePicker className="w-52 h-10" onChange={date=> form.setFieldValue("date", date)} />
          </Form.Item>
          
          <Form.Item name="game" rules={[{ required: true }]} className="m-0">
            <Select
              placeholder="Select a game"
              onChange={e => setSelectedGame(JSON.parse(e))}
              value={selectedGame === undefined ? undefined : JSON.stringify(selectedGame)}
              className="w-[500px] h-10 m-0"
              options={
                games.map((game: Game) => {
                  return { label: game.name, value: JSON.stringify(game) }
                })
              }
            />
          </Form.Item>
          <Button
            className="bg-blue-600 hover:bg-blue-700"
            onClick={() => handleSubmit()}>
            Submit
          </Button>
        </Form>
        {/* </div> */}
      {/* </div> */}

      { (
        
        <>
          <div className="bg-white p-3 rounded-md mt-3 flex flex-col overflow-auto sm:items-center justify-center">
            {/* Main Game */}
            <div className="grid md:grid-cols-10 sm:grid-cols-7 grid-cols-7 grid-flow-dense gap-1">
              {sumbit &&  Array.from({ length: 100 }).map((_, index: number) => {
                const bidNumber = index + 1 === 100 ? "00" : (index + 1).toString().length === 1 ? `0${(index + 1).toString()}` : (index + 1).toString();
                const userBet = totalUserBets.find((bet) => bet.bid_number === bidNumber && bet.game_type == "JODI");
                const bidValue =  userBet ? userBet.amount : "--"

                return (
                  <div
                    key={index}
                    className="text-center rounded-sm bg-gray-100 w-28"
                  >
                    <p className="bg-indigo-600 text-white">{bidNumber}</p>
                    <p className="text-xs text-ellipsis">{bidValue}</p>
                  </div>
                );
              })}
            </div>
          </div>


          {/* ......... Ander ....... */}
          <div className="bg-white p-3 rounded-md mt-3 flex flex-col overflow-auto sm:items-center justify-center">

            {sumbit && <h1 className="flex w-full text-lg justify-center mt-6 font-bold">Ander / A</h1>}
            <table className="borde flex">
              {sumbit &&  Array.from({ length: 10 }).map((_, index: number) => {
                const bidNumber = index + 1 === 10 ? "0" : (index + 1).toString().length === 1 ? `0${(index + 1).toString()}` : (index + 1).toString();
                  const userBet = totalUserBets.find((bet) => bet.bid_number === bidNumber && bet.game_type == "ANDER");
                  const bidValue =  userBet ? userBet.amount : "--"

                  return (
                    <tr className="w-full" key={index}>
                      <td className="text-center sm:m-[3px]  m-0 md:w-28 sm:w-16 w-12 ">
                        <div className="text-center rounded-sm bg-gray-100" >
                          <p className="bg-indigo-600 text-white">{bidNumber}</p>
                          <p className="text-xs text-ellipsis">{bidValue}</p>
                        </div>
                    </td>
                  </tr>
                  );
                })}
            </table>
          </div>
          {/* ......... Baher ....... */}
          <div className="bg-white p-3 rounded-md mt-3 flex flex-col overflow-auto sm:items-center justify-center">

            {sumbit && <h1 className="flex w-full text-lg justify-center mt-6 font-bold">Baher / B</h1>}
            <table className="borde flex">
              {sumbit &&  Array.from({ length: 10 }).map((_, index: number) => {
                const bidNumber = index + 1 === 10 ? "0" : (index + 1).toString().length === 1 ? `0${(index + 1).toString()}` : (index + 1).toString();
                  const userBet = totalUserBets.find((bet) => bet.bid_number === bidNumber && bet.game_type == "BAHER");
                  const bidValue =  userBet ? userBet.amount : "--"

                  return (
                    <tr className="w-full" key={index}>
                      <td  className="text-center sm:m-[3px]  m-0 md:w-28 sm:w-16 w-12 ">
                        <div
                          key={index}
                          className="text-center rounded-sm bg-gray-100"
                        >
                          <p className="bg-indigo-600 text-white">{bidNumber}</p>
                          <p className="text-xs text-ellipsis">{bidValue}</p>
                        </div>
                    </td>
                  </tr>
                  );
                })}
            </table>
          </div>
        </>

      )}
    </>
  );
}

type GameType = {
  key: string;
  name: string;
  participant: number;
  totalBet: number;
  winners: number;
};

const gamesData: GameType[] = [
  {
    key: "1",
    name: "Desawar",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "2",
    name: "Silver guru",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "3",
    name: "Faridabad",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "4",
    name: "Gaziabad",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
  {
    key: "5",
    name: "Gali",
    participant: 50,
    totalBet: 23843,
    winners: 4,
  },
];
