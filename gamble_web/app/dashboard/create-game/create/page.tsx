"use client";


import { Button } from "@/components/ui/button";
import { FormProvider, SubmitHandler, useForm } from "react-hook-form";
import { TextInput } from "@/components/forms/inputfileds/textinput";
import { NumberInput } from "@/components/forms/inputfileds/numberinput";
import { TimeSelect } from "@/components/forms/inputfileds/timeselect";
import { CreateGameForm, CreateGameSchema } from "@/schema/createGameSchema";
import { valibotResolver } from "@hookform/resolvers/valibot";
import { onFormError } from "@/lib/utils";
import axios from "axios";
import { useMutation } from "@tanstack/react-query";
import { toast } from "react-toastify";
import { BASE_URL } from "@/lib/const";

const Page = () => {
  const methods = useForm<CreateGameForm>({
    resolver: valibotResolver(CreateGameSchema),
    defaultValues: {
      createdBy: 1, // TODO: Pass the value
    },
  });
  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = methods;

  // Define the mutation function that posts data to an API
  const postGameData = async (data: CreateGameForm): Promise<any> => {
    const dataToPost = {
      start_time: new Date(data.startTime),
      end_time: new Date(data.endTime),
      name: data.name,
      max_price: `${data.maxPrice}.00`,
      max_number: data.maxNumber,
      created_by: Number(data.createdBy),
    };

    // Add 1 day to start_time
    dataToPost.start_time.setDate(dataToPost.start_time.getDate() + 1);

    // Add 1 day to end_time
    dataToPost.end_time.setDate(dataToPost.end_time.getDate() + 1);

    const response = await axios.post(
      `${BASE_URL}/api/game`,
      dataToPost
    );
    return response.data;
  };

  // Set up React Query's useMutation hook
  const { mutate, isError, isSuccess, error, data } = useMutation<
    any,
    Error,
    CreateGameForm
  >({
    mutationFn: postGameData,
    onSuccess: () => {
      toast.success("Game created successfully");
    },
    onError: (error: any) => {
      toast.error("Error creating game:", error);
    },
  });

  const onSubmit: SubmitHandler<CreateGameForm> = (data) => {
    if (new Date(data.startTime) > new Date(data.endTime)) {
      return toast.error("Invalid Start and End time");
    }

    try {
      mutate(data);
      toast.success("successfully created game, redirecting...");
      // setTimeout(() => {
      //   window.location.replace("/dashboard/create-game");
      // }, 3000);
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <div>
      <FormProvider {...methods}>
        <form
          onSubmit={handleSubmit(onSubmit, onFormError)}
          className="flex flex-col items-center gap-4"
        >
          <TimeSelect<CreateGameForm>
            required
            name="startTime"
            placeholder="Select Start Time"
          />

          <TimeSelect<CreateGameForm>
            required
            name="endTime"
            placeholder="Select Start Time"
          />

          <TextInput<CreateGameForm>
            name="name"
            placeholder="Enter Game Name"
            required
          />

          <NumberInput<CreateGameForm>
            name="maxNumber"
            placeholder="Max number of game user can enter"
            required
          />
          <NumberInput<CreateGameForm>
            name="maxPrice"
            placeholder="Max price user can bet on a single entry"
            required
          />

          {/* TODO: add user id */}
          <NumberInput<CreateGameForm>
            name="createdBy"
            defaultValue={1}
            hidden={true}
          />

          <Button type="submit" className="w-full">
            Submit
          </Button>
        </form>
      </FormProvider>
    </div>
  );
};

export default Page;
