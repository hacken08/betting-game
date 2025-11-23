import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    final size = MediaQuery.of(context).size;

    var usernameController = useTextEditingController();
    var emailController = useTextEditingController();
    var passwordController = useTextEditingController();
    var phoneNumberController = useTextEditingController();

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());
    ValueNotifier<bool> showPass = useState<bool>(true);

    Future<void> handleSignUp() async {
      if (formKey.currentState!.validate()) {
        final isSignUp = await AuthServices.signUpUser(
            context,
            usernameController.text,
            emailController.text,
            passwordController.text,
            phoneNumberController.text);
        if (!isSignUp) return;
        simpleDoneAlert(
          context,
          "Account has been registerd, please login to proceed",
        );
        context.go("/login");
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height - statusbarHeight,
            child: Stack(
              fit: StackFit.expand,
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
                  bottom: size.height * 0.13,
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
                        children: [
                          Form(
                            key: formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ----------------------- Heading -----------------------
                                  const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                        fontFamily: 'abel'),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),

                                  const Text(
                                    "Enter deatils and create your account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        fontFamily: 'abel'),
                                  ),
                                  const SizedBox(height: 25),

                                  // -------------username-----------------
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
                                          return "Username your email";
                                        } else if (value.length < 3) {
                                          return "Username should be longer then 3 character.";
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
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        icon: const SizedBox(
                                          width: 40,
                                          height: 20,
                                          child: Icon(
                                            Icons.person_outline,
                                            color: Colors.black,
                                          ),
                                        ),
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
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 0.7,
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
                                        label: const Text("Username"),
                                        labelStyle: const TextStyle(
                                          height: 0.1,
                                          color: Color.fromARGB(
                                              255, 107, 105, 105),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // -------------Mobile Number-----------------
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
                                          return "Enter phone number";
                                        } else if (int.tryParse(value) ==
                                            null) {
                                          return "Phone number is not valid";
                                        } else if (value.length != 10) {
                                          return "phone is not 10 character long.";
                                        }
                                        return null;
                                      },
                                      cursorColor: Colors.black,
                                      cursorWidth: 0.8,
                                      cursorHeight: 25,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                      controller: phoneNumberController,
                                      decoration: InputDecoration(
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: const SizedBox(
                                            width: 34,
                                            height: 20,
                                            child: Text("+91",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                        ),
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
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 0.7,
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
                                          color: Color.fromARGB(
                                              255, 107, 105, 105),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // ------------------- Email ID -----------------------
                                  TextFormField(
                                    validator: (value) {
                                      if (value == "" ||
                                          value == null ||
                                          value.isEmpty) {
                                        return "Enter your email";
                                      } else if (!validateEmail(value)) {
                                        return "Enter a valid email";
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
                                      icon: const SizedBox(
                                        width: 40,
                                        height: 20,
                                        child: Icon(
                                          Icons.mail_outline,
                                          color: Colors.black,
                                        ),
                                      ),
                                      filled: false,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.2,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 0.2,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade700,
                                          width: 0.7,
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
                                      label: const Text("Email ID"),
                                      labelStyle: const TextStyle(
                                        height: 0.1,
                                        color:
                                            Color.fromARGB(255, 107, 105, 105),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // ----------------------- Password -----------------------
                                  TextFormField(
                                    validator: validatePassword,
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
                                      icon: const SizedBox(
                                        width: 40,
                                        height: 20,
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: Colors.black,
                                        ),
                                      ),
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
                                  const SizedBox(
                                    height: 40,
                                  ),

                                  // ----------------------- SignUp Buton -----------------------

                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                        const Color(0xff402633),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: () => handleSignUp(),
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),

                                  // ----------------------- LogIn Button -----------------------
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Already have account?",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async => context.pop(),
                                        child: const Text(
                                          "Log In",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),

                                  // ----------------------- Term & Conditions -----------------------
                                  const Center(
                                    child: Text(
                                      "By Signing Up, Your're agree to our",
                                      textScaler: TextScaler.linear(1),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(
                                              255, 107, 104, 104)),
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      "Term & Conditions",
                                      textScaler: TextScaler.linear(1),
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
