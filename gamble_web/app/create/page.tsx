"use client";

import { FieldErrors, useForm } from "react-hook-form";
import { valibotResolver } from "@hookform/resolvers/valibot";
import axios from "axios";
import { useMutation, useQuery } from "@tanstack/react-query";
import { BASE_URL } from "@/lib/const";
import { toast } from "react-toastify";
import { CreateDemoUserForm, CreateDemoUserSchema } from "@/schema/createdemo";

export default function Login() {
  
  const mutation = useMutation({
    mutationFn: async (createuser: CreateDemoUserForm) => {
      return await axios.post(`${BASE_URL}/api/user/create_demo`, {
        email: createuser.email,
        password: createuser.password,
      });
    },
    onError: (error: any, variables, context) => {
      toast.error(error.response.data.message);
    },
    onSuccess: async (data, variables, context) => {
      if (data.data.status) {
        toast.success(data.data.message);
        reset();
      } else {
        toast.error(data.data.message);
      }
    },
  });

  const {
    register,
    handleSubmit,
    watch,
    control,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<CreateDemoUserForm>({
    resolver: valibotResolver(CreateDemoUserSchema),
  });

  const onSubmit = async (data: CreateDemoUserForm) => {
    mutation.mutate(data);
  };

  const onError = (error: FieldErrors<CreateDemoUserForm>) => {
    console.log(error);
  };

  // async function getdata() {
  //   const responsedata = await axios.get(
  //     "http://localhost:5000/api/auth/login"
  //   );
  //   // const users = (await res.json()) as User[];
  //   return responsedata;
  // }
  // const { data } = useQuery({
  //   queryKey: ["create-users"],
  //   queryFn: () => getdata(),
  //   initialData: null,
  //   staleTime: 5 * 1000,
  // });

  return (
    <main className="h-screen bg-[linear-gradient(90deg,#C7C5F4,#776BCC)] flex items-center justify-center overflow-hidden">
      <section className="bg-gray-50 dark:bg-gray-900 w-full">
        <div className="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
          <div className="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
            <div className="p-6 space-y-4 md:space-y-6 sm:p-8">
              <h1 className="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                Create User Account
              </h1>
              <form
                onSubmit={handleSubmit(onSubmit, onError)}
                className="space-y-4 md:space-y-6"
              >
                <div>
                  <label
                    htmlFor="email"
                    className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >
                    Your email
                  </label>
                  <input
                    type="email"
                    id="email"
                    className={`bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500  ${
                      errors.email ? "border-red-500" : "hover:border-blue-500"
                    }`}
                    placeholder="Email address"
                    {...register("email")}
                  />
                  {errors.email && (
                    <p className="text-xs text-red-500">
                      {errors.email.message?.toString()}
                    </p>
                  )}
                </div>
                <div>
                  <label
                    htmlFor="password"
                    className="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                  >
                    Password
                  </label>
                  <input
                    type="password"
                    id="password"
                    {...register("password")}
                    className={`bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500 ${
                      errors.password
                        ? "border-red-500"
                        : "hover:border-blue-500"
                    }`}
                    placeholder="Enter password"
                  />
                  {errors.password && (
                    <p className="text-xs text-red-500">
                      {errors.password.message?.toString()}
                    </p>
                  )}
                </div>

                <button
                  type="submit"
                  className="w-full text-white bg-blue-600 hover:bg-white dark:hover:bg-black hover:border-blue-600 dark:hover:border-white hover:text-blue-600 border-[1px] focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:focus:ring-primary-800"
                >
                  Create Account
                </button>
              </form>
            </div>
          </div>
        </div>
      </section>
    </main>
  );
}
