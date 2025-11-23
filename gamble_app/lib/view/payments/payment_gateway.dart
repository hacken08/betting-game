import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentGatewayPage extends HookConsumerWidget {
  const PaymentGatewayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ExpansionTileController googlePayController =
        ExpansionTileController();
    final ExpansionTileController googlePayUPIController =
        ExpansionTileController();

    final ExpansionTileController phonePeController = ExpansionTileController();
    final ExpansionTileController phonePeUPIController =
        ExpansionTileController();

    final ExpansionTileController paytmController = ExpansionTileController();
    final ExpansionTileController paytmUPIController =
        ExpansionTileController();

    final size = MediaQuery.of(context).size;

    ValueNotifier<bool> gpay = useState(false);

    TextEditingController googlePayUpiInputController =
        useTextEditingController();
    return Scaffold(
        backgroundColor: const Color.fromARGB(250, 250, 250, 250),
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: whiteColor,
          elevation: 2,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              size: 22,
              color: Color.fromARGB(255, 107, 100, 242),
              weight: 40,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Select Payment Method',
            style: TextStyle(
                fontSize: 17,
                letterSpacing: -0.3,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(15),
          width: size.width,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(72, 158, 158, 158).withOpacity(0.1),
                spreadRadius: 6,
                blurRadius: 9,
                offset: const Offset(0, -0.5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Upload \nscreenshot',
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.noScaling,
                          style: TextStyle(
                              color: Color.fromARGB(255, 78, 87, 250),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      )),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 78, 87, 250),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Confirm',
                          textScaler: TextScaler.noScaling,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 0.3,
                  thickness: 0.9,
                  color: Colors.grey.shade400,
                ),

                // ---------- Amount Bar ---------- //
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  width: size.width,
                  constraints: const BoxConstraints(
                    minHeight: 20,
                  ),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 78, 87, 250),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "₹ 4,000",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),

                // ------------- heading 2 ------------- //
                const Padding(
                  padding:
                      EdgeInsets.only(left: 19, right: 19, top: 19, bottom: 15),
                  child: Text(
                    "By UPI id",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // --------------- Google pay UPI ----------- //
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 3,
                          blurRadius: 9,
                          offset: const Offset(-1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () => context.pushNamed(RouteNames.upiPayment),
                    leading: Image.asset(
                      'assets/google_logo.png',
                      height: 28,
                      width: 29,
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
                      child: Text(
                        'Google Pay',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                    dense: true,
                  ),
                ),
                const SizedBox(height: 12),

                // --------------- PhoePe UPI ----------- //
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 3,
                          blurRadius: 9,
                          offset: const Offset(-1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    controller: phonePeUPIController,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/phonePe.jpg',
                        height: 28,
                        width: 29,
                      ),
                    ),
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 19, vertical: 6),
                    onExpansionChanged: (value) => gpay.value = !gpay.value,
                    title: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Phone Pe',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                    dense: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 17),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: TextField(
                                  controller: googlePayUpiInputController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(fontSize: 13),
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.payment,
                                          color: Colors.black),
                                      hintText: 'Enter your UPI ID',
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.0))),
                                  onChanged: (valeu) {},
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Container(
                              width: 70,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 163, 127),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    side: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                ),
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ------------------ Paytm pay upi --------------- //
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 0.5,
                          blurRadius: 0,
                          offset: const Offset(-1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    controller: paytmUPIController,
                    leading: Image.asset(
                      'assets/paytm.jpg',
                      height: 50,
                      width: 50,
                    ),
                    tilePadding: const EdgeInsets.only(
                        left: 8, right: 19, top: 6, bottom: 6),
                    onExpansionChanged: (value) => gpay.value = !gpay.value,
                    title: const Text(
                      'Paytm',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    dense: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 17),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: TextField(
                                  controller: googlePayUpiInputController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(fontSize: 13),
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.payment,
                                          color: Colors.black),
                                      hintText: 'Enter your UPI ID',
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.0))),
                                  onChanged: (valeu) {},
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Container(
                              width: 70,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 163, 127),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    side: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                ),
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),

                // ------------- heading ------------- //
                const Padding(
                  padding:
                      EdgeInsets.only(left: 19, right: 19, top: 19, bottom: 15),
                  child: Text(
                    "By QR code",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // --------------- Google pay ----------- //
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 3,
                          blurRadius: 9,
                          offset: const Offset(-1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () => context.pushNamed(RouteNames.qrPayment),
                    leading: Image.asset(
                      'assets/icons/gpay qr.png',
                      height: 98,
                      width: 145,
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                    dense: true,
                  ),
                ),
                const SizedBox(height: 12),

                // --------------- Phone pe ----------- //
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 0.5,
                          blurRadius: 0,
                          offset: const Offset(-1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    controller: phonePeController,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/icons/phone pe qr.png',
                        height: 98,
                        width: 140,
                      ),
                    ),
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 19, vertical: 6),
                    onExpansionChanged: (value) => gpay.value = !gpay.value,
                    title: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                    dense: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Container(
                        width: size.width,
                        constraints: const BoxConstraints(minHeight: 200),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: const Color.fromARGB(255, 78, 87, 250),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "ANMOL GOYAL",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Text(
                              "UPI ID: example@paytm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 18),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/sample_code.png",
                                  width: 170,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // --------------- Paytm logo ----------- //
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 0.5,
                          blurRadius: 0,
                          offset: const Offset(-1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    controller: paytmController,
                    leading: Image.asset(
                      'assets/icons/Paytm-qr.png',
                      height: 30,
                      width: 150,
                    ),
                    tilePadding: const EdgeInsets.only(
                        left: 8, right: 19, top: 6, bottom: 6),
                    onExpansionChanged: (value) => gpay.value = !gpay.value,
                    title: const Text(
                      '',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    dense: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Container(
                        width: size.width,
                        constraints: const BoxConstraints(minHeight: 200),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: const Color.fromARGB(255, 78, 87, 250),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "ANMOL GOYAL",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Text(
                              "UPI ID: example@paytm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 18),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/sample_code.png",
                                  width: 170,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 57),
              ],
            ),
          ),
        ));
  }
}
