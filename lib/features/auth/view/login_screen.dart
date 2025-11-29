import 'package:flutter/material.dart';
import 'package:haqmate/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:haqmate/features/auth/widget/custom_input.dart';
import 'package:haqmate/features/auth/widget/glass_card.dart';
import 'package:haqmate/features/home/views/home_view.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/app_router.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(seconds: 1),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/injera.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.25,
                ),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 20),
                  CustomInput(label: "Email", controller: email),
                  const SizedBox(height: 15),
                  CustomInput(
                    label: "Password",
                    controller: password,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final value = await provider.login(
                        email.text,
                        password.text,
                      );
                      if (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeView()),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 50,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        AppRouter.animatedRoute(SignupScreen()),
                      );
                    },
                    child: const Text(
                      "Create an account",
                      style: TextStyle(color: AppColors.primary),
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
}
