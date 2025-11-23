import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/buttons.dart';
import 'package:gamble_app/components/dialogeBox/add_account_bottom_sheet.dart';
import 'package:gamble_app/components/textinput.dart';
import 'package:gamble_app/model/game/users_account/users_account.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/service/api.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/user_account_state.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/utils/custom_types.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:gamble_app/view/utils/validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class WithdrawAccountDetails extends HookConsumerWidget {
  final double amount;
  const WithdrawAccountDetails({super.key, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final Size size = MediaQuery.of(context).size;
    final usersAccountStateW = ref.watch(userAccountState);

    final accountNumberController = useTextEditingController();
    final accountHolderController = useTextEditingController();
    final bankNameController = useTextEditingController();
    final reEnterAccountNumberController = useTextEditingController();
    final ifscCodeController = useTextEditingController();

    ValueNotifier<int> userId = useState<int>(0);
    ValueNotifier<bool> remeberAccount = useState(false);
    ValueNotifier<bool> requestLoader = useState(false);
    ValueNotifier<UsersAccount?> selectedUserAccount = useState(null);

    Future<void> init() async {
      userId.value = await AuthServices.getUserId(context: context);
      if (usersAccountStateW.userAccountDisplay.isEmpty) {
        usersAccountStateW.getUsersAccountById(context, userId.value);
      }
    }

    Future<void> remeberAccountHandler() async {
      if (!formKey.currentState!.validate()) return;
      await usersAccountStateW.create(
        context,
        userId: userId.value,
        bankName: bankNameController.text,
        accountHolder: accountHolderController.text,
        ifscCode: ifscCodeController.text,
        accountNumber: accountNumberController.text,
      );
      Logger().i("saving account");
    }
    // Logger().i(userId.value);

    void withdrawalRequestHandler() async {
      requestLoader.value = true;
      late ApiResponse data;
      if (remeberAccount.value) await remeberAccountHandler();
      if (selectedUserAccount.value != null) {
        data = await apiCall(
          path: "/api/withdraw/create",
          body: {
            "user_id": userId.value,
            "amount": amount,
            "account_number": selectedUserAccount.value?.accountNumber,
            "bank_name": selectedUserAccount.value?.bankName,
            "account_holder": selectedUserAccount.value?.accountHolder,
            "ifsc_code": selectedUserAccount.value?.ifscCode,
            "status": "ACTIVE"
          },
        );
      } else {
        if (!formKey.currentState!.validate()) return;
        data = await apiCall(
          path: "/api/withdraw/create",
          body: {
            "user_id": userId.value,
            "amount": amount,
            "account_number": accountNumberController.text,
            "bank_name": bankNameController.text,
            "account_holder": accountHolderController.text,
            "ifsc_code": ifscCodeController.text,
            "status": "ACTIVE"
          },
        );
      }
      if (!data.status) {
        simpleRedAlert(context, data.message);
      } else {
        simpleDoneAlert(context, "Withrawal request submitted");
        context.goNamed(RouteNames.home);
        formKey.currentState!.reset();
      }
      requestLoader.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, const []);

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
          "Withdrawal Funds",
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
                width: size.width - 20,
                child: Text(
                  "Enter Bank Account Details",
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
                child: Text(
                  "You must check all details before submiting.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.5,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              //  ==== Input field for amount ====
              Form(
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
                    const SizedBox(height: 16),

                    //  ... Account holder name ...
                    InputFieldwithLable(
                      lableSpace: 6,
                      labelStyle: TextStyle(fontSize: 13.5),
                      controller: accountHolderController,
                      hinttext: "Enter Account Holder Name",
                      label: "Account Holder",
                      validation: validateAccountHolder,
                    ),
                    const SizedBox(height: 16),

                    //  ... Account number ...
                    InputFieldwithLable(
                      lableSpace: 6,
                      labelStyle: TextStyle(fontSize: 13.5),
                      controller: accountNumberController,
                      hinttext: "Enter Account number ",
                      label: "Account number",
                      validation: validateAccountNumber,
                    ),
                    const SizedBox(height: 16),

                    //  ... Re-enter Account number ...
                    InputFieldwithLable(
                      lableSpace: 6,
                      labelStyle: TextStyle(fontSize: 13.5),
                      controller: reEnterAccountNumberController,
                      hinttext: "Re-enter Account number",
                      label: "Account number",
                      validation: (String? value) =>
                          validateReEnterAccountNumber(
                              value, accountNumberController.text),
                    ),
                    const SizedBox(height: 16),

                    //  ... Account holder name ...
                    InputFieldwithLable(
                      lableSpace: 6,
                      labelStyle: TextStyle(fontSize: 13.5),
                      controller: ifscCodeController,
                      hinttext: "Enter IFSC Code",
                      label: "IFSC Code",
                      validation: validateIfscCode,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              // === Remember accoutn button ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Checkbox(
                    value: remeberAccount.value,
                    onChanged: (value) =>
                        remeberAccount.value = !remeberAccount.value,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Remeber this account",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              DIviderWIthOr(),
              const SizedBox(height: 10),

              //  ==== Heading titles ====
              SizedBox(
                width: size.width - 20,
                child: Text(
                  "Saved account",
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
                child: Text(
                  "You can use your previously saved account.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.5,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // === OR select from rememberd account ===
              SelectWithdarwaAccount(
                title: selectedUserAccount.value?.bankName ??
                    "Select a bank account",
                subTitle: formatAndMaskAccountNumber(
                  selectedUserAccount.value?.accountNumber ??
                      "---- ---- ---- ----",
                ),
                onTap: () => showSavedAccount(
                  context: context,
                  userId: userId.value,
                  usersSavedAccoutn: usersAccountStateW.userAccountDisplay,
                  onSelect: (account) => selectedUserAccount.value = account,
                ),
              ),
              const SizedBox(height: 46),

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
                child: requestLoader.value
                    ? CircularProgressIndicator()
                    : Text("Request for withdraw"),
                onPressed: withdrawalRequestHandler,
              ),
              const SizedBox(height: 30),

              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DIviderWIthOr extends StatelessWidget {
  const DIviderWIthOr({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            height: 1.5,
            endIndent: 20,
            indent: 10,
            // height: 1,
          ),
        ),
        Text(
          "OR",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            height: 1.5,
            endIndent: 20,
            indent: 10,
            // height: 1,
          ),
        ),
      ],
    );
  }
}

class SelectWithdarwaAccount extends StatelessWidget {
  final String title;
  final String subTitle;
  final void Function() onTap;
  const SelectWithdarwaAccount({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Center(
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            minVerticalPadding: 0,
            dense: true,
            // minLeadingWidth: 50,
            leading: Container(
              width: 35,
              height: 35,
              margin: const EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200],
              ),
              child: Icon(
                Icons.wallet,
                size: 18,
                color: Colors.grey[600],
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            subtitle: Text(subTitle),
            trailing: Icon(
              Icons.keyboard_arrow_right_outlined,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
