import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/buttons.dart';
import 'package:gamble_app/components/chat/chatbox.dart';
import 'package:gamble_app/components/textinput.dart';
import 'package:flutter/material.dart';
import 'package:gamble_app/model/game/users_account/users_account.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:gamble_app/view/utils/validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void showAddAccountBottomSheet(
  BuildContext context, {
  Future<void> Function({
    required String bankName,
    required String accountHolder,
    required String accountNumber,
    required String ifscCode,
  })? onSave,
}) {
  final formKey = GlobalKey<FormState>();
  final accountNumberController = TextEditingController();
  final accountHolderController = TextEditingController();
  final bankNameController = TextEditingController();
  final reEnterAccountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();

  showModalBottomSheet(
      context: context,
      // useSafeArea: true,
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (context) {
        bool isLoading = false;

        final size = MediaQuery.of(context).size;

        void handleCreateUserAccount(
          void Function(void Function()) setState,
        ) async {
          if (!formKey.currentState!.validate()) return;
          setState(() => isLoading = true);
          if (onSave != null)
            await onSave(
              accountHolder: accountHolderController.text,
              bankName: bankNameController.text,
              accountNumber: accountNumberController.text,
              ifscCode: ifscCodeController.text,
            );
          setState(() => isLoading = false);
        }

        return Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),
                  SizedBox(
                    width: size.width - 20,
                    child: const Text(
                      "Add Your Bank Account",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: size.width - 20,
                    child: const Text(
                      "Please review your bank account details carefully before submitting your request.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.5,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  //  ==== Input field for amount ===
                  Form(
                    // canPop: true,
                    key: formKey,
                    child: Column(
                      children: [
                        //  ... bank name ...
                        InputFieldwithLable(
                          lableSpace: 6,
                          readOnly: false,
                          hinttext: "Enter Bank Name",
                          label: "Bank Name",
                          // focusNode: amountFocusNode,
                          controller: bankNameController,
                          validation: validateBankName,
                        ),
                        const SizedBox(height: 20),

                        //  ... Account holder name ...
                        InputFieldwithLable(
                          lableSpace: 6,
                          labelStyle: const TextStyle(fontSize: 13.5),
                          controller: accountHolderController,
                          hinttext: "Enter Account Holder Name",
                          label: "Account Holder",
                          validation: validateAccountHolder,
                        ),
                        const SizedBox(height: 20),

                        //  ... Account number ...
                        InputFieldwithLable(
                          lableSpace: 6,
                          labelStyle: const TextStyle(fontSize: 13.5),
                          controller: accountNumberController,
                          hinttext: "Enter Account number ",
                          label: "Account number",
                          validation: validateAccountNumber,
                        ),
                        const SizedBox(height: 20),

                        //  ... Re-enter Account number ...
                        InputFieldwithLable(
                          lableSpace: 6,
                          labelStyle: const TextStyle(fontSize: 13.5),
                          controller: reEnterAccountNumberController,
                          hinttext: "Re-enter Account number",
                          label: "Account number",
                          validation: (String? value) =>
                              validateReEnterAccountNumber(
                            value,
                            accountNumberController.text,
                          ),
                        ),
                        const SizedBox(height: 20),

                        //  ... Account holder name ...
                        InputFieldwithLable(
                          lableSpace: 6,
                          labelStyle: const TextStyle(fontSize: 13.5),
                          controller: ifscCodeController,
                          hinttext: "Enter IFSC Code",
                          label: "IFSC Code",
                          validation: validateIfscCode,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  // const Spacer(),
                  const SizedBox(
                    height: 20,
                  ),

                  // === Next button ===
                  SizedBox(
                    width: size.width,
                    child: const Text(
                      "Once added you can use this account anytime.",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),

                  StatefulBuilder(builder: (context, setState) {
                    return SimpleButton(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const Text("Save this account"),
                      onPressed: () => handleCreateUserAccount(setState),
                    );
                  }),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void showSavedAccount({
  required BuildContext context,
  required int userId,
  required List<UsersAccount> usersSavedAccoutn,
  required void Function(UsersAccount account) onSelect,
}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      scrollControlDisabledMaxHeightRatio: 0.7,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return Container(
          width: size.width,
          // color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  //  ==== Heading titles ====
                  SizedBox(
                    width: size.width - 20,
                    child: const Text(
                      "Select Account",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ...List.generate(
                    usersSavedAccoutn.length,
                    (index) {
                      final UsersAccount account = usersSavedAccoutn[index];
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              onSelect(account);
                              context.pop();
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              // horizontal: 3,
                              vertical: 0,
                            ),
                            hoverColor: Colors.white,
                            minLeadingWidth: 50,
                            dense: true,
                            trailing: Offstage(
                              offstage: true,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 76, 202, 141),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 234, 234, 234),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.wallet,
                                size: 17,
                              ),
                            ),
                            title: Text(
                              account.bankName ?? "",
                              style: const TextStyle(
                                fontSize: 15.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              formatAndMaskAccountNumber(
                                  account.accountNumber ?? ""),
                              // "Hi, how trade going?",
                              style: const TextStyle(
                                fontSize: 13.6,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 0.5,
                            indent: 40,
                            height: 6,
                            // height: 20,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
