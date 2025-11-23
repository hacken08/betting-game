enum Session {
  role,
  access_token,
  refresh_token,
  id,
}

enum Role {
  SYSTEM,
  ADMIN,
  WORKER,
  USER,
  NONE,
}

enum HttpMethod { POST, GET, PUT, DELETE }

enum Status {
  ACTIVE,
  COMPLETED,
  CANCELLED,
  INACTIVE,
  UPCOMING
}

enum DailyGameStatus {
  UPCOMING,
  ACTIVE,
  COMPLETED,
  CANCELLED,
  INACTIVE,
}

enum GameType {
  JODI,
  ANDER,
  BAHER,
}

enum StatementType {
  Deposite,
  WithdrawalRecord,
  GameRecord,
  CurrentBet,
}

enum GameResultStatus { LOSS, WIN, }


extension EnumStringConverter on StatementType {
  String getEnumString() {
    switch (this) {
      case StatementType.Deposite:
        return 'Deposite';
      case StatementType.WithdrawalRecord:
        return 'Withdrawal Record';
      case StatementType.GameRecord:
        return 'Game Record';
      case StatementType.CurrentBet:
        return 'Current Bet';
      default:
        throw ArgumentError('Invalid StatementType');
    }
  }
}

enum UserStatus {
  ACTIVE,
  INACTIVE,
  BLOCKED,
  NONE,
}
