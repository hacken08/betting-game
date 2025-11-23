import 'package:gamble_app/model/game/daily_game_with_game/daily_game_with_game.dart';
import 'package:gamble_app/router/page_transition.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/view/chat/singleChat/single_chat_page.dart';
import 'package:gamble_app/view/payments/WithdrawAccountDetails.dart';
import 'package:gamble_app/view/payments/add_money.dart';
import 'package:gamble_app/view/payments/manage_account.dart';
import 'package:gamble_app/view/statments/statement_screen.dart';
import 'package:gamble_app/view/main/game_page.dart';
import 'package:gamble_app/view/login.dart';
import 'package:gamble_app/view/main/main.dart';
import 'package:gamble_app/view/payments/payment_gateway.dart';
import 'package:gamble_app/view/payments/qr_page.dart';
import 'package:gamble_app/view/payments/upi_page.dart';
import 'package:gamble_app/view/payments/withraw.dart';
import 'package:gamble_app/view/profile/refer_and_earn.dart';
import 'package:gamble_app/view/register.dart';
import 'package:gamble_app/view/utils/notifications.dart';
import 'package:gamble_app/view/utils/wallet.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RouterController {
  static late WidgetRef _ref;

  static void configure(WidgetRef ref) {
    _ref = ref;
  }

  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    // errorBuilder: ,
    routes: [
      GoRoute(
        name: RouteNames.login,
        path: "/login",
        builder: (context, state) => const LoginPage(),
        redirect: (context, state) async {
          final session = await AuthServices.getSession();
          final bool isLogin = session != null;
          return isLogin ? "/home" : null;
        },
        routes: [
          GoRoute(
            name: RouteNames.register,
            path: "register",
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
      GoRoute(
        name: RouteNames.home,
        path: "/home",
        builder: (context, state) => const MainPage(),
        routes: [
          GoRoute(
            name: RouteNames.chat,
            path: "chat",
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: ChatPage(
                  reciver: int.parse(state.extra.toString()),
                ),
                transitionsBuilder: slideRightPageTransition,
              );
            },
          ),
          GoRoute(
            name: RouteNames.manageAccount,
            path: "manage_account",
            builder: (context, state) => ManageAccountScreen()
          )
        ],
      ),
      GoRoute(
        name: RouteNames.notification,
        path: "/notification",
        builder: (context, state) => const NotificaionPage(),
      ),
      GoRoute(
        name: RouteNames.wallet,
        path: "/wallet",
        builder: (context, state) => const WalletPage(),
      ),
      GoRoute(
        name: RouteNames.history,
        path: "/history",
        builder: (context, state) => const StatementPageScreen(),
        routes: [
          GoRoute(
            name: RouteNames.addMoney,
            path: "addMoney",
            builder: (context, state) => const AddMoneyPage(),
            routes: [
              GoRoute(
                name: RouteNames.paymentGateway,
                path: "gateway",
                builder: (context, state) => const PaymentGatewayPage(),
                routes: [
                  GoRoute(
                    name: RouteNames.upiPayment,
                    path: "upiPayment",
                    builder: (context, state) => const UpiIdPaymenPage(),
                  ),
                  GoRoute(
                    name: RouteNames.qrPayment,
                    path: "qrPayment",
                    builder: (context, state) => const QrdPaymenPage(),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            name: RouteNames.withdrawMoney,
            path: "withdraw",
            builder: (context, state) => WithdrawPage(),
            routes: <GoRoute>[
              GoRoute(
                name: RouteNames.withdrawDetails,
                path: "WithdrawDetails",
                pageBuilder: (context, state) => CustomTransitionPage(
                  child: WithdrawAccountDetails(
                    amount: state.extra! as double,
                  ),
                  transitionsBuilder: slideRightPageTransition,
                ),
              )
            ],
          ),
        ],
      ),
      // GoRoute(
      //   name: RouteNames.chat,
      //   path: "/chat",
      //   builder: (context, state) => const ContactListPage(),
      // ),
      GoRoute(
        name: RouteNames.referEarn,
        path: "/referEarn",
        builder: (context, state) => const ReferAndEarnPage(),
      ),
      // GoRoute(
      //   name: RouteNames.profile,
      //   path: "/profile",
      //   builder: (context, state) => const ProfilePage(),
      // ),
      GoRoute(
        name: RouteNames.game,
        path: "/game",
        builder: (context, state) => GamePage(
          game: state.extra as DailyGameWithGame,
        ),
      ),
    ],
  );
}
