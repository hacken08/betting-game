import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/dialogeBox/add_account_bottom_sheet.dart';
import 'package:gamble_app/model/game/users_account/users_account.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/user_account_state.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ManageAccountScreen extends HookConsumerWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> userId = useState<int>(0);
    // ValueNotifier<List<UsersAccount>> accounts = useState([]);

    final size = MediaQuery.of(context).size;
    final userAccountStateW = ref.watch(userAccountState);

    Future<void> init() async {
      userId.value = await AuthServices.getUserId(context: context);
      await userAccountStateW.getUsersAccountById(context, userId.value);
    }

    Future<void> createAccountHandler({
      required String bankName,
      required String accountHolder,
      required String accountNumber,
      required String ifscCode,
    }) async {
      final isSuccess = await userAccountStateW.create(
        context,
        userId: userId.value,
        bankName: bankName,
        accountHolder: accountHolder,
        ifscCode: ifscCode,
        accountNumber: accountNumber,
      );

      if (!isSuccess) return;
      simpleDoneAlert(context, "Your accound has been saved");
      context.pop();
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
          "Bank Accounts",
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
                  "Manage Your Bank Accounts",
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
                  "Please review your bank account details carefully before submitting your request.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.5,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              ...List.generate(
                userAccountStateW.userAccountDisplay.length,
                (index) {
                  final UsersAccount account = userAccountStateW.userAccountDisplay[index];
                  
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 4,
                        ),
                        splashColor: Colors.white,
                        hoverColor: Colors.white,
                        focusColor: Colors.white,
                        tileColor: Colors.white,
                        minLeadingWidth: 50,
                        dense: false,
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 234, 234, 234),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.wallet,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          account.bankName ?? "Acount name",
                          style: const TextStyle(
                            fontSize: 15.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          formatAndMaskAccountNumber(account.accountNumber ?? ""),
                          // "Hi, how trade going?",
                          style: const TextStyle(
                            fontSize: 13.6,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black45,
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

              const SizedBox(height: 6),
              ListTile(
                onTap: () => showAddAccountBottomSheet(
                  context,
                  onSave: createAccountHandler,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 0,
                ),
                splashColor: Colors.white,
                hoverColor: Colors.white,
                focusColor: Colors.white,
                tileColor: Colors.white,
                minLeadingWidth: 50,
                dense: false,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(166, 178, 220, 255),
                    // color: Color.fromARGB(255, 234, 234, 234),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.blue[600],
                    size: 25,
                  ),
                ),
                title: Text(
                  "Add Bank Account",
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 15.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
