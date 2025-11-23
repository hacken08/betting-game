import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/navbar_state.dart';
import 'package:gamble_app/states/userState.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/view/chat/contact_list.dart';
import 'package:gamble_app/view/statments/statement_screen.dart';
import 'package:gamble_app/view/main/home.dart';
import 'package:gamble_app/view/profile/profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

// class CustomBottomNavBars extends HookConsumerWidget {
//   const CustomBottomNavBars({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final navbarStateW = ref.watch(navbarState);
//     return NavigationBar(
//       destinations: const [
//         NavigationDestination(
//           icon: Icon(CupertinoIcons.home),
//           label: "Home",
//           selectedIcon: Icon(
//             CupertinoIcons.home,
//             color: Colors.white,
//           ),
//         ),
//         NavigationDestination(
//             icon: Icon(CupertinoIcons.chat_bubble_2), label: "Chat"),
//         NavigationDestination(icon: Icon(Icons.history), label: "History"),
//         NavigationDestination(
//             icon: Icon(CupertinoIcons.person), label: "Profile"),
//       ],
//       selectedIndex: navbarStateW.index,
//       elevation: 2,
//       height: 80,
//       onDestinationSelected: (index) => navbarStateW.setIndex(index),
//       indicatorColor: primaryColor,
//     );
//   }
// }

class CustomBottomNavBars extends HookConsumerWidget {
  const CustomBottomNavBars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> isLoading = useState(false);
    final navbarStateW = ref.watch(navbarState);
    final userStateW = ref.watch(userState);

    Future<void> init() async {
      isLoading.value = true;
      await userStateW.getUserDataById(
        context,
        await AuthServices.getUserId(context: context),
      );
      isLoading.value = false;
    }

    useEffect(() {
      init();
      return;
    }, const []);

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.home_outlined,
          ),
          title: 'Home',
          activeColorPrimary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.file_copy_outlined,
            size: 18,
          ),
          title: "Statement",
          activeColorPrimary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset(
            'assets/icons/customer-care.png',
            color: primaryColor,
            width: 20,
          ),
          title: "Support",
          // textStyle: const TextStyle(fontSize: 19),
          activeColorPrimary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.person),
          title: "Profile",
          activeColorPrimary: primaryColor,
        ),
      ];
    }

    List<Widget> buildScreens() {
      return [
        const HomePage(),
        const StatementPageScreen(),
        const ContactListPage(),
        const ProfilePage(),
      ];
    }

    return isLoading.value
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : PersistentTabView(
            context,
            screens: buildScreens(),
            items: navBarsItems(),
            controller: navbarStateW.controller,
            decoration: NavBarDecoration(boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
              )
            ]),
          );
  }
}
