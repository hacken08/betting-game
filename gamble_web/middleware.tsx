import { NextResponse, NextRequest } from "next/server";
import { isTokenExpired } from "./lib/api/untils";
import { toast } from "react-toastify";

// This function can be marked `async` if using `await` inside
export function middleware(request: NextRequest) {
  const session = request.cookies.get("session");
  const refreshToken = request.cookies.get("x-r-t");

  if (refreshToken === undefined) {
    return;
  }

  if (
    session && !isTokenExpired(refreshToken.value) &&
    (request.nextUrl.pathname.startsWith("/login") ||
      request.nextUrl.pathname.startsWith("/register"))
  ) {
    return NextResponse.redirect(new URL("/dashboard/home", request.url));
  } else if ((!session || isTokenExpired(refreshToken.value)) && request.nextUrl.pathname.startsWith("/dashboard")) {
    return NextResponse.redirect(new URL("/login", request.url));
  }
}

export const config = {
  //   matcher: '/about/:path*',
};
