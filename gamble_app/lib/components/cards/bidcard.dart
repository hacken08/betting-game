// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BidInfo extends HookConsumerWidget {
  final String title;
  final String id;
  final Status status;
  final String start;
  final String result_time;
  final void Function()? onTap;
  final String? openned;
  final String end;

  const BidInfo({
    super.key,
    this.onTap,
    this.openned,
    required this.id,
    required this.title,
    required this.status,
    required this.result_time,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            color: status == Status.COMPLETED
                ? const Color.fromARGB(255, 252, 232, 232)
                : whiteColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: status == Status.COMPLETED
                            ? Colors.redAccent
                            : primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          status == Status.COMPLETED ? "Close" : "Open: ${status.name}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Open time: $start | Close time: $end",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Result time: $result_time",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  // width: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        status == Status.COMPLETED && openned != null
                            ? openned.toString()
                            : "Not",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "Openned",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 4,
            )
          ],
        ),
      ),
    );
  }
}


class CurrentBetCards extends HookConsumerWidget {
  final String gameName;
  final String bettingDate;
  final String resultTime;
  final List<Map> bidNumbers;
  final double totalBidAmount;

  const CurrentBetCards({
    super.key,
    required this.gameName,
    required this.bettingDate,
    required this.resultTime,
    required this.bidNumbers,
    required this.totalBidAmount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    final List<Map> bidsOnJodi =
        bidNumbers.where((bids) => bids["gameType"] == GameType.JODI).toList();
    final List<Map> bidsOnA =
        bidNumbers.where((bids) => bids["gameType"] == GameType.ANDER).toList();
    final List<Map> bidsOnB =
        bidNumbers.where((bids) => bids["gameType"] == GameType.BAHER).toList();

    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 22),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(-1, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gameName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Betting time: $bettingDate",
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Result time: $resultTime",
                  maxLines: 3,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          //  ............Joidi number............
          Offstage(
            offstage: bidsOnJodi.isEmpty,
            child: const Text(
              "Jodi Number:-",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.6,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 2),
          NumbersGridView(
            size: size,
            gameType: GameType.JODI,
            bidNumbers: bidsOnJodi,
          ),
          const SizedBox(height: 10),

          //  ............Joidi number............
          Offstage(
            offstage: bidsOnA.isEmpty,
            child: const Text(
              "Ander Number:-",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.6,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 2),
          NumbersGridView(
            size: size,
            bidNumbers: bidsOnA,
            gameType: GameType.ANDER,
          ),
          const SizedBox(height: 10),

          //  ............Joidi number............
          Offstage(
            offstage: bidsOnB.isEmpty,
            child: const Text(
              "Baher Number:-",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.6,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 2),
          NumbersGridView(
            size: size,
            bidNumbers: bidsOnB,
            gameType: GameType.BAHER,
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Text(
                "Total Bid amount",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13.6,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                "₹ $totalBidAmount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.green[600]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumbersGridView extends StatelessWidget {
  const NumbersGridView({
    super.key,
    required this.size,
    required this.bidNumbers,
    required this.gameType,
  });

  final Size size;
  final List<Map> bidNumbers;
  final GameType gameType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      constraints: const BoxConstraints(maxHeight: 150),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 2,
            mainAxisExtent: 50,
          ),
          itemCount: bidNumbers.length,
          itemBuilder: (context, index) {
            final bidNumber = bidNumbers[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 7.2, horizontal: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 219, 234, 254),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  "${bidNumber["number"]}=${bidNumber["amount"]}₹",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(175, 30, 64, 175),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
