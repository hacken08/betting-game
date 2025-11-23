import { Input } from 'antd'
import React from 'react'

const SumbitSecurityPage = () => {
  return (
    <div className='flex flex-col justify-start items-center w-full h-full overflow-scroll' style={{ scrollbarWidth: "none" }}>
      <h1 className="m-auto font-bold text-2xl my-3">Credit Amount</h1>

      <h2 className="px-5 font-semibold hidden sm:flex w-full justify-start  text-lg my-3 mt-7">Summary</h2>

      <div className="sm:gap-8 gap-1: flex flex-col sm:flex-row w-full justify-start px-5 sm:item-start mt-2 border-none">
        <div className="flex items-end">
          <span className=" font-semibold" >Winning Number: </span>
          <div className="mx-2">55</div>
        </div>
        <div className="flex items-end">
          <span className=" font-semibold " >Total Amonut: </span>
          <div className="mx-2">234,23</div>
        </div>
        <div className="flex items-end">
          <span className=" font-semibold " >Total Winning Amount: </span>
          <div className="mx-2">234,123,5</div>
        </div>
      </div>

      <div className="w-[250px] sm:w-[350px] flex flex-col gap-2 mt-10 items-start sm:items-center">
        <Input className="" placeholder="Enter security key"></Input>
        <button className="px-5 bg-green-500 py-1 rounded-md  text-white font-normal">Sumbit</button>
      </div>

    </div>
  )
}

export default SumbitSecurityPage
