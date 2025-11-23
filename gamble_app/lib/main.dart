import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/material.dart';
import 'package:gamble_app/router/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const ProviderScope(
        child: Gamble(),
      ),
    ),
  );
}

class Gamble extends HookConsumerWidget {
  const Gamble({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // http://194.238.22.198:7860/dashboard/home
    RouterController.configure(ref);

    return MaterialApp.router(
      title: "Gamble App",
      routerConfig: RouterController.router,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
    );
  }
}
