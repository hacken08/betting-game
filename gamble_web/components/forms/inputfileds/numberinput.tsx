import { Input, InputNumber } from "antd";
import { Controller, FieldValues, Path, useFormContext } from "react-hook-form";

type NumberInputProps<T extends FieldValues> = {
  name: Path<T>;
  placeholder?: string;
  required?: boolean;
  onlynumber?: boolean;
  numdes?: boolean;
  disable?: boolean;
  maxlength?: number;
  defaultValue?: number;
  hidden?: boolean;
};

export function NumberInput<T extends FieldValues>(props: NumberInputProps<T>) {
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
          <InputNumber
            defaultValue={props.defaultValue ?? undefined}
            hidden={props.hidden ?? false}
            required={props.required}
            maxLength={props.maxlength ?? undefined}
            status={error ? "error" : undefined}
            className="w-full"
            value={field.value}
            disabled={props.disable ?? false}
            onChange={(e) => {
              if (!e) return;

              field.onChange(e);
            }}
            placeholder={props.placeholder ?? undefined}
          />
          {error && (
            <p className="text-xs text-red-500">{error.message?.toString()}</p>
          )}
        </>
      )}
    />
  );
}
