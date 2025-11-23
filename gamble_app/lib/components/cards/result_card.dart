import 'package:flutter/material.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class GameResultCard extends HookConsumerWidget {
  final String title;
  final GameResultStatus status;
  final int amount;
  final String date;
  const GameResultCard({
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
          status == GameResultStatus.WIN
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
                status.name,
                style: TextStyle(
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
          status == GameResultStatus.WIN
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