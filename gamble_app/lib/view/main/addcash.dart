// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gamble_app/states/navbar_state.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Status { WON, LOSS }

class HistoryCard extends HookConsumerWidget {
  final String title;
  final Status status;
  final int amount;
  final String date;
  const HistoryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          status == Status.WON
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    color: Colors.red.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.close_sharp,
                    color: Colors.red,
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          status == Status.WON
              ? Text(
                  "+$amount",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  "-$amount",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }
}

class AddCashPage extends HookConsumerWidget {
  const AddCashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarStateW = ref.watch(navbarState);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            navbarStateW.controller.jumpToTab(0);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Bid History"),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: const [
            SizedBox(
              height: 8,
            ),
            HistoryCard(
              amount: 400,
              status: Status.LOSS,
              title: "Loss",
              date: "12-10-2023",
            ),
            HistoryCard(
              amount: 500,
              status: Status.LOSS,
              title: "Loss",
              date: "12-10-2023",
            ),
            HistoryCard(
              amount: 500,
              status: Status.WON,
              title: "Won",
              date: "12-10-2023",
            ),
            HistoryCard(
              amount: 500,
              status: Status.LOSS,
              title: "Loss",
              date: "12-10-2023",
            ),
            HistoryCard(
              amount: 5000,
              status: Status.WON,
              title: "Won",
              date: "12-10-2024",
            ),
          ],
        ),
      ),
    );
  }
}
