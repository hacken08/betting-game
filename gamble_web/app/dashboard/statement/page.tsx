import React from 'react'

const StatementPage = () => {
    return (
        <div className="flex flex-col items-center w-full h-full bg-white rounded-md">
            <h1 className="m-auto font-bold text-2xl my-3">My Actions</h1>

            {/* ........ Deduct money card ......... */}
            <div className="flex justify-start items-center w-full gap-1">
                <div className="min-h-4 w-[250px] shadow-md bg-zinc-100 gap-2 py-1 px-3 items-center flex-col rounded-md">
                    <div className="flex w-full items-center justify-between">
                        <h1 className="font-semibold text-md my-3">Deduct money</h1>
                        <span> ₹ 300</span>
                    </div>
                    <div className='flex w-full justify-between'>
                        <span>D:7/23/2024 T:23:45</span>
                        <span>(231)</span>
                    </div>
                </div>
            </div>


            {/* ........ Block user id card ......... */}
            <div className="flex justify-start items-center w-full gap-1 mt-8">

                <div className="min-h-4 shadow-md bg-zinc-100 gap-2 py-1 px-3 items-center flex-col rounded-md">
                    <div className="flex w-full items-center gap-8 justify-between">
                        <h1 className="font-semibold text-md my-3">Blocked ID</h1>
                        <span> remaining amt: ₹ 300</span>
                    </div>

                    <div className='flex w-full justify-between'>
                        <span>D:7/23/2024 T:23:45</span>
                        <span>(231)</span>
                    </div>
                </div>


            </div>

        </div>
    )
}

export default StatementPage
