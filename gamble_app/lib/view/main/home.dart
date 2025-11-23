// ignore_for_file: constant_identifier_names

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/buttons.dart';
import 'package:gamble_app/components/cards/bidcard.dart';
import 'package:gamble_app/components/dialogeBox/payment_recipet.dart';
import 'package:gamble_app/components/drawer.dart';
import 'package:gamble_app/model/game/daily_game_with_game/daily_game_with_game.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/service/api.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/game/dailyGame.dart';
import 'package:gamble_app/states/userState.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<String> dropdownValue = useState('today');
    ValueNotifier<int> userId = useState(0);
    ValueNotifier<DateTime> seletedDate = useState(DateTime.now());
    ValueNotifier<bool> isLoading = useState(false);

    final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
    final DailyGame dailyW = ref.watch(dailyGameState);
    final userStateW = ref.watch(userState);
    final size = MediaQuery.of(context).size;
    // final Size size = MediaQuery.of(context).size;

    Future<void> init() async {
      isLoading.value = true;
      await apiCall(path: "/api/", body: {});
      userId.value = await AuthServices.getUserId(context: context);
      await dailyW.getGameByDate(context, timeSerializer(DateTime.now()));
      isLoading.value = false;
    }

    Future<void> filterByDateHandler(String filter) async {
      isLoading.value = true;
      final DateTime date = filter == "TODAY"
          ? DateTime.now()
          : DateTime.now().subtract(const Duration(days: 1));
      await dailyW.getGameByDate(context, date);
      seletedDate.value = date;
      Future.delayed(
        const Duration(milliseconds: 250),
        () => isLoading.value = false,
      );
      // isLoading.value = false;
    }

    Future<void> getGameByDateHandler(DateTime selectedData) async {
      isLoading.value = true;
      await dailyW.getGameByDate(context, selectedData);
      seletedDate.value = selectedData;
      Future.delayed(
        const Duration(milliseconds: 250),
        () => isLoading.value = false,
      );
    }

    useEffect(() {
      init();
      return null;
    }, const []);

    return Scaffold(
      key: drawerKey,
      drawer: CustomDrwer(
        scaffoldkey: drawerKey,
        id: 1,
        name: "somu",
        email: "somu@gmail.com",
        profile: "",
      ),
      backgroundColor: whiteColor,
      body: Column(
        children: [
          // ------------ top bar ------------- //
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // InkWell(
                //   onTap: () {
                //     drawerKey.currentState!.openDrawer();
                //   },
                //   child: const CircleAvatar(
                //     radius: 20,
                //     backgroundImage: AssetImage("assets/profile.png"),
                //   ),
                // ),
                // const SizedBox(
                //   width: 8,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User id".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "12345678",
                            style: TextStyle(
                              height: 0,
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    "Galiwin.com",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 30,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(7)),
                  child: const Center(
                    child: Text(
                      "₹00.00",
                      style: TextStyle(
                        height: 0,
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      comingalert(context);
                    },
                    child: const Text(
                      "Add Money",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: whiteColor,
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
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      comingalert(context);
                    },
                    child: const Center(
                      child: Text(
                        "Withdraw Money",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19.0),
            child: Row(
              children: [
                SelectionButon(
                  label: "Today",
                  onButtonClick: () => filterByDateHandler("TODAY"),
                ),
                SelectionButon(
                  label: "Yesterday",
                  onButtonClick: () => filterByDateHandler("YESTERDAY"),
                ),
                Spacer(),
                SelectionButon(
                  label: dateFormatter(seletedDate.value),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 1.5),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      size: 14,
                      color: Colors.black54,
                    ),
                  ),
                  onButtonClick: () => showDatePickerCalendar(
                    context,
                    prevSelectedDateTime: seletedDate.value,
                    onDateSelect: (date) => getGameByDateHandler(date),
                  ),
                ),

                // CalendarDatePicker2(
                //   config: CalendarDatePicker2Config(),
                //   value: [DateTime.now()],
                //   onValueChanged: (dates) => null,
                // ),
                // Container(
                //   height: 35,
                //   constraints: BoxConstraints(maxWidth: 140),
                //   padding: const EdgeInsets.symmetric(horizontal: 8),
                //   margin:
                //       const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //         color: const Color.fromARGB(106, 29, 29, 29),
                //         width: 0.8,
                //       ),
                //       borderRadius: BorderRadius.circular(3)),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text(
                //         "Select date",
                //         style: TextStyle(fontSize: 11),
                //       ),
                //       Icon(
                //         Icons.calendar_month,
                //         size: 15,
                //         color: Colors.black54,
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          // _buildSingleDatePickerWithValue(),

          isLoading.value
              ? CircularProgressIndicator()
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Offstage(
                          offstage: !dailyW.gamesDisplayList.isEmpty,
                          child: Column(
                            children: [
                              SizedBox(height: size.height * 0.25),
                              Text(
                                "No game found for ${dateFormatter(seletedDate.value)}",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...dailyW.gamesDisplayList.map(
                          (DailyGameWithGame game) {
                            return BidInfo(
                              onTap: () {
                                if (game.status == Status.INACTIVE) return;
                                context.pushNamed(RouteNames.game, extra: game);
                              },
                              title: game.name,
                              id: game.uid,
                              status: game.status,
                              openned: game.result ?? "30",
                              result_time: timeFormatter(game.end_time),
                              start: timeFormatter(game.start_time),
                              end: timeFormatter(game.end_time),
                            );
                          },
                        ).toList()
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
