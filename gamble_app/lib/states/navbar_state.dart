import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

final navbarState = ChangeNotifierProvider<NavbarState>((ref) => NavbarState());

class NavbarState extends ChangeNotifier {
  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  int index = 1;
  void setIndex(int value) {
    index = value;
    notifyListeners();
  }
}
