import 'package:flutter/material.dart';
import 'package:gamble_app/components/bottomnavbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(child: CustomBottomNavBars()),
    );
  }
}
