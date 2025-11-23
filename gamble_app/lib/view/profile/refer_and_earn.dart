import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReferAndEarnPage extends HookConsumerWidget {
  const ReferAndEarnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // toolbarHeight: 80,
          backgroundColor: primaryColor,
          leading: InkWell(
            onTap: () => context.pop(),
            focusColor: primaryColor,
            hoverColor: primaryColor,
            splashColor: primaryColor,
            highlightColor: primaryColor,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          // title: Text(
          //   "Refer and Earn",
          //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17 , color: Colors.white),
          // ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              constraints: BoxConstraints(minHeight: size.height * 0.25),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
              child: Column(
                children: [
                  // ------------ Heading 1 --------------- //
                  Text(
                    "Refer and Earn",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 23,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // ------------ Heading 2 --------------- //
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Simply share your unique referral link, and for every signup through your link, you'll receive a reward",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color.fromARGB(225, 255, 255, 255)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // ------------ gift image -------------//
                  // Image.asset(
                  //   'assets/gift.png',
                  //   width: 80,
                  // ),

                  // const SizedBox(
                  //   height: 35,
                  // ),
                  // ------------ Refer code --------------- //
                  DottedBorder(
                      radius: Radius.circular(10),
                      color: Colors.white,
                      dashPattern: [4, 6],
                      stackFit: StackFit.passthrough,
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 130, 184, 247),
                            borderRadius: BorderRadius.circular(0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Your referral code",
                                  style: TextStyle(
                                      height: 0,
                                      color: Color.fromARGB(142, 255, 255, 255),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9),
                                ),
                                SelectableText(
                                  "ABCDG123",
                                  style: TextStyle(
                                      height: 0,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Expanded(
                                child: SizedBox(
                              height: 25,
                              child: VerticalDivider(
                                color: const Color.fromARGB(193, 255, 255, 255),
                                thickness: 0.4,
                              ),
                            )),
                            InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.copy,
                                  size: 15,
                                  color:
                                      const Color.fromARGB(224, 255, 255, 255),
                                ))
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView(
                    children: [
                      //  -------------- earning records --------------- //
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Earning Records",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InfoBox(
                                  title: "Total\nearning",
                                  icon: Icons.wallet_giftcard,
                                  value: "Rs 200"),
                              InfoBox(
                                  title: "Invited\nfriends",
                                  icon: Icons.person_add_outlined,
                                  value: "20"),
                              InfoBox(
                                  title: "Can\nearn",
                                  icon: Icons.sell_outlined,
                                  value: "Rs 200"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      //  -------------- Your invite history --------------- //
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Your invite history",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),

                      for (int a = 0; a < 6; a++) ...[
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          splashColor: const Color.fromARGB(255, 246, 242, 255),
                          hoverColor: const Color.fromARGB(255, 246, 242, 255),
                          focusColor: const Color.fromARGB(255, 246, 242, 255),
                          dense: true,
                          onTap: () {},
                          minLeadingWidth: 46,
                          leading: const CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/profile.png'),
                            radius: 20,
                          ),
                          title: const Text("User Name",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          subtitle: const Text(
                            "For first game",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Text(
                            "+200",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 0.3,
                          height: 5,
                          color: Color.fromARGB(52, 0, 0, 0),
                        ),
                      ] // for loop
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class InfoBox extends HookConsumerWidget {
  final String title;
  final IconData icon;
  final String value;
  const InfoBox(
      {super.key,
      required this.title,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(right: 12, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.16),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
