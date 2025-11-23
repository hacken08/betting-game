import React, { ChangeEvent, useState } from 'react'
import { Button } from '../ui/button'
import Input from 'antd/es/input'
import { value } from 'valibot'

interface ProbsType {
    className?: string,
    onChange?: (event: ChangeEvent<HTMLInputElement>) => void
    onSearch?: (searchQuery?: string) => void,
    placeholder?: string,
    value?: string
}

const SearchFiedls = (probs: ProbsType) => {
    const [searchQuery, setSearchQuery] = useState(probs.value);
    
    return (
        <div className="flex h-10 w-full mb-1 max-w-sm items-center">
            <Input
                className={`h-full  rounded-none rounded-l-md placeholder:font-semibold ${probs.className}`}
                type="text"
                onChange={e => {
                    probs.onChange ? probs.onChange(e) : undefined;
                    setSearchQuery(e.target.value);
                }}
                value={searchQuery}
                placeholder={probs.placeholder}
            />
            <Button
                onClick={(e) => probs.onSearch ? probs.onSearch(searchQuery) : undefined}
                className="h-full bg-blue-500  rounded-none rounded-r-md w-40"
                type="submit" >
                Search
            </Button>
        </div>
    )
}

export default SearchFiedls
