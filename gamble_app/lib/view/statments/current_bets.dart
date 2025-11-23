import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/cards/bidcard.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/game/dailyGame.dart';
import 'package:gamble_app/utils/custom_types.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CurrentBetSection extends HookConsumerWidget {
  const CurrentBetSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> userId = useState(0);
    ValueNotifier<bool> isLoading = useState(false);
    ValueNotifier<List<UserCurrentBets>> currentBets = useState([]);

    final DailyGame dailyGameStateW = ref.watch(dailyGameState);
    final Size size = MediaQuery.of(context).size;

    Future<void> init() async {
      isLoading.value = true;
      userId.value = await AuthServices.getUserId(context: context);
      dailyGameStateW.getCurrentBets(
        context,
        userId.value,
        timeSerializer(DateTime.now()),
      );
      isLoading.value = false;
    }

    void filteringUserBets() {
      List<UserCurrentBets> totalGame = [];
      for (final bets in dailyGameStateW.usersCurrentBetsDisplayList) {
        if (bets.game == null) return;
        if (bets.daily_game == null) return;
        
        bool isExists = totalGame.any((game) {
          if (bets.game!.id != game.gameId) return false;
          final addNumber = {
            "gameType": bets.game_type,
            "number": bets.bid_number,
            "amount": bets.amount,
          };
          game.totalBidAmount += double.parse(bets.amount);
          game.bidNumbersJodi = [...game.bidNumbersJodi, addNumber];
          return true;
        });
        if (isExists) continue;
        final bidNumber = {
          "gameType": bets.game_type,
          "number": bets.bid_number,
          "amount": bets.amount,
        };

        totalGame.add(
          UserCurrentBets(
            game: bets.game!.name,
            gameType: bets.game_type,
            resultTime: bets.game!.end_time,
            gameId: bets.game!.id,
            betTime: bets.created_at,
            bidNumbersJodi: [bidNumber],
            totalBidAmount: double.parse(bets.amount),
          ),
        );
      }
      currentBets.value = totalGame;
    }

    useEffect(() {
      filteringUserBets();
      return null;
    }, [dailyGameStateW.usersCurrentBetsDisplayList]);

    useEffect(() {
      init();
      return null;
    }, const []);

    return Column(
      children: [
        Offstage(
          offstage: !isLoading.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        ),
        ...currentBets.value.map((UserCurrentBets currentBets) {
          return CurrentBetCards(
            gameName: currentBets.game,
            bettingDate: timeFormatter(currentBets.betTime),
            resultTime: timeFormatter(currentBets.resultTime),
            bidNumbers: currentBets.bidNumbersJodi,
            totalBidAmount: currentBets.totalBidAmount,
          );
        }).toList(),
        const SizedBox(height: 20)
      ],
    );
  }
}
