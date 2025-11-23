import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/buttons.dart';
import 'package:gamble_app/components/textinput.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/view/utils/validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WithdrawPage extends HookConsumerWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController availableAmountController =
        useTextEditingController();
    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    void onNextHandler() {
      if (!formKey.currentState!.validate()) return;
      context.pushNamed(
        RouteNames.withdrawDetails,
        extra: double.parse(amountController.text),
      );
    }

    useEffect(() {
      // amountController.text = "00.00";
      availableAmountController.text = "200.00";
      return;
    }, []);

    return Scaffold(
      backgroundColor: whiteColor,

      //  ==== Page's Top bar ====
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: 19,
          ),
        ),
        title: Text(
          "Withdrawal",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 18),

              //  ==== Heading titles ====
              SizedBox(
                width: size.width,
                child: Text(
                  "Enter Withdrawal Amount",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17.5,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: size.width,
                child: Text(
                  "Please enter the amount you wish to withdraw.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              //  ==== Input field for amount ===
              Form(
                // canPop: true,
                key: formKey,
                child: Column(
                  children: [
                    InputFieldwithLable(
                      readOnly: false,
                      label: "Amount",
                      hinttext: "00.00",
                      // focusNode: amountFocusNode,
                      controller: amountController,
                      validation: amountValidator,
                    ),
                    const SizedBox(height: 26),
                    InputFieldwithLable(
                      controller: availableAmountController,
                      label: "Available balance",
                      readOnly: true,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // === Next button ===
              SizedBox(
                width: size.width,
                child: Text(
                  "Funds will be processed within 3-5 business days.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),

              SimpleButton(
                child: Text("NEXT"),
                onPressed: onNextHandler,
              ),
            ],
          ),
        ),
      ),
    );

    //             Expanded(
    //                 child: InkWell(
    //               onTap: () {
    //                 if (amountController.text.isEmpty) {
    //                   erroralert(context, "Amount is empty", "");
    //                   return;
    //                 };
    //                 try {
    //                   context.pushNamed(RouteNames.withdrawDetails,
    //                       extra: double.parse(amountController.text));
    //                 } catch (Error) {
    //                   erroralert(context, "Amount is not valid", "");
    //                 }
    //               },
    //               focusColor: Colors.white,
    //               hoverColor: Colors.white,
    //               splashColor: Colors.white,
    //               highlightColor: Colors.white,
    //               child: Container(
    //                 margin: const EdgeInsets.only(right: 20, left: 10, top: 50),
    //                 height: 40,
    //                 decoration: BoxDecoration(
    //                     color: primaryColor,
    //                     borderRadius: BorderRadius.circular(10)),
    //                 child: Center(
    //                   child: Text(
    //                     "Next",
    //                     style: TextStyle(
    //                         color: Colors.white, fontWeight: FontWeight.w600),
    //                   ),
    //                 ),
    //               ),
    //             ))
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
