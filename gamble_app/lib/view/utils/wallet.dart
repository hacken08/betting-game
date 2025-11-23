// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Status { WITHDRAW, ADD, WON, LOSS }

class WalletHistory extends HookConsumerWidget {
  final String title;
  final Status status;
  final int amount;
  final String date;
  const WalletHistory({
    super.key,
    required this.title,
    required this.amount,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
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
          status == Status.ADD || status == Status.WON
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.stacked_line_chart,
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
          status == Status.ADD || status == Status.WON
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

class WalletPage extends HookConsumerWidget {
  const WalletPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.go("/home");
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Wallet"),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 5,
            ),

            // ________________________ Balance Box ___________________
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  gradient: const LinearGradient(colors: [
                    Color(0xff6daaf1),
                    Color(0xffc184f5),
                  ]),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Your Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      "₹5,600",
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 10),
                            ),
                            onPressed: () {
                              comingalert(context);
                            },
                            child: const Text(
                              "Add Money",
                              style: TextStyle(
                                color: Color(0xff402633),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 10),
                            ),
                            onPressed: () {
                              comingalert(context);
                            },
                            child: const Text(
                              "Withdraw Money",
                              style: TextStyle(
                                color: Color(0xff402633),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(height: 15.0),

            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const WalletHistory(
              amount: 500,
              status: Status.ADD,
              title: "ADD",
              date: "12-10-2023",
            ),
            const WalletHistory(
              amount: 400,
              status: Status.LOSS,
              title: "Loss",
              date: "12-10-2023",
            ),
            const WalletHistory(
              amount: 500,
              status: Status.WITHDRAW,
              title: "Withdraw",
              date: "12-10-2023",
            ),
            const WalletHistory(
              amount: 500,
              status: Status.ADD,
              title: "ADD",
              date: "12-10-2023",
            ),
            const WalletHistory(
              amount: 500,
              status: Status.ADD,
              title: "ADD",
              date: "12-10-2023",
            ),
            const WalletHistory(
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
