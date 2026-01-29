import 'package:flutter/material.dart';
import 'package:haqmate/core/bottom_nev_page.dart';
import 'package:haqmate/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:haqmate/features/auth/widget/custom_input.dart';
import 'package:haqmate/features/auth/widget/glass_card.dart';
import 'package:haqmate/features/home/views/home_view.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import '../../../core/constants.dart';
import '../../../core/app_router.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  String? _formError;
  bool _obscurePassword = true;

  // Helper method to translate backend errors to Amharic
  String _translateBackendError(String error) {
    final errorLower = error.toLowerCase();

    if (errorLower.contains('invalid credentials') ||
        errorLower.contains('wrong password') ||
        errorLower.contains('incorrect password')) {
      return 'ኢሜይል ወይም የይለፍ ቃል ትክክል አይደለም።';
    } else if (errorLower.contains('user not found') ||
        errorLower.contains('email not found')) {
      return 'ይህ ኢሜይል አልተመዘገበም። መለያ ይፍጠሩ።';
    } else if (errorLower.contains('network') ||
        errorLower.contains('connection') ||
        errorLower.contains('timeout')) {
      return 'የኢንተርኔት ግንኙነት ችግር አለ። እባክዎ እንደገና ይሞክሩ።';
    } else if (errorLower.contains('server error') ||
        errorLower.contains('internal error')) {
      return 'ከሰርቨር ጋር ችግር አጋጥሞታል። እባክዎ ትንሽ ቆይተው እንደገና ይሞክሩ።';
    } else if (errorLower.contains('too many requests') ||
        errorLower.contains('rate limit')) {
      return 'በጣም ብዙ ጥያቄዎች። እባክዎ ትንሽ ቆይተው እንደገና ይሞክሩ።';
    } else if (errorLower.contains('account disabled') ||
        errorLower.contains('account locked')) {
      return 'መለያዎ ተከልክሏል። እባክዎ አስተዳዳሪን ያነጋግሩ።';
    } else {
      return 'መግቢያ አልተሳካም። እባክዎ እንደገና ይሞክሩ።';
    }
  }

  Future<void> _handleLogin(AuthViewModel provider) async {
    setState(() => _formError = null);

    // Validate inputs
    if (email.text.trim().isEmpty) {
      setState(() => _formError = 'እባክዎ ኢሜይልዎን ያስገቡ።');
      return;
    }

    if (password.text.trim().isEmpty) {
      setState(() => _formError = 'እባክዎ የይለፍ ቃልዎን ያስገቡ።');
      return;
    }

    if (!email.text.contains('@') || !email.text.contains('.')) {
      setState(() => _formError = 'እባክዎ ትክክለኛ ኢሜይል ያስገቡ።');
      return;
    }

    try {
      final ok = await provider.login(email.text.trim(), password.text.trim());

      if (ok) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TeffBottomNavPage()),
          );
        }
      } else if (provider.error != null && mounted) {
        setState(() {
          _formError = _translateBackendError(provider.error!);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _formError = 'ያልተጠበቀ ስህተት ተከስቷል። እባክዎ እንደገና ይሞክሩ።';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                // image background
                image: DecorationImage(
                  image: const AssetImage('assets/images/teff.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                ),
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // App Logo and Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_basket_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ሐቅማት ጤፍ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'ከእርሻ እስከ ቤትዎ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Welcome Back Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'እንኳን በደህና መጡ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ወደ ሐቅማት ቤተሰብ እንኳን ደህና መጡ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Login Form Title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'ወደ መለያዎ ይግቡ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ኢሜይል',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: AppColors.textDark),
                        decoration: InputDecoration(
                          hintText: 'ኢሜይልዎን ያስገቡ',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(14),
                            child: Icon(
                              Icons.email_outlined,
                              color: AppColors.primary,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'የይለፍ ቃል',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: password,
                        obscureText: _obscurePassword,
                        style: TextStyle(color: AppColors.textDark),
                        decoration: InputDecoration(
                          hintText: 'የይለፍ ቃልዎን ያስገቡ',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(14),
                            child: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textLight,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'የሚረሳ የይለፍ ቃል ተግባር በቅርቡ ይመጣል',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      child: Text(
                        'የይለፍ ቃል ረሳችሁ?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Error Message Display
                  if (_formError != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _formError!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Login Button
                  Consumer<AuthViewModel>(
                    builder: (context, provider, child) {
                      // Show backend error in Amharic
                      if (provider.error != null && _formError == null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            final translatedError = _translateBackendError(
                              provider.error!,
                            );
                            setState(() {
                              _formError = translatedError;
                            });
                          }
                        });
                      }

                      return Column(
                        children: [
                          CustomButton(
                            width: double.infinity,
                            label: provider.loading ? 'በመግባት ላይ...' : 'ግባ',
                            backgroundColor: provider.loading
                                ? AppColors.textLight.withOpacity(0.5)
                                : AppColors.secondary,
                            foregroundColor: Colors.white,
                            loading: provider.loading,
                            onPressed: provider.loading
                                ? null
                                : () => _handleLogin(provider),
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            icon: provider.loading
                                ? null
                                : const Icon(
                                    Icons.login_rounded,
                                    color: Colors.white,
                                  ),
                          ),

                          // Connection hint for network errors
                          if (_formError != null &&
                              (_formError!.contains('ኢንተርኔት') ||
                                  _formError!.contains('ሰርቨር')))
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wifi_off_outlined,
                                    color: AppColors.accent,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'እባክዎ ግንኙነትዎን ያረጋግጡ',
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'ወይም',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'አዲስ ተጠቃሚ ነዎት?',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            AppRouter.animatedRoute(const SignupScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'መለያ ይፍጠሩ',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quick Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.accent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ማስታወሻ',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'የከፍተኛ ጥራት ጤፍ ሸቀጦችን ለመግዛት ይግቡ። ደህንነቱ የተጠበቀ የመስመር ላይ ግዢ።',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
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
