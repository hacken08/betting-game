import 'package:flutter/cupertino.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final gameState = ChangeNotifierProvider<GameState>((ref) => GameState());

class GameState extends ChangeNotifier {
  int amount = 0;
  
  int updatevalue(
      BuildContext context, double price, List<TextEditingController> controllers) {
    int value = 0;
    for (int i = 0; i < controllers.length; i++) {
      try {
        final bidAmount =
            controllers[i].text.isEmpty || controllers[i].text == ""
                ? 0
                : int.parse(controllers[i].text);

        if (bidAmount > price ) {
          controllers[i].text = "";
          value = amount;
          simpleRedAlert(context, "You can't bet more than 50rs on a number");
          continue;
        }

        value += bidAmount;
        amount = value;
      } catch (error) {
        controllers[i].text = "";
        break;
      }
    }
    notifyListeners();
    return value;
  }
}
