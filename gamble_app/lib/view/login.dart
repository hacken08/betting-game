import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final double statusbarHeight = MediaQuery.of(context).padding.top;
    var emailController = useTextEditingController();
    var passwordController = useTextEditingController();

    ValueNotifier<bool> showPass = useState<bool>(true);
    ValueNotifier<bool> isLoading = useState<bool>(false);

    final GlobalKey<FormState> formKey = useMemoized(
      () => GlobalKey<FormState>(),
    );

    Future<void> handleLogin() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true; 
        final isAuthorize = await AuthServices.signInUser(
          context,
          emailController.text,
          passwordController.text,
        );
        if (!isAuthorize) {
          isLoading.value = false;
          return;
        }
        Future.delayed(const Duration(seconds: 1), () {
          simpleDoneAlert(context, "Your login successfully !!");
          context.go('/home');
          isLoading.value = true;
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height - statusbarHeight,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/login.jpg",
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.12,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      width: size.width - 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      fontFamily: 'abel',
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                const Center(
                                  child: Text(
                                    "Login to your account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        fontFamily: 'abel'),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // ------------------- Email ID -----------------------
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == "" ||
                                          value == null ||
                                          value.isEmpty) {
                                        return "Enter your mobile number";
                                      } else if (value.length != 10) {
                                        return "Enter a valid phone number";
                                      }
                                      return null;
                                    },
                                    cursorColor: Colors.black,
                                    cursorWidth: 0.8,
                                    cursorHeight: 25,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      icon: const Icon(Icons.phone),
                                      filled: false,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.2,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.2,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 0.8,
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.2,
                                        ),
                                      ),
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      label: const Text("Phone number"),
                                      labelStyle: const TextStyle(
                                        height: 0.1,
                                        color:
                                            Color.fromARGB(255, 107, 105, 105),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // ------------------- Password -----------------------
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    // horizontal: 20,
                                    vertical: 5,
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == "" ||
                                          value == null ||
                                          value.isEmpty) {
                                        return "Fill the password";
                                      }
                                      return null;
                                    },
                                    cursorColor: Colors.black,
                                    cursorWidth: 0.8,
                                    cursorHeight: 25,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    controller: passwordController,
                                    obscureText: showPass.value,
                                    decoration: InputDecoration(
                                      icon: const Icon(Icons.lock),
                                      filled: false,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.2,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.2,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 0.6,
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.2,
                                        ),
                                      ),
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      label: const Text("Password"),
                                      suffixIcon: InkWell(
                                        onTap: () =>
                                            showPass.value = !showPass.value,
                                        child: Icon(
                                          showPass.value
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      labelStyle: const TextStyle(
                                        height: 0.1,
                                        color:
                                            Color.fromARGB(255, 107, 105, 105),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),

                                // ------------------ Forget Button ------------------
                                Container(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    style: const ButtonStyle(
                                      splashFactory: InkSparkle
                                          .constantTurbulenceSeedSplashFactory,
                                    ),
                                    child: const Text(
                                      "Forget Password ?",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontFamily: 'abel',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                // ------------------ Login Button ------------------
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      primaryColor,
                                    ),
                                    padding:
                                        WidgetStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                    ),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: handleLogin,
                                  child: isLoading.value
                                      ? const SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),

                                // ------------------ Divider line ------------------
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.9,
                                          color: Color.fromARGB(
                                              255, 227, 227, 227),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          " OR ",
                                          style: TextStyle(
                                              fontFamily: 'abel',
                                              letterSpacing: 1,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  184, 106, 100, 100)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.9,
                                          color: Color.fromARGB(
                                              255, 227, 227, 227),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ------------------ Google Login Button ------------------
                                InkWell(
                                    onTap: () async {
                                      // var user = await LoginApi.login();
                                      // if (user != null) {
                                      //   // todo : add api and save user data
                                      //   Logger().d("working fine");
                                      //   Logger().d(user.toString());
                                      //   Logger().d(user.authHeaders);
                                      //   Logger().d(user.email);
                                      //   Logger().d(user.photoUrl);

                                      //   final data = await apiCall(
                                      //       query:
                                      //           "query googlelogin(\$googleLoginInput:GoogleLoginInput!){googlelogin (googleLoginInput:\$googleLoginInput){ id, token, role}} ",
                                      //       variables: {
                                      //         "googleLoginInput": {
                                      //           "email": user.email,
                                      //         }
                                      //       },
                                      //       headers: {
                                      //         "content-type": "*/*"
                                      //       });

                                      //   if (data.status) {
                                      //     await ref.watch(userState).setUser(
                                      //           data.data["signin"]["id"],
                                      //           data.data["signin"]["role"],
                                      //           data.data["signin"]["token"],
                                      //         );
                                      //     await ref
                                      //         .watch(mainState)
                                      //         .setLogin(true);
                                      //     if (!context.mounted) return;
                                      //     context.go("/home");
                                      //   } else {
                                      //     var snackBar = SnackBar(
                                      //       content: Text(
                                      //         data.message,
                                      //         textScaler:
                                      //             const TextScaler.linear(1),
                                      //         textAlign: TextAlign.center,
                                      //         style: const TextStyle(
                                      //           color: Colors.white,
                                      //           fontSize: 16,
                                      //         ),
                                      //       ),
                                      //       backgroundColor: Colors.redAccent,
                                      //     );
                                      //     if (context.mounted) {
                                      //       ScaffoldMessenger.of(context)
                                      //           .showSnackBar(snackBar);
                                      //     }
                                      //   }
                                      // }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 241, 237, 237),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/google_logo.png',
                                            width: 35,
                                            height: 35,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Text(
                                            "Login With Google",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),

                                // ------------------ Register Button ------------------
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Start Trading?",
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.go("/login/register");
                                      },
                                      child: const Text(
                                        "Register",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
