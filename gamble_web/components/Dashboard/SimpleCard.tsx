import { ReactNode } from "react";

type CardProps = {
  title: string;
  count: string;
  children: ReactNode;
};

export default function SimpleCard({ title, count, children }: CardProps) {
  return (
    <div className="flex flex-col justify-center items-center p-4 ">
      {children}
      <h1 className="text-xs">{title}</h1>
      <span className="text-black text-xl">{count}</span>
    </div>
  );
}
