
export function dateTimeFormatter(date: Date): string {
  const formattedDate = new Intl.DateTimeFormat("en-US", {
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    hour12: true,
    timeZone: "Asia/Kolkata", // Converts to IST
  }).format(addTime(date, 5, 30));

  return formattedDate;
}

function addTime(date: Date, hours: number, minutes: number): Date {
  const newDate = new Date(date); // Create a copy to avoid mutating the original
  newDate.setHours(newDate.getHours() + hours);
  newDate.setMinutes(newDate.getMinutes() + minutes);
  return newDate;
}


function addTimeToDate(date: Date, milliseconds: number): Date {
  const newDate = new Date(date.getTime() + milliseconds);
  return newDate;
}

/**
 * Converts a given string to capital case by capitalizing the first letter of each word.
 * @param {string} value - The input string to convert to capital case.
 * @returns {string} The input string converted to capital case.
 */
const capitalcase = (value: string): string => {
  const words = value.split(" ");

  const capitalWords = words.map((str) => {
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
  });

  return capitalWords.join(" ");
};

export { capitalcase };

