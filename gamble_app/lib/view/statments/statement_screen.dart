// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/cards/result_card.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/userState.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:gamble_app/view/statments/current_bets.dart';
import 'package:gamble_app/view/statments/game_record.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../states/navbar_state.dart';

class StatementPageScreen extends HookConsumerWidget {
  const StatementPageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> gpay = useState(false);
    ValueNotifier<bool> isLoading = useState(false);
    ValueNotifier<int> userId = useState(0);
    ValueNotifier<String> currentStatement =
        useState(StatementType.CurrentBet.getEnumString());

    final navbarStateW = ref.watch(navbarState);
    final userStateW = ref.watch(userState);
    final size = MediaQuery.of(context).size;
    final Widget currentBetSession = useMemoized(() {
      return const CurrentBetSection();
    });

    void init() async {
      userId.value = await AuthServices.getUserId();
      if (userStateW.thisUser == null) {
        if (!context.mounted) return;
        await userStateW.getUserDataById(context, userId.value);
      }
    }

    useEffect(() {
      init();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            navbarStateW.controller.jumpToTab(0);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Statement"),
      ),
      body: isLoading.value
          ? const CircularProgressIndicator()
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),

                  // ________________________ Balance Box ___________________
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        // color: const Color(0xff402633),
                        color: const Color(0xff402633),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'User Id: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "#",
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300),
                                    children: [
                                      TextSpan(
                                          text: userStateW.thisUser?.id
                                                  .toString() ??
                                              "0",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                            fontSize: 13,
                                          ))
                                    ]),
                              ),
                              // const Text(
                              //   "#12345678",
                              //   textScaler: TextScaler.linear(1),
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontWeight: FontWeight.w500,
                              //     letterSpacing: 0.5,
                              //     fontSize: 13,
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Balance: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                userStateW.thisUser?.wallet ?? "__",
                                textScaler: const TextScaler.linear(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      context.pushNamed(RouteNames.addMoney),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          240, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Add Money",
                                        style: TextStyle(
                                          color: Color(0xff402633),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => context
                                      .pushNamed(RouteNames.withdrawMoney),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            240, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: const Center(
                                      child: Text(
                                        "Withdraw",
                                        style: TextStyle(
                                            color: Color(0xff402633),
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(height: 15.0),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    width: size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(
                      //   color: Colors.grey.withOpacity(0.7),
                      //   width: 0.6,
                      // ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(-1, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        value: currentStatement.value,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        onChanged: (String? value) {
                          if (value == null) return;
                          currentStatement.value = value;
                        },
                        isDense: false,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        iconSize: 20,
                        underline: Container(
                          height: 0.0,
                        ),
                        items: StatementType.values.map((StatementType value) {
                          return DropdownMenuItem(
                            value: value.getEnumString(),
                            child: Text(value.getEnumString()),
                          );
                        }).toList(),
                      ),
                      // child: ExpansionTile(
                      //   controller: paytmController,
                      //   tilePadding: const EdgeInsets.only(
                      //       left: 20, right: 19, top: 6, bottom: 6),
                      //   onExpansionChanged: (value) => gpay.value = !gpay.value,
                      //   title: Text(
                      //     'All History',
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      //   dense: true,
                      //   backgroundColor: Colors.white,
                      //   children: <Widget>[
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 12.0, vertical: 15),
                      //       child: Column(
                      //         children: [
                      //           //  ..... Filter button ......
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                 "Deposite record",
                      //                 style: TextStyle(fontWeight: FontWeight.w400),
                      //               ),
                      //               Checkbox(value: false, onChanged: (value) {})
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                 "Withdrawal record",
                      //                 style: TextStyle(fontWeight: FontWeight.w400),
                      //               ),
                      //               Checkbox(value: false, onChanged: (value) {})
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                 "Gameplay record",
                      //                 style: TextStyle(fontWeight: FontWeight.w400),
                      //               ),
                      //               Checkbox(value: false, onChanged: (value) {})
                      //             ],
                      //           ),

                      //           //  ----------- History statment ------------

                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  Expanded(
                    child: Container(
                      width: size.width,
                      // color: Colors.black,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (currentStatement.value ==
                                StatementType.GameRecord.getEnumString()) ...[
                              GameRecordSection()
                            ] else if (currentStatement.value ==
                                StatementType.Deposite.getEnumString()) ...[
                              const Center(child: Text("Coming soon"))
                            ] else if (currentStatement.value ==
                                StatementType.WithdrawalRecord
                                    .getEnumString()) ...[
                              const Center(child: Text("Coming soon"))
                            ] else ...[
                              currentBetSession
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
