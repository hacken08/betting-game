"use client";

import SimpleCard from "@/components/Dashboard/SimpleCard";
import { MaterialSymbolsPerson } from "@/components/Icon";
import { Button } from "@/components/ui/button";
import { useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { Divider } from "@nextui-org/react";
import { DatePicker, DatePickerProps, Form, Input, InputNumber, List, Select } from "antd";
import { format } from "date-fns";

import { useRef, useState } from "react";
import { Calendar as CalendarIcon } from "lucide-react";
import { Game } from "@/models/GameModel";
import { HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { useQuery } from "@tanstack/react-query";
import { toast } from "react-toastify";
import { stringify } from "querystring";
import { string } from "valibot";
import { UserBet } from "@/models/UserBetModels";
import { User } from "@/models/UserModel";
import { DailyGame } from "@/models/DailyGameModel";
import { Dayjs } from "dayjs";

type Players = {
  userId: number;
  bidAmount: number;
  creditAmount: number;
};

const layout = {
  labelCol: { span: 0 },
  wrapperCol: { span: 30 },
};


export default function SubmitResult() {
  const [currentPage, setCurrentPage] = useState(1);
  const [games, setGames] = useState<Game[]>([])
  const [showWinners, setShowWinners] = useState<Players[]>([])
  const [totalWinningAmount, setTotalWinningAmount] = useState<number>()
  const [totalBidAmount, setTotalBidAmount] = useState<number>()
  const [winningNumber, setWinningNumber] = useState<string>()
  const currentGame = useRef<Game>()
  const [form] = Form.useForm();

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

  async function getUserbet(parms: any): Promise<UserBet[]> {
    // const selectedGame: Game = JSON.parse(values.game)
    try { 
      const response = await makeApiRequeest(
        `${BASE_URL}/api/user_bet/search`,
        HttpMethodType.GET,
        { queryParam: parms }
      );
      return response?.data.data as UserBet[]
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
      return []
    } 
  }

  async function getDailyGame(parms: any): Promise<DailyGame[]> {
    try { 
      const response = await makeApiRequeest(
        `${BASE_URL}/api/daily_game/search`,
        HttpMethodType.GET,
        { queryParam: parms }
      );
      return response?.data.data as DailyGame[]
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
      return []
    } 
  }

  const handleONShowWinner = async (values: any) => {
    const selectedGame: Game = JSON.parse(values.game)
    let userBets: UserBet[] = []
    
    const jodiUserBet = await getUserbet({ 
      game_id: selectedGame.id,  
      created_at: new Date().toJSON().split("T")[0],
      bid_number: values.game_result_number as string,
      game_type: "JODI"
    });
    const anderUserBet = await getUserbet({ 
      game_id: selectedGame.id,  
      created_at: new Date().toJSON().split("T")[0],
      bid_number: (values.game_result_number as string).slice(0, 1),
      game_type: "ANDER"
    });
    const baherUserBet = await getUserbet({ 
      game_id: selectedGame.id,  
      created_at: new Date().toJSON().split("T")[0],
      bid_number: (values.game_result_number as string).slice(1, 2),
      game_type: "BAHER"
    });

    userBets = [ ...jodiUserBet, ...baherUserBet, ...anderUserBet ];
    handlingWinnerCalculation(userBets)
    setWinningNumber(values.game_result_number)
  };

  function handlingWinnerCalculation(bets: UserBet[]) {
    const winners: Players[] = [];
    let totalWinamount = 0;
    let totalAmonut = 0;
    for (const bet of bets) {
      const game_type: string = bet.game_type ?? "";
      const bidAmount: number = parseInt(bet.amount ?? "0")
      const winnAmount = bidAmount * (game_type === "JODI" ? 95 : 9.5) 
      const creditAmount = winnAmount - bidAmount
      const winner: Players = {
        userId: bet.user_id,
        bidAmount,
        creditAmount
      }
      totalWinamount += winnAmount;
      totalAmonut += bidAmount;
      winners.push(winner)
    }
    setShowWinners(winners)
    setTotalWinningAmount(totalWinamount)
    setTotalBidAmount(totalAmonut)
  }

  async function handleSetGameResult() {
    try { 
      const selectedDate = form.getFieldValue("date");
      const dayJsDateTime: Dayjs = selectedDate as Dayjs
      const dateWithoutTime = `${dayJsDateTime.year()}-${dayJsDateTime.month()}-${dayJsDateTime.day()}`
      const selectedGame: DailyGame[] = await getDailyGame({ 
        game_id: currentGame.current?.id ?? 0 ,
        created_at: dateWithoutTime
      }); 
      if (selectedGame.length === 0) {toast.error("No game found"); return;}
       await makeApiRequeest(
        `${BASE_URL}/api/daily_game/result/${selectedGame[0]?.id}`,
        HttpMethodType.POST,
        { bodyParam: { result: winningNumber } }
      );
      toast.success("Result has been set for this game")
    } catch (error: any) {
      console.error(error);
      toast.error(error.response?.data.message ?? error.message)
    }
  }

  
  return (
    <>
      <section className="flex w-full gap-3 flex-col justify-center lg:flex-row items-start ">
        <div className="sm:w-96 bg-white p-3 pb-0 rounded-md flex flex-col justify-center gap-2 w-full">
          <h2>Submit Result</h2>
          <Divider />

          <Form
            {...layout}
            form={form}
            name="control-hooks"
            onFinish={handleONShowWinner}
            style={{ maxWidth: 800, display: "flex", gap: "1px", flexDirection: "column" }}
          > 
          
            <Form.Item name="date" rules={[{ required: true }]} className="m-0 mb-2">
              <DatePicker onChange={value=> { form.setFieldValue("date", value) }} className="w-full" />
            </Form.Item>

            <Form.Item name="game" rules={[{ required: true }]} className="m-0 mb-2">
              <Select
                placeholder="Select a game"
                onChange={e=>currentGame.current = JSON.parse(e)}
                className="w-full"
                options={
                  games.map((game: Game) => {
                    return { label: game.name, value: JSON.stringify(game) }
                  })
                }
              />
            </Form.Item>

            <Form.Item name="game_result_number" rules={[{ required: true }]} className="m-0 mb-4">
              {/* <InputNumber controls={false} placeholder="Enter game number"  style={{ width: '100%' }} /> */}
              <Input  onChange={e=> {
                e.target.value.length == 1
                  ? form.setFieldValue("game_result_number", `0${e.target.value}`)
                  : e.target.value.length > 1 
                    ? form.setFieldValue("game_result_number", e.target.value.slice(e.target.value.length - 2, e.target.value.length))
                    : null

              }} placeholder="Enter game number" />
            </Form.Item>

            <button
              className="bg-blue-600 hover:bg-blue-700 px-4 py-1 rounded text-white text-sm"
              // onClick={showWinners}
              type="submit"
            >
              Show Winner
            </button>
          </Form>
        </div>

        <div className="bg-white p-3 rounded-md flex flex-wrap gap-6 justify-between flex-1">
          {/* {cardData.map((item) => (
            <SimpleCard
              count={item.count.toString()}
              title={item.name}
              key={item.name}
            >
              {item.icon}
            </SimpleCard>
          ))} */}
        </div>
      </section>

      <section className="bg-white p-3 pt-0 mt-0 sm:mt-8 sm:mb-0 mb-3">
        <div className=" md:gap-8 gap-1 flex flex-col md:flex-row justify-start items-start mb-5 border-none">
          {totalWinningAmount !== undefined && <div className="flex items-end text-sm">
            <span className=" font-semibold ">Total Winning Amount: </span>
            <div className="mx-2">{ totalWinningAmount}</div>
          </div>}
          {winningNumber !== undefined &&
          <div className="flex items-end text-sm">
            <span className=" font-semibold">Winning Number: </span>
            <div className="mx-2">{winningNumber}</div>
          </div>}
          {totalBidAmount !== undefined &&
          <div className="flex items-end text-sm">
            <span className=" font-semibold ">Total Amonut: </span>
            <div className="mx-2">{totalBidAmount}</div>
          </div>
          }
        </div>

        <div className="flex flex-wrap sm:justify-start justify-evenly gap-5 items-center">
          {
            showWinners.map((user, index: number) => {
              return (
                <div
                  key={index}
                  className="flex bg-gray-50 shadow-md flex-col justify-start items-center w-36 py-4 px-1 rounded-lg"
                >
                  <img
                    alt=""
                    className="w-14 rounded-full"
                    src="https://cdn-icons-png.flaticon.com/128/3177/3177440.png"
                  />
                  <div className="flex items-center my-2 text-base font-semibold gap-1">
                    <p className="">User Id: </p>
                    <div>{user.userId}</div>
                  </div>

                  <div
                    className={`${
                      user.bidAmount.toString().length >= 9 ? "mb-2" : "mb-0"
                    } flex flex-wrap justify-center my-1 text-gray-400 text-xs gap-1`}
                  >
                    <div className="  font-bold">Bidding Amt:</div>
                    <span className="font-semibold">{user.bidAmount}</span>
                  </div>

                  <div className="flex flex-wrap justify-center items-center text-gray-400 text-xs gap-1">
                    <div className="  font-bold">Credit Amt:</div>
                    <span className="font-semibold">{user.creditAmount}</span>
                  </div>
                </div>
              );
            })
          }
        </div>

        <Button
          onClick={() => handleSetGameResult()}
          className="my-8 w-full md:w-3 bg-blue-700 px-16"
        >
          Set game result
        </Button>

        {/* <Table>
            <TableHeader>
              <TableRow>
                <TableHead>User Id</TableHead>
                <TableHead>Bid Amount</TableHead>
                <TableHead>Win Number</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {users.map((user) => (
                <TableRow key={user.userId}>
                  <TableCell>{user.userId}</TableCell>
                  <TableCell>{user.bidAmount}</TableCell>
                  <TableCell>{user.creditAmount}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table> */}
      </section>
    </>
  );
}
