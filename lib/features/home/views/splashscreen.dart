import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/auth/view/login_screen.dart';
import 'package:haqmate/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:haqmate/features/home/views/home_view.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _navTimer = Timer(const Duration(seconds: 3), () {
      _navigateNext();
    });
  }

  Future<void> _navigateNext() async {
    try {
      if (!mounted) return;

      // Access AuthViewModel safely
      final authVM = Provider.of<AuthViewModel>(context, listen: false);

      // Example: check login status (replace with your method)
      final isLoggedIn = await authVM.isLoggedInSafe(); // async, null-safe

      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e, st) {
      print('Splash navigation error: $e\n$st');
      if (!mounted) return;

      // fallback to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primary,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'ሐቅማት ጤፍ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
