import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../core/app_router.dart';
import '../../../core/bottom_nev_page.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../../features/cart/model/cartmodel.dart';
import '../../../features/checkout/service/checkout_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final location = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final CheckoutService _checkoutService = CheckoutService();

  List<LocationModel> _suggestions = [];
  bool _loadingSuggestions = false;
  Timer? _debounce;

  String _fullPhoneNumber = '';
  String? _formError;
  String locationId = '';

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    location.dispose();
    password.dispose();
    confirmPassword.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /* ---------------- PASSWORD RULE ---------------- */
  // bool _isPasswordValid(String password) {
  //   final regex = RegExp(
  //     r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
  //   );
  //   return regex.hasMatch(password);
  // }

  bool _isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(password);
  }

  /* ---------------- LOCATION SEARCH ---------------- */
  void _selectLocation(LocationModel loc) {
    location.text = loc.name;
    locationId = loc.id;
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
  }

  void _searchLocations(String query) {
    _debounce?.cancel();

    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      setState(() => _loadingSuggestions = true);
      try {
        final results = await _checkoutService.searchLocations(query);
        if (!mounted) return;
        setState(() => _suggestions = results);
      } catch (_) {
        if (!mounted) return;
        setState(() => _suggestions = []);
      }
      if (!mounted) return;
      setState(() => _loadingSuggestions = false);
    });
  }

  String _translateBackendError(String error) {
    final errorLower = error.toLowerCase();

    final errorMap = {
      'email already exists': 'ይህ ኢሜይል ቀደም ብሎ ተመዝግቧል።',
      'invalid email': 'እባክዎ ትክክለኛ ኢሜይል ያስገቡ።',
      'weak password': 'የይለፍ ቃልዎ በቂ ጠንካራ አይደለም።',
      'network error': 'የኢንተርኔት ግንኙነት ችግር አለ።',
      'server error': 'ከሰርቨር ጋር ችግር አጋጥሞታል።',
      'phone number exists': 'ይህ ስልክ ቁጥር ቀደም ብሎ ተመዝግቧል።',
    };

    for (final entry in errorMap.entries) {
      if (errorLower.contains(entry.key)) {
        return entry.value;
      }
    }

    return 'ምዝገባ አልተሳካም። እባክዎ እንደገና ይሞክሩ።';
  }

  /* ---------------- SIGNUP HANDLER ---------------- */
  Future<void> _handleSignup(AuthViewModel provider) async {
    setState(() => _formError = null);

    if (name.text.trim().isEmpty) {
      setState(() => _formError = 'እባክዎ ስምዎን ያስገቡ');
      return;
    }

    if (_fullPhoneNumber.isEmpty ||
        !_fullPhoneNumber.startsWith('+251') ||
        _fullPhoneNumber.replaceAll('+251', '').length != 9) {
      setState(() => _formError = 'ስልክ ቁጥር 9 አሃዞች መሆን አለበት');
      return;
    }

    if (!_isPasswordValid(password.text)) {
      setState(
        () => _formError =
            'የይለፍ ቃል ቢያንስ 1 አነስተኛ ፊደል፣ 1 አቢይ ፊደል፣ 1 ቁጥር ማካተት እና 8+ ቁምፊዎች መሆን አለበት',
      );
      return;
    }

    if (password.text != confirmPassword.text) {
      setState(() => _formError = 'የይለፍ ቃላቶች አይዛመዱም');
      return;
    }

    final ok = await provider.signup(
      email.text.trim(),
      password.text,
      name.text.trim(),
      locationId,
      _fullPhoneNumber,
    );

    if (ok && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TeffBottomNavPage()),
      );
    }
  }

  /* ---------------- UI ---------------- */
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
                  const SizedBox(height: 20),
                  // App Logo and Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/logo2.png',
                            height: 60,
                            width: 60,
                          ),
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
                  // Welcome Section
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
                          'እንኳን ደህና መጡ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ወደ አጠቃላይ ጤፍ ሸቀጣ ሸቀጥ ማዕከላችን ይግቡ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  const SizedBox(height: 10),
                  // Registration Form Title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'መለያ ይፍጠሩ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                  // Name Field
                  _InputField(
                    label: "ሙሉ ስም",
                    hintText: "ስምዎን ያስገቡ",
                    controller: name,
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _InputField(
                    label: "ኢሜይል",
                    hintText: "ኢሜይልዎን ያስገቡ",
                    controller: email,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IntlPhoneField(
                      initialCountryCode: 'ET',
                      flagsButtonPadding: const EdgeInsets.only(left: 12),
                      style: TextStyle(color: AppColors.textDark),
                      decoration: InputDecoration(
                        labelText: 'ስልክ ቁጥር',
                        labelStyle: TextStyle(color: AppColors.textLight),
                        hintText: '9XXXXXXXX',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(14),
                          child: Icon(
                            Icons.phone_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      onChanged: (phone) {
                        _fullPhoneNumber = phone.completeNumber;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: location,
                        decoration: InputDecoration(
                          labelText: 'አድራሻ',
                          labelStyle: TextStyle(color: AppColors.textLight),
                          hintText: 'ከተማ ወይም አካባቢ ይፈልጉ',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(14),
                            child: Icon(
                              Icons.location_on_outlined,
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
                          suffixIcon: _loadingSuggestions
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        onChanged: _searchLocations,
                      ),

                      if (_suggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          constraints: const BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            itemCount: _suggestions.length,
                            shrinkWrap: true,
                            itemBuilder: (_, i) {
                              final loc = _suggestions[i];
                              return Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.place_outlined,
                                    color: AppColors.primary,
                                  ),
                                  title: Text(
                                    loc.name,
                                    style: TextStyle(color: AppColors.textDark),
                                  ),
                                  onTap: () => _selectLocation(loc),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  _InputField(
                    label: "የይለፍ ቃል",
                    hintText: "የይለፍ ቃልዎን ያስገቡ",
                    controller: password,
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  _InputField(
                    label: "የይለፍ ቃል አረጋግጥ",
                    hintText: "የይለፍ ቃልዎን እንደገና ያስገቡ",
                    controller: confirmPassword,
                    icon: Icons.lock_reset_outlined,
                    isPassword: true,
                  ),

                  const SizedBox(height: 24),

                  // Error Message
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

                  // Sign Up Button
                  Consumer<AuthViewModel>(
                    builder: (_, provider, __) {
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

                      return CustomButton(
                        width: double.infinity,
                        label: provider.loading ? 'በመጫን ላይ...' : 'መለያ ይፍጠሩ',
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        loading: provider.loading,
                        onPressed: provider.loading
                            ? null
                            : () => _handleSignup(provider),
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                        icon: provider.loading
                            ? null
                            : const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
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

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'አስቀድመው መለያ አለዎት?',
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
                            AppRouter.animatedRoute(LoginScreen()),
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
                              'ግባ',
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

                  // Terms and Conditions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Text(
                      'በመመዝገብዎ የእኛን የአገልግሎት ውሎች እና የግላዊነት ፖሊሲ እንደምትስማሙ ተቀባይነት ያሳያሉ።',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
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

/* ---------------- MODERN INPUT FIELD WIDGET ---------------- */
class _InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          style: TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Container(
              padding: const EdgeInsets.all(14),
              child: Icon(widget.icon, color: AppColors.primary),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textLight,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
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
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
