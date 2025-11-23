import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/model/game/daily_game_with_game/daily_game_with_game.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/game/dailyGame.dart';
import 'package:gamble_app/states/game/gamearea.dart';
import 'package:gamble_app/states/userState.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/utils/custom_types.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class GamePage extends HookConsumerWidget {
  final DailyGameWithGame game;
  const GamePage({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> userId = useState(0);
    ValueNotifier<int> totalAmount = useState(0);

    final gameStateW = ref.watch(gameState);
    final userStateW = ref.watch(userState);
    final size = MediaQuery.of(context).size;
    final dailyGameStateW = ref.watch(dailyGameState);
    final List<UserBetNumber> numberForJodi = useMemoized(() {
      return List<UserBetNumber>.generate(100, (index) {
        return UserBetNumber(
          bidNumber: index + 1 == 100
              ? "00"
              : (index + 1).toString().length == 1
                  ? "0${index + 1}"
                  : (index + 1).toString(),
          controller: TextEditingController(),
          type: GameType.JODI,
          gameId: game.id,
        );
      });
    });
    final List<UserBetNumber> numberForA = useMemoized(() {
      return List<UserBetNumber>.generate(10, (index) {
        return UserBetNumber(
          bidNumber: index + 1 == 10
              ? "0"
              : (index + 1).toString().length == 1
                  ? "0${index + 1}"
                  : (index + 1).toString(),
          controller: TextEditingController(),
          type: GameType.ANDER,
          gameId: game.id,
        );
      });
    });
    final List<UserBetNumber> numberForB = useMemoized(() {
      return List<UserBetNumber>.generate(10, (index) {
        return UserBetNumber(
          bidNumber: index + 1 == 10
              ? "0"
              : (index + 1).toString().length == 1
                  ? "0${index + 1}"
                  : (index + 1).toString(),
          controller: TextEditingController(),
          type: GameType.BAHER,
          gameId: game.id,
        );
      });
    });

    void init() async {
      userId.value = await AuthServices.getUserId(context: context);
    }

    Future<bool> submittingAllBid(List<UserBetNumber> placedBets) async {
      bool isAllBetPlaced = true;
      for (final bet in placedBets) {
        Logger().f(bet.bidNumber);
        final bool isSuuccess = await dailyGameStateW.makeABet(
          context,
          userId.value,
          bet,
        );
        if (!isSuuccess) {
          isAllBetPlaced = false;
          break;
        }
      }
      return isAllBetPlaced;
    }

    Future<void> placeBidHandler() async {
      List<UserBetNumber> placedBets = [
        ...numberForJodi,
        ...numberForA,
        ...numberForB
      ];

      placedBets = placedBets
          .where(
            (allBets) =>
                allBets.controller.text != "0" &&
                allBets.controller.text.isNotEmpty,
          )
          .toList();

      if (placedBets.isEmpty) return;
      if (placedBets.length > game.max_number!) {
        simpleRedAlert(context, "You reached betting limit in this game");
        return;
      }
      if (!await submittingAllBid(placedBets)) return;
      dailyGameStateW.getCurrentBets(context, userId.value, DateTime.now());
      userStateW.getUserDataById(context, userId.value);
      doneAlert(context, "Your bet has been submitted", '');
      placedBets.forEach((bets) => bets.controller.clear());
      // context.pop();
    }

    void handleAmountInputValidation(UserBetNumber bet, String? value) {
      totalAmount.value = gameStateW.updatevalue(
        context,
        double.parse(game.max_price ?? "0"),
        [
          ...numberForJodi.map((joid) => joid.controller),
          ...numberForA.map((joid) => joid.controller),
          ...numberForB.map((joid) => joid.controller),
        ],
      );
    }

    useEffect(() {
      init();
      return () => null;
    }, const []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // backgroundColor: Colors.transparent,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            hoverColor: Colors.white,
            onPressed: () => context.go("/home"),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          Text(
            "Max number:  ${game.max_number}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 15,
          ),
        ],
        title: Text(game.name),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: size.width,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 8,
                color: Colors.black12,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Total Amount: ${totalAmount.value}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: placeBidHandler,
                child: const Text(
                  "Place bid",
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(height: 1.1),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(
                    "Wallet Amount: 1000",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // ------- "JOid" -------------- //
                Wrap(
                  direction: Axis.horizontal,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    for (final jodi in numberForJodi) ...[
                      GameArea(
                        title: jodi.bidNumber.toString(),
                        controller: jodi.controller,
                        onChanged: (String? value) =>
                            handleAmountInputValidation(jodi, value),
                      )
                    ]
                  ],
                ),

                // ------- "Ander" -------------- //
                const Padding(
                  padding:
                      EdgeInsets.only(left: 19, right: 19, top: 19, bottom: 10),
                  child: Text(
                    "Ander / A",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: primaryColor,
                    ),
                  ),
                ),

                Wrap(
                  direction: Axis.horizontal,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    for (final ander in numberForA) ...[
                      GameArea(
                        title: ander.bidNumber.toString(),
                        controller: ander.controller,
                        onChanged: (String? value) =>
                            handleAmountInputValidation(ander, value),
                      )
                    ]
                  ],
                ),
                // ------- "Baher" -------------- //
                const Padding(
                  padding: EdgeInsets.only(
                    left: 19,
                    right: 19,
                    top: 19,
                    bottom: 10,
                  ),
                  child: Text(
                    "Baher / B",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: primaryColor),
                  ),
                ),

                Wrap(
                  direction: Axis.horizontal,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    for (final baher in numberForB) ...[
                      GameArea(
                        title: baher.bidNumber.toString(),
                        controller: baher.controller,
                        onChanged: (String? value) =>
                            handleAmountInputValidation(baher, value),
                      )
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameArea extends HookConsumerWidget {
  final String title;
  final TextEditingController controller;
  final void Function(String? value)? onChanged;
  const GameArea({
    super.key,
    this.onChanged,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final gameStatew = ref.watch(gameState);

    return SizedBox(
      width: size.width / 10,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: primaryColor)),
        child: Column(
          children: [
            Container(
              width: size.width / 5,
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: controller,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
