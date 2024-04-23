// ignore_for_file: avoid_print
import 'package:e_shop/provider/auth_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_icons/solar_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Define Variable Here
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool showPassword = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleSignIn() async {
      setState(() {
        isLoading = true;
      });
      if (await authProvider.salesLogin(
        email: emailController.text,
        password: passwordController.text,
      )) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var getData = prefs.getString("data");

        if (context.mounted) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } else {
        if (context.mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              content: Text(
                'Gagal Login!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    }

    // Bagian Header
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            // Rata Kiri
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png'),
              Text(
                'Welcome Back, Sales!',
                style: poppins.copyWith(
                  color: secondaryTextColor,
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Sign In to Continue',
                style: poppins.copyWith(
                    color: subtitleTextColor, fontWeight: regular),
                // Default ukuran flutter Fontsize : 14, Fontweight : regular
              )
            ],
          ),
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: poppins.copyWith(
                fontSize: 16,
                fontWeight: medium,
                color: subtitleTextColor,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                //Memberikan warna bg pada field
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      SolarIconsOutline.userPlus,
                      color: backgroundColor3,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    // Expanded digunakan agar form field dapat terisi penuh
                    Expanded(
                      child: Theme(
                        data: ThemeData(
                          textSelectionTheme: TextSelectionThemeData(
                            selectionColor: Colors.grey.shade200,
                          ),
                        ),
                        child: TextFormField(
                          style: poppins,
                          controller: emailController,
                          cursorColor: backgroundColor3,
                          // collapsed digunakan agar form tidak ada garis bawah
                          decoration: InputDecoration.collapsed(
                            hintText: 'Your Email Address',
                            hintStyle: poppins,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget passwordInput(bool showPasswordState) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: poppins.copyWith(
                fontSize: 16,
                fontWeight: medium,
                color: subtitleTextColor,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                //Memberikan warna bg pada field
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      SolarIconsOutline.lockPassword,
                      color: backgroundColor3,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    // Expanded digunakan agar form field dapat terisi penuh
                    Expanded(
                      child: Theme(
                        data: ThemeData(
                            textSelectionTheme: TextSelectionThemeData(
                                selectionColor: Colors.grey.shade200)),
                        child: TextFormField(
                          style: poppins,
                          controller: passwordController,
                          // obscureText digunakan untuk sensor inputan menjadi *******
                          obscureText: !showPasswordState,
                          cursorColor: backgroundColor3,
                          // collapsed digunakan agar form tidak ada garis bawah
                          decoration: InputDecoration.collapsed(
                            hintText: 'Your Password',
                            hintStyle: poppins.copyWith(
                              fontWeight: medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPassword = !showPasswordState;
                        });
                      },
                      child: Icon(
                        !showPasswordState
                            ? SolarIconsOutline.eyeClosed
                            : SolarIconsOutline.eye,
                        color: showPasswordState
                            ? backgroundColor3
                            : backgroundColor1,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget signInButton() {
      return Container(
        height: 50,
        // double.infinity digunakan agar melebar sesuai ukuran layar
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: handleSignIn,
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading == true
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Sign In',
                  style: poppins.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          // Rata Kiri
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            emailInput(),
            passwordInput(showPassword),
            signInButton(),
            // Spacer(),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
    );
  }
}
