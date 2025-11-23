import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QrdPaymenPage extends HookConsumerWidget {
  const QrdPaymenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(child: Text('QR Payment Page')),
    );
  }
}
