import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/view/utils/diagonaleClipper.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddMoneyPage extends HookConsumerWidget {
  const AddMoneyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController amountController =
        useTextEditingController(text: "00.00");

    final size = MediaQuery.of(context).size;
    final amounts = [
      "1,000",
      "3,000",
      "6,000",
      "7,500",
      "8,500",
      "10,000",
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // ----- AppBar ------ //
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
        ),
        centerTitle: true,
        title: const Text(
          'Add money to wallet',
          style: TextStyle(
              fontSize: 16,
              letterSpacing: -0.3,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
      ),

      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // ----- background square ------ //
              ClipPath(
                clipper: DiagonalBottomClipper(),
                child: Container(
                  height: 160,
                  width: size.width,
                  color: primaryColor,
                ),
              ),

              // ----------- Amount card -------------- //
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                height: 150,
                width: size.width,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 3,
                    blurRadius: 9,
                    offset: const Offset(-1, 3),
                  ),
                ], color: Colors.white, borderRadius: BorderRadius.circular(7)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading....
                    Text(
                      "Enter the amount to add",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500),
                    ),

                    // Amount Field....
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextFormField(
                        selectionHeightStyle: BoxHeightStyle.max,
                        controller: amountController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          // hintText: "00.00",
                          // hintStyle:
                          //     const TextStyle(color: Colors.black, fontSize: 20),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 10),
                            child: Text(
                              "₹",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 10),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 250, 246, 246),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 10),
                        ),
                      ),
                    ),
                    Text(
                      "Your current balance is ₹00.00",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 23,
            ),
            child: Text(
              "Quick amounts",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
            ),
          ),
          const SizedBox(
            height: 14,
          ),

          // .... amount options .... //
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 23,
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final name in amounts)
                  InkWell(
                    onTap: () => amountController.text = name,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
                          width: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          const Icon(Icons.add, size: 15, weight: 10),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => context.pushNamed(RouteNames.paymentGateway),
                highlightColor: Colors.white,
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                child: Container(
                    width: size.width * 0.5,
                    height: 50,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 80, 155, 239),
                        borderRadius: BorderRadius.circular(7)),
                    child: const Center(
                      child: Text(
                        'Next',
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
