"use client";
import { Controller, FieldValues, Path, useFormContext } from "react-hook-form";
import { TimePicker } from "antd";
import dayjs, { Dayjs } from "dayjs";

type TimeSelectProps<T extends FieldValues> = {
  name: Path<T>;
  placeholder: string;
  required: boolean;
  disable?: boolean;
  format?: string;
};

export function TimeSelect<T extends FieldValues>(props: TimeSelectProps<T>) {
  const {
    control,
    formState: { errors },
  } = useFormContext();

  // Get the error for this specific field
  const error = errors[props.name as keyof typeof errors];

  return (
    <Controller
      control={control}
      name={props.name}
      render={({ field }) => (
        <>
          <TimePicker
            required={props.required}
            disabled={props.disable ?? false}
            needConfirm={false}
            className="w-full"
            value={field.value ? dayjs(field.value) : null} // Ensure it can handle the value correctly
            status={error ? "error" : undefined}
            onChange={(value: dayjs.Dayjs | null) => {
              field.onChange(value ? value.format() : null); // Using `format()` to return a time string
            }}
            placeholder={props.placeholder}
            // Define the time format you need (e.g., "HH:mm" for hours and minutes)
            format={props.format || "HH:mm"}
          />
          {error && (
            <p className="text-xs text-red-500">{error.message?.toString()}</p>
          )}
        </>
      )}
    />
  );
}
