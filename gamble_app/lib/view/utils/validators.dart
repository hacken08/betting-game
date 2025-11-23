String? amountValidator(String? value) {
  if (value == null || value.isEmpty) return "Amount is required";
  if (double.tryParse(value) == null) return "Amount is not valid";
  if (double.parse(value) <= 0.0) return "You can't widthraw ${value}";
  return null;
}

// Validation function for Account Number
String? validateAccountNumber(String? value) {
  if (value == null || value.isEmpty) {
    return "Account number is required.";
  }
  // Add additional validation rules (e.g., length, pattern)
  if (value.length < 10) {
    return "Account number must be at least 10 digits long.";
  }
  return null;
}

// Validation function for Account Holder Name
String? validateAccountHolder(String? value) {
  if (value == null || value.isEmpty) {
    return "Account holder name is required.";
  }
  // Additional checks, if needed
  return null;
}

// Validation function for Bank Name
String? validateBankName(String? value) {
  if (value == null || value.isEmpty) {
    return "Bank name is required.";
  }
  // Additional checks, if needed
  return null;
}

// Validation function for Bank Name
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return "Name is required.";
  }
  // Additional checks, if needed
  return null;
}

String? validateEmailId(String? email) {
  // Regular expression for validating an email address
  if (email == null || email.isEmpty) return null;
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // if (email != null && email.isEmpty) {
  //   return 'Email is required.';
  // } else
  if (!emailRegex.hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null;
}

// Validation function for Re-enter Account Number
String? validateReEnterAccountNumber(String? value, String accountNumber) {
  if (value == null || value.isEmpty) {
    return "Please re-enter the account number.";
  }
  // Check if the re-entered account number matches the original
  if (value != accountNumber) {
    return "Account numbers do not match.";
  }
  return null;
}

// Validation function for IFSC Code
String? validateIfscCode(String? value) {
  if (value == null || value.isEmpty) {
    return "IFSC code is required.";
  }
  // Validate IFSC format (example: starts with alphabets, followed by digits)
  final ifscRegExp = RegExp(r'^[A-Za-z]{4}[0][A-Za-z0-9]{6}$');
  if (!ifscRegExp.hasMatch(value)) {
    return "Invalid IFSC code format.";
  }
  return null;
}
