import 'package:flutter/material.dart';
import 'package:haqmate/features/auth/widget/custom_input.dart';
import '../../../core/constants.dart';
import '../widget/glass_card.dart';
import '../../../core/app_router.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final location = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  image: AssetImage("assets/images/teff.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.25,
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 27,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomInput(label: "Name", controller: name),
                  const SizedBox(height: 15),

                  CustomInput(label: "Email", controller: email),
                  const SizedBox(height: 15),

                  CustomInput(label: "Phone", controller: phone),
                  const SizedBox(height: 15),

                  CustomInput(label: "Location", controller: location),
                  const SizedBox(height: 15),

                  CustomInput(
                    label: "Password",
                    controller: password,
                    isPassword: true,
                  ),
                  const SizedBox(height: 15),

                  CustomInput(
                    label: "Confirm Password",
                    controller: confirmPassword,
                    isPassword: true,
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 40,
                      ),
                      child: Text(
                        "Sign Up",
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
                        AppRouter.animatedRoute(LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
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
