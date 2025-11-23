"use client";

import SearchFiedls from "@/components/Dashboard/SearchFiedls";
import PlaceBidReciept from "@/components/DialogeBoxes/placeBidRecieptDialog";
import ProcessingRecpiet from "@/components/DialogeBoxes/ProcessingRecpiet";
import RecieptDialoge from "@/components/DialogeBoxes/RecieptDialogBox";
import { Button } from "@/components/ui/button";
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { decryptURLData, HttpMethodType, makeApiRequeest } from "@/lib/api/untils";
import { BASE_URL } from "@/lib/const";
import { dateTimeFormatter } from "@/lib/utilsMethod";
import { StatementScheme, UserPlayStatment } from "@/models/StatementModel";
import { BidNumberType } from "@/models/UserBetModels";
import { useQuery } from "@tanstack/react-query";
import { ColumnDef } from "@tanstack/react-table";
import { Input, Modal, Pagination } from "antd";
import { AxiosError } from "axios";
import { useParams, useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import { toast } from "react-toastify";

export default function Users() {
    const router = useRouter();

    const { id } = useParams<{ id: string | string[] }>();
    const idString = Array.isArray(id) ? id[0] : id;
    const playerUserId: number = parseInt(decryptURLData(idString, router));

    // const [open, setOpen] = useState(false);
    const [passwordBox, setPasswordBox] = useState(false);
    const [amountBox, setAmountBox] = useState(false);

    const [Statement, setStatement] = useState<StatementScheme[]>([])
    const [userBetStatment, setUserBetStatment] = useState<UserPlayStatment[]>([])
    const [searchId, setSearchId] = useState<string>();



    function dataRefactoring(statements: StatementScheme[]) {
        let playStatements: UserPlayStatment[] = [];
        let otherStatements: StatementScheme[] = [];

        for (const statement of statements) {
            if (statement.user == undefined) break;

            if (statement.statement_type === "PLAY") {
                if (statement.user_bet == undefined) break;
                if (statement.game == undefined) break;
                const existingPlay = playStatements.find(playStatment =>
                    playStatment.gameId === statement.daily_game_id &&
                    playStatment.dateTime.toDateString() === new Date(statement.user_bet?.created_at ?? "").toDateString()
                );
                if (!existingPlay) {
                    playStatements.push({
                        gameName: statement.game.name ?? "",
                        id: statement.id,
                        gameId: statement.daily_game_id ?? 0,
                        dateTime: new Date(statement.user_bet.created_at),
                        totalAmount: parseFloat(statement.user_bet.amount ?? "0.0"),
                        closingBalance: statement.user.wallet,
                        biddingNumbers: [{
                            bidNumber: parseInt(statement.user_bet.bid_number ?? "0"),
                            amount: statement.user_bet.amount ?? "0.0",
                            numberType: statement.user_bet.game_type as BidNumberType,
                        }],
                    });
                    setUserBetStatment(playStatements)
                    continue;
                }
                const indexToremove = playStatements.indexOf(existingPlay);
                playStatements = playStatements.filter((e, i) => i !== indexToremove);
                existingPlay.totalAmount += parseFloat(statement.user_bet.amount ?? "0.0")
                existingPlay.closingBalance = statement.user.wallet
                existingPlay.dateTime = new Date(statement.user_bet.created_at)
                existingPlay.biddingNumbers.push({
                    bidNumber: parseInt(statement.user_bet.bid_number ?? "0"),
                    amount: statement.user_bet.amount ?? "0.0",
                    numberType: statement.user_bet.game_type as BidNumberType,
                })
                playStatements.splice(indexToremove, 0, existingPlay)
                setUserBetStatment(playStatements)
                continue;
            }
            otherStatements.push(statement);
        }
        setStatement(otherStatements);
    }

    async function init() {
        try {
            const response = await makeApiRequeest(
                `${BASE_URL}/api/statement`,
                HttpMethodType.GET,
                { queryParam: { userId: playerUserId, skip: 0, take: 100 } }
            );
            console.log(response);
            dataRefactoring(response?.data.data ? response.data.data : response?.data)
            return response?.data.data ? response.data.data : response?.data;
        } catch (error) {
            const axioError = error as AxiosError
            toast.error(axioError.message)
            console.error(error);
        }
    }

    const { isPending, error, data } = useQuery({
        queryKey: ["getAllCreatedGames"],
        queryFn: async () => init(),
        staleTime: 0,
    });


    async function getStatementByDate(searchDate: Date) {
        const formatedDate = `${searchDate.getFullYear()}-${searchDate.getMonth() + 1}-${searchDate.getDate()}`
        console.log(formatedDate);
        setStatement([])
        setUserBetStatment([])
        const response = await makeApiRequeest(
            `${BASE_URL}/api/statement`,
            HttpMethodType.GET,
            { queryParam: { created_at: formatedDate, skip: 0, take: 100 } }
        );
        dataRefactoring(response?.data.data ? response.data.data : response?.data)
        return response?.data.data ? response.data.data : response?.data;
    }

    async function handleStatementSearch() {
        if (!searchId || isNaN(Number(searchId)) || Number(searchId) === 0) {
            console.error("Invalid search ID: must be a non-zero number");
            return;
        }
        setStatement([])
        setUserBetStatment([])
        try {
            const response = await makeApiRequeest(
                `${BASE_URL}/api/statement`,
                HttpMethodType.GET,
                { queryParam: { id: Number(searchId), skip: 0, take: 100 } }
            );
            console.log(response);

            dataRefactoring(response?.data.data ? response.data.data : response?.data)
            return response?.data.data ? response.data.data : response?.data;
        } catch (error) {
            const axioError = error as AxiosError
            toast.error(axioError.message)
            console.error(error);
        }
    }

    return (
        <main>
            <div className="shadow bg-white p-4 w-full h-full rounded-md mt-2">

                <div className="w-full flex items-end mb-9 justify-between">
                    <div className="w-[30%] flex gap-2 flex-col">
                        <h1 className=" font-bold text-lg ">Transication History (transactionId)</h1>
                        <span className="font-semibold">User Id: 23 </span>
                        <span className="font-semibold">Available balance: 23,000 </span>
                        <Input onClear={() => { init() }} onChange={(date) => { getStatementByDate(new Date(date.currentTarget.value)) }} type="date" className="" />
                        <Button onClick={() => { }} className='bg-blue-600 hover:bg-blue-700'>Submit</Button>
                    </div>
                    <SearchFiedls
                        onChange={(event) => setSearchId(event.target.value)}
                        value={searchId}
                        onSearch={() => handleStatementSearch()}
                        placeholder="Search" />
                </div>

                <Table className="mb-5">
                    <TableHeader>
                        <TableRow className="bg-zinc-100">
                            {/* <TableHead className="text-center">No</TableHead> */}
                            <TableHead className="text-center">{"Id"}</TableHead>
                            <TableHead className="text-center">{"Statement /Status"}</TableHead>
                            <TableHead className="text-center">Amount</TableHead>
                            {/* <TableHead className="text-center">Status</TableHead> */}
                            <TableHead className="text-center">Txn id</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody className="">

                        {
                            userBetStatment.map((statmen: UserPlayStatment, index: number) => {
                                return <TableRow key={index} className="">
                                    {/* <TableCell className="text-center min-w-15">{ index + 1}</TableCell> */}
                                    <TableCell className="text-center min-w-15">{statmen.id}</TableCell>
                                    <TableCell className="text-center ">
                                        <div className="font-semibold text-green-600">{statmen.gameName ?? ""} Play</div>
                                        <div> {dateTimeFormatter(statmen.dateTime)}</div>
                                    </TableCell>
                                    <TableCell className="text-center  min-w-28">
                                        <div className="text-green-600 font-semibold">₹ {statmen.totalAmount}</div>
                                        <PlaceBidReciept userBetStatement={statmen} />
                                        <div><span className="font-semibold">Closing Bal</span>: ₹ {statmen.closingBalance}</div>
                                    </TableCell>
                                    <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
                                </TableRow>
                            })
                        }
                        {
                            Statement.map((statmen: StatementScheme, index: number) => {
                                if (statmen.statement_type == "GAME") {
                                    if (statmen.game_result == undefined) return;
                                    return <TableRow key={index} className="">
                                        {/* <TableCell className="text-center min-w-15">{index + 1}</TableCell> */}
                                        <TableCell className="text-center min-w-15">{statmen.id}</TableCell>
                                        <TableCell className="text-center ">
                                            <div className="font-semibold text-black-500 ">{statmen.game?.name} Result</div>
                                            <div>{dateTimeFormatter(new Date(statmen.game_result.created_at))}</div>
                                        </TableCell>
                                        <TableCell className="text-center  min-w-28">
                                            <div className="text-black-500 font-semibold">* ₹ {statmen.game_result.amount}</div>
                                            <RecieptDialoge statement={statmen} />
                                            <div><span className="font-semibold">Closing Bal</span>: ₹ {statmen.user?.wallet}</div>
                                        </TableCell>
                                        <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
                                    </TableRow>
                                }
                            })
                        }
                        {
                            Statement.map((statmen: StatementScheme, index: number) => {
                                if (statmen.statement_type == "WITHDRAW") {
                                    if (statmen.withdraw_request == undefined) return;
                                    return <TableRow key={index} className="">
                                        <TableCell className="text-center min-w-15">{5}</TableCell>
                                        <TableCell className="text-center ">
                                            <div className="font-semibold text-yellow-500 ">Withdraw money processing</div>
                                            <div>{dateTimeFormatter(statmen.withdraw_request?.created_at)}</div>
                                        </TableCell>
                                        <TableCell className="text-center  min-w-28">
                                            <div className="text-yellow-500 font-semibold">* ₹ {statmen.withdraw_request.amount}</div>
                                            <ProcessingRecpiet Withdrawl={true} />
                                            <div><span className="font-semibold">Closing Bal</span>: ₹ {statmen.user?.wallet}</div>
                                        </TableCell>
                                        <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
                                    </TableRow>
                                }
                            })
                        }


                        {/*  <TableRow className="">
              <TableCell className="text-center min-w-15">{3}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-green-600">Add money successful</div>
                <div> 03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-green-600 font-semibold">+ ₹ 500.00</div>
                <AddMoneyRecpiet />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{4}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-yellow-600">Add money processing</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-yellow-600 font-semibold">* ₹ 500.00</div>
                <ProcessingRecpiet />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{5}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-red-600 ">Add money rejected</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-red-600 font-semibold">₹ 500.00</div>
                <RejectMoneyrecpiet />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{5}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-purple-500 ">Referral Amount</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-purple-500 font-semibold">₹ 500.00</div>
                <RefferalRacpiet />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{5}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-red-500 ">Money deducted</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-red-500 font-semibold">₹ 500.00</div>
                <MoneyDeductedRepeit />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{5}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-yellow-500 ">Withdraw money processing</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-yellow-500 font-semibold">* ₹ 500.00</div>
                <ProcessingRecpiet Withdrawl={true} />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{5}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-green-500 ">Withdraw money successfull</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-green-500 font-semibold">- ₹ 500.00</div>
                <WithrawalMoneyRecpiet />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{5}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-red-500 ">Withdraw money rejected</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-red-500 font-semibold"> ₹ 500.00</div>
                <WithrawalRejectMoneyrecpiet Withdrawl={true} />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow>


            <TableRow className="">
              <TableCell className="text-center min-w-15">{5}</TableCell>
              <TableCell className="text-center ">
                <div className="font-semibold text-purple-500 ">Withdraw money refunded</div>
                <div>03 sept 2024, 11:22AM</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">
                <div className="text-purple-500 font-semibold">+ ₹ 500.00</div>
                <WithrawalReffundedMoneyrecpiet Withdrawl={true} />
                <div><span className="font-semibold">Closing Bal</span>: ₹ 2,000</div>
              </TableCell>
              <TableCell className="text-center  min-w-28">{"12345678901234"}</TableCell>
            </TableRow> */}


                    </TableBody>
                </Table>

                <div className="mt-2">
                    <Pagination
                        total={85}
                        showSizeChanger
                        showQuickJumper
                        showTotal={(total: any) => `${total} items`}
                    />
                </div>
            </div>
            <Modal
                title="Change Password"
                open={passwordBox}
                onOk={() => setPasswordBox(false)}
                onCancel={() => setPasswordBox(false)}
            >
                <Input placeholder="Enter New Password" />
            </Modal>
            <Modal
                title="Cash Deduction"
                open={amountBox}
                onOk={() => setAmountBox(false)}
                onCancel={() => setAmountBox(false)}
            >
                <Input className="Enter Amount" />
            </Modal>
        </main>
    );
}

// const columns: ColumnDef<Transaction>[] = [
//   {
//     accessorKey: "number",
//     header: "No.",
//   },
//   {
//     accessorKey: "status",
//     header: "Status",
//   },
//   {
//     accessorKey: "amount",
//     header: "Amount",
//     cell: ({ row }) => {
//       const amount = parseFloat(row.getValue("amount"));
//       return (
//         <div className="flex flex-col gap-1">
//           <p>{amount}</p>
//           <p>
//             <HoverCard>
//               <HoverCardTrigger className="text-blue-700 cursor-pointer">
//                 View Details
//               </HoverCardTrigger>
//               <HoverCardContent>
//                 <p>Game: Moday dhamaka</p>
//                 <p>Bet number: 2, 34</p>
//                 <p>Winning Number: 99</p>
//                 <p>Bet amount: 2334</p>
//               </HoverCardContent>
//             </HoverCard>
//           </p>
//           <p><span className="font-semibold">closing bal</span>ance: {Math.ceil(amount * 2 - 5 / 3)}</p>
//         </div>
//       );
//     },
//   },
//   {
//     accessorKey: "transactionId",
//     header: "Transaction Id",
//   },
// ];

// type Transaction = {
//   number: number;
//   status:
//   | "Add money successful"
//   | "withdraw successul"
//   | "withdraw processing"
//   | "withdraw failed";
//   amount: number;
//   transactionId: string;
// };
