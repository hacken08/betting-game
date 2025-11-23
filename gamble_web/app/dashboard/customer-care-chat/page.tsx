"use client";
import { FluentSend16Regular } from "@/components/Icon";
import { formateDate } from "@/lib/utils";
import { Avatar, Divider, Input } from "antd";
import { useState } from "react";

export default function CustomerCareChat() {
  const [selectedUser, setUser] = useState(1);
  return (
    <main className="relative">
      <div className="w-full p-3 rounded-md bg-white">
        <h1>Customers</h1>
        <Divider className="my-1" />
        <div className="flex overflow-x-scroll">
          {users.map((user) => (
            <Avatar
              key={user.id}
              alt={user.name}
              src={user.avatar}
              size="large"
              onClick={() => setUser(user.id)}
              className="cursor-pointer shrink-0"
            ></Avatar>
          ))}
        </div>
      </div>
      <div className="w-full p-3 mt-2 rounded-t-md bg-white">
        <div className="flex gap-2 items-center">
          <h1>Mohan Shahu</h1>
          <div className="grow"></div>
          <p className="text-gray-600 text-xs">Last Message: 12/04/2014</p>
        </div>
        <Divider className="my-1" />
      </div>
      <div className="w-full p-3 rounded-b-md bg-white overflow-y-scroll h-[calc(54vh)]">
        <div className="flex flex-col w-full gap-3">
          {users[selectedUser - 1].message.map((msg) => {
            return (
              <div key={msg.id}>
                {msg.type == "sent" ? (
                  <div className="flex justify-end">
                    <div className="bg-blue-500 m-2 rounded-md text-end p-2 w-fit max-w-96">
                      <p className="text-white">{msg.text}</p>
                      <p className="text-xs text-gray-100">
                        {formateDate(msg.date)}
                      </p>
                    </div>
                  </div>
                ) : (
                  <div className="bg-gray-100 m-2 rounded-md text-end p-2 w-fit max-w-96">
                    <p>{msg.text}</p>
                    <p className="text-xs text-gray-600">
                      {formateDate(msg.date)}
                    </p>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
      <div className="w-full p-2 rounded-md shadow flex gap-2 items-center bg-white mt-2">
        <Input placeholder="Type your message here..." />
        <div className="bg-blue-500 rounded-md py-1 px-4 h-8 items-center flex gap-2">
          <FluentSend16Regular className="text-white text-lg" />
          <p className="text-sm text-white">Send</p>
        </div>
      </div>
    </main>
  );
}

type Message = {
  text: string;
  type: "received" | "sent";
  date: Date;
  id: number;
};

type User = {
  id: number;
  name: string;
  avatar: string;
  message: Message[];
};

const users: User[] = [
  {
    id: 1,
    name: "Priya",
    avatar:
      "https://s.cafebazaar.ir/images/icons/com.StylishDpGirls.DPGirlsHDWallpaperDpzGirlsPhotos-9db48fd3-e251-44b7-820e-902054dc06e4_512x512.png",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hello Priya, How are you?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "I am in Heavem",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "what about you?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "Have you eatan?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "I am fine too",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Making dinner",
        type: "received",
      },
    ],
  },
  {
    id: 2,
    name: "John Doe",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRa82aSRpxrWeZnUqDmGaW56l-l03mg1KUcag&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey there, how's it going?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "I'm doing great, thanks for asking!",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "That's good to hear. Any plans for the weekend?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "Yeah, I'm planning to go hiking with some friends.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "That sounds fun! Let me know how it goes.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Will do, talk to you later!",
        type: "sent",
      },
    ],
  },
  {
    id: 3,
    name: "John Doe",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRa82aSRpxrWeZnUqDmGaW56l-l03mg1KUcag&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey there, how's it going?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "I'm doing great, thanks for asking!",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "That's good to hear. Any plans for the weekend?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "Yeah, I'm planning to go hiking with some friends.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "That sounds fun! Let me know how it goes.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Will do, talk to you later!",
        type: "sent",
      },
    ],
  },
  {
    id: 4,
    name: "Michael Johnson",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-X75_53Q2rUMBcl-KzMQjCgL-WtAZQ3-KiQ&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey, did you catch the game last night?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "Yeah, it was a close one! Can't believe they pulled it off in the end.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "I know, it was a nail-biter for sure. Did you see that last-minute shot?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "Absolutely, it was insane! I'm still buzzing from it.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "Same here, that was one for the history books.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Definitely, can't wait for the next one.",
        type: "sent",
      },
    ],
  },
  {
    id: 5,
    name: "Emily Davis",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFron-PlVR5D4-onXL362imcBkbN4mWbmgSg&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey, how's it going?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "I'm doing well, thanks for asking. How about you?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "I'm good, just been a bit stressed with work lately.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "I'm sorry to hear that. Is there anything I can do to help?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "That's so sweet of you, but I think I just need to take a break this weekend.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Sounds like a good plan. Enjoy your time off!",
        type: "sent",
      },
    ],
  },
  {
    id: 6,
    name: "David Lee",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWPo2eBFjj0-N1tQq7cQXGJb62vpRzJHhF_g&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey, did you see that new movie everyone's been talking about?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "No, I haven't had a chance to see it yet. Is it any good?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "It was pretty good, I thought. The acting was great, and the plot was really engaging.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "That's good to hear. I'll have to check it out this weekend.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "Definitely, let me know what you think of it.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Will do, thanks for the recommendation!",
        type: "sent",
      },
    ],
  },
  {
    id: 7,
    name: "Sarah Wilson",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf9zjA_jq9Axf4wPX6y3XFLpnMV4Plftw6fA&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey, are you free for lunch today?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "Unfortunately, I have a meeting during lunch. How about tomorrow?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "Tomorrow works for me. Where do you want to go?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "How about that new cafe downtown? I heard they have great sandwiches.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "Sounds good, I'm looking forward to it!",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Me too, see you then!",
        type: "sent",
      },
    ],
  },
  {
    id: 8,
    name: "Tom Anderson",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBZj7ep2ynJlyGOhxL2cjkefIvzuZWBM3obw&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey, did you catch the news this morning?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "No, I haven't had a chance to yet. What's going on?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "Apparently, there was a big announcement from the company. Looks like they're expanding to a new location.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "Wow, that's exciting! I wonder how that will affect our team.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "I'm not sure, but I'm sure we'll hear more about it in the coming days.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Definitely, I'll keep an eye out for any updates.",
        type: "sent",
      },
    ],
  },
  {
    id: 9,
    name: "Jessica Brown",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4gH0nSKW5Cx7ShH15HiGkGMUSsVJxpopRKg&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "Hey, did you see that new restaurant that just opened up?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "No, I haven't had a chance to check it out yet. What's it like?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "It's really nice! The decor is beautiful, and the food is amazing. We should go check it out sometime.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "That sounds great, I'd love to try it. When are you free?",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "How about this weekend? I'm free on Saturday evening.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Perfect, let's plan on it. I'm looking forward to it!",
        type: "sent",
      },
    ],
  },
  {
    id: 10,
    name: "Robert Thompson",
    avatar:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSV6_DYph9vADuzk2lw_JS3mdeEC3G7Z9IueA&s",
    message: [
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 1,
        text: "Hey, did you catch the game last night?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 2,
        text: "Yeah, it was a tough one. Can't believe they pulled it off in the end.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 3,
        text: "I know, it was a nail-biter for sure. Did you see that last-minute shot?",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 4,
        text: "Absolutely, it was insane! I'm still buzzing from it.",
        type: "sent",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 5,
        text: "Same here, that was one for the history books.",
        type: "received",
      },
      {
        date: new Date("October 13, 2014 11:13:00"),
        id: 6,
        text: "Definitely, can't wait for the next one.",
        type: "sent",
      },
    ],
  },
];
