"use client";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect } from "react";

export default function Home() {
  const router = useRouter();
  useEffect(() => {
    router.push("/login");
  }, [router]);

  return (
    <main className="min-h-screen bg-white">
      <h1>Working :)</h1>
      <div className="flex flex-col">
        <Link href="/login" className="text-indigo-700">
          To login
        </Link>
        <Link href="/register" className="text-indigo-700">
          To register
        </Link>
        <Link href="/dashboard/home" className="text-indigo-700">
          To dashboard
        </Link>
      </div>
      <div>
        {/* for fix size */}
        <Image
          src={"/images/progress.png"}
          width={200}
          height={400}
          alt="logo"
        ></Image>
      </div>
      <div className="h-20 w-40 relative">
        <Image src={"/images/progress.png"} fill={true} alt="logo" />
      </div>
    </main>
  );
}
