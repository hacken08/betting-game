import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/cards/result_card.dart';
import 'package:gamble_app/model/game/game_result/game_result.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/game/game_result.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class GameRecordSection extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> userId = useState(0);
    ValueNotifier<bool> isLoading = useState(false);

    final gameResultStateW = ref.watch(gameResultState);

    Future<void> init() async {
      isLoading.value = true;
      userId.value = await AuthServices.getUserId(context: context);
      await gameResultStateW.get_game_result(context, userId.value, 0, 100);
      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, const []);

    return isLoading.value
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              ...List.generate(
                gameResultStateW.gameRecordDisplay.length,
                (index) {
                  final GameResult gameResult = gameResultStateW.gameRecordDisplay[index];
                  return GameResultCard(
                    amount: int.tryParse(gameResult.amount) ?? 0,
                    status: gameResult.result,
                    title: gameResult.result.toString(),
                    date: dateTimeFormatter(gameResult.created_at),
                  );
                },
              ),
            ],
          );
  }
}
