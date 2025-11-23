import 'package:intl/intl.dart';

bool validateEmail(String value) {
  return RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  ).hasMatch(value);
}

String longtext(String text, int long) {
  if (text.length <= long) {
    return text;
  } else {
    return '${text.substring(0, long)} ...';
  }
}

bool isInteger(dynamic value) {
  // try {
  //   return (value % 1) == 0;
  // } catch (Error) {
  //   return false;
  // }
  // return value is int || (value is double && value.truncate() == value);
  return true;
}

String? validatePassword(String? value) {
  if (value == "" || value == null || value.isEmpty) {
    return "Please fill the password";
  }

  if (!value.contains(RegExp(r'[A-Z]'))) {
    return "Password must contain at least 1 uppercase letter";
  }

  if (!value.contains(RegExp(r'[a-z]'))) {
    return "Password must contain at least 1 lowercase letter";
  }

  if (!value.contains(RegExp(r'[0-9]'))) {
    return "Password must contain at least 1 numeric digit";
  }

  if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
    return "Password must contain at least 1 special character";
  }

  if (value.length < 8) {
    return "Password must be at least 8 characters long";
  }

  return null;
}

String timeFormatter(DateTime datetime) => DateFormat("h:mma").format(datetime);
String dateTimeFormatter(DateTime datetime) =>
    DateFormat.yMMMMd('en_US').format(datetime);

String dateFormatter(DateTime datetime) =>
    DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(datetime);

DateTime timeSerializer(DateTime date) => date.subtract(
      const Duration(hours: 5, minutes: 30),
    );

String formatAndMaskAccountNumber(String accountNumber) {
  // Mask all digits except the last 3
  String maskedNumber = accountNumber.replaceRange(
    0,
    accountNumber.length - 4,
    '*' * (accountNumber.length - 4),
  );

  // Add spaces after every 4 digits
  String formattedNumber = maskedNumber
      .replaceAllMapped(
        RegExp(r'.{1,4}'), // Matches groups of 1 to 4 characters
        (match) => '${match.group(0)} ',
      )
      .trim();

  return formattedNumber;
}
