import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/colors.dart';

class UpiIdPaymenPage extends HookConsumerWidget {
  const UpiIdPaymenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController upiIdController = useTextEditingController();
    upiIdController.text = "exampleUpi@okicic";

    final size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "UPI ID Payment Page",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(
            thickness: 0.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Make a deposite",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.09),
                    spreadRadius: 0.5,
                    blurRadius: 1,
                    offset: const Offset(-1, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/paytm.jpg',
                  height: 70,
                  width: 100,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text:
                          "Niche diye gaye number / upi id ko copy karke ₹ 300 paytm kare phir",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: " next",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                        TextSpan(
                          text: " Button pe click kare",
                          style: TextStyle(
                              // fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ]),
                ),
                const SizedBox(height: 9)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            // width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.09),
                    spreadRadius: 0.5,
                    blurRadius: 1,
                    offset: const Offset(-1, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Total amount summary",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 9)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            // width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.09),
                    spreadRadius: 0.9,
                    blurRadius: 1,
                    offset: const Offset(0, -3),
                  ),
                ],
                borderRadius: BorderRadius.circular(7)),
            child: TextFormField(
              controller: upiIdController,
              selectionHeightStyle: BoxHeightStyle.tight,
              style: const TextStyle(color: Colors.black54),
              cursorHeight: 20,
              cursorWidth: 1,
              enabled: false,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/upi-icon.png',
                    width: 40,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.copy,
                  size: 17,
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 10),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(height: 30),

          //  ----------------- uppload screen shot section ------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Upload screen shot",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black),
              ),
            ],
          ),

          Container(
            width: size.height,
            height: 120,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.09),
                    spreadRadius: 0.9,
                    blurRadius: 1,
                    offset: const Offset(1, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(7)),
            child: DottedBorder(
                radius: Radius.circular(10),
                color: Colors.black87,
                dashPattern: [4, 6],
                stackFit: StackFit.passthrough,
                child: Container(
                  width: 200,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 9),
                          ),
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
                            color: const Color.fromARGB(224, 255, 255, 255),
                          ))
                    ],
                  ),
                )),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ........ Back button ...........
              Expanded(
                  child: InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 10, top: 50),
                  height: 40,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Back",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )),

              // ........ Back button ...........
              Expanded(
                  child: InkWell(
                onTap: () {},
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                child: Container(
                  margin: const EdgeInsets.only(right: 20, left: 10, top: 50),
                  height: 40,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
