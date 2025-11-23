import 'package:flutter/material.dart';
import 'package:gamble_app/utils/enums.dart';

class ApiResponse {
  bool status;
  dynamic data;
  String message;

  ApiResponse({
    required this.status,
    required this.data,
    required this.message,
  });
}

class UserBetNumber {
  final String bidNumber;
  final TextEditingController controller;
  final GameType type;
  final int gameId;

  UserBetNumber({
    required this.bidNumber,
    required this.controller,
    required this.type,
    required this.gameId,
  });
}

class UserCurrentBets {
  String game;
  int gameId;
  DateTime betTime;
  List<Map> bidNumbersJodi;
  double totalBidAmount;
  DateTime resultTime;
  GameType gameType;

  UserCurrentBets({
    required this.game,
    required this.resultTime,
    required this.gameType,
    required this.gameId,
    required this.betTime,
    required this.bidNumbersJodi,
    required this.totalBidAmount,
  });

  String get getGame => game;
  int get getGameId => gameId;
  DateTime get getBetTime => betTime;
  List<Map> get getBidNumberJodi => bidNumbersJodi;
  double get getTotalBidAmount => totalBidAmount;
  DateTime get getResultTime => resultTime;

  set setGame(String value) => game = value;
  set setbidNumbersJodi(List<Map> value) => bidNumbersJodi = value;
  set setTotalBidAmount(double value) => totalBidAmount = value;
}
