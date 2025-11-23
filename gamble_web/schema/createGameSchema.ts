import { isContainSpace } from "@/lib/utils";
import {
  check,
  InferInput,
  minLength,
  object,
  string,
  pipe,
  regex,
  email,
  maxLength,
  enum_,
  number,
  length,
  minValue,
  nullish,
} from "valibot";

const CreateGameSchema = object({
  name: string(),
  createdBy: number(),
  maxNumber: nullish(number()),
  maxPrice: nullish(number()),
  startTime: string(),
  endTime: string(),
});

type CreateGameForm = InferInput<typeof CreateGameSchema>;

export { CreateGameSchema, type CreateGameForm };
