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
  file,
  mimeType,
  maxSize,
  nullish,
  optional
} from "valibot";
// Assuming this is your Role enum definition
export enum Role {
  SYSTEM = "SYSTEM",
  ADMIN = "ADMIN",
  WORKER = "WORKER",
  USER = "USER",
}


export const demoPaymentGatewaySchema = object({
  name: string(),
  payment_type: string(),
  status: string(),
  // file: nullish(file()) ,

})

const CreateUserSchema = object({
  name: pipe(
    string(),
    minLength(1, "Please enter your name."),
    // check(isContainSpace, "Name cannot contain space.")
  ),
  email: pipe(
    string(),
    email("Enter a valid email address"),
    check(isContainSpace, "Mobile number cannot contain space.")
  ),
  number: pipe(
    string(),
    minLength(1, "Please enter your mobile number."),
    maxLength(10, "Mobile number must be 10 digits."),
    check(isContainSpace, "Mobile number cannot contain space.")
  ),

  role: enum_(Role, "Role is required."),
  // role: string(),

  password: pipe(
    string(),
    minLength(1, "Please enter your password."),
    minLength(8, "Your password must have 8 characters or more."),
    regex(/^(?=.*[0-9]).*$/, "Your password must have at least one number."),
    regex(
      /^(?=.*[!@#$%^&*]).*$/,
      "Your password must have at least one special character."
    ),
    regex(/^(?=.*[A-Z]).*$/, "Your password must have at least one uppercase."),
    regex(/^(?=.*[a-z]).*$/, "Your password must have at least one lowercase."),
    check(isContainSpace, "Password cannot contain space.")
  ),
});

type CreateUserForm = InferInput<typeof CreateUserSchema>;
type CreateDemoPayment = InferInput<typeof demoPaymentGatewaySchema>;

export { CreateUserSchema, type CreateUserForm, type CreateDemoPayment };
