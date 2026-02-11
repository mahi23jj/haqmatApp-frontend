import 'package:flutter/material.dart';
import 'dart:async';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/loading_state.dart';
import 'package:haqmate/features/auth/view/login_screen.dart';
import 'package:haqmate/features/profile/model/profile_model.dart';
import 'package:haqmate/features/profile/view/change_password.dart';
import 'package:haqmate/features/profile/view_model/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'about_us_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: Padding(
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
          title: const Text(
            'መገለጫ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        body: const _ProfileBody(),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    // Handle all loading and error states
    if (viewModel.isLoading && viewModel.profile == null) {
      return const LoadingState();
    }

    if (viewModel.errorMessage.isNotEmpty && viewModel.profile == null) {
      return _ErrorState(
        message: viewModel.errorMessage,
        onRetry: viewModel.loadProfile,
      );
    }

    if (viewModel.profile == null) {
      return _EmptyState(onReload: viewModel.loadProfile);
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadProfile,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(viewModel: viewModel),
            const SizedBox(height: 32),
            _ProfileInformation(viewModel: viewModel),
            const SizedBox(height: 32),
            _ProfileActions(viewModel: viewModel),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({Key? key, required this.message, required this.onRetry})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              'ስህተት ተከስቷል',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontFamily: 'Ethiopia',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'እንደገና ሞክር',
                style: TextStyle(color: Colors.white, fontFamily: 'Ethiopia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onReload;

  const _EmptyState({Key? key, required this.onReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              color: AppColors.textLight.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'መገለጫ መረጃ አልተገኘም',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                fontFamily: 'Ethiopia',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'እባክዎ እንደገና ይሞክሩ',
              style: TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onReload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'እንደገና ጫን',
                style: TextStyle(color: Colors.white, fontFamily: 'Ethiopia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileViewModel viewModel;

  const _ProfileHeader({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                viewModel.profile?.nameInitials ?? 'አ',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Ethiopia',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.profile?.name ?? 'የተጠቃሚ ስም',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Ethiopia',
            ),
          ),
          Text(
            viewModel.profile?.email ?? 'user@example.com',
            style: const TextStyle(fontSize: 16, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

class _ProfileInformation extends StatelessWidget {
  final ProfileViewModel viewModel;

  const _ProfileInformation({Key? key, required this.viewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = viewModel.profile!;
    final isEditing = viewModel.isEditing;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'የግል መረጃ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Ethiopia',
                ),
              ),
              if (!isEditing)
                IconButton(
                  onPressed: viewModel.startEditing,
                  icon: Icon(Icons.edit, color: AppColors.primary),
                  tooltip: 'መገለጫ አርትዕ',
                ),
            ],
          ),
          const Divider(height: 32),

          _ProfileField(
            label: 'ሙሉ ስም',
            value: profile.name,
            isEditing: isEditing,
            icon: Icons.person,
            onChanged: (value) => viewModel.updateField('name', value),
          ),

          const SizedBox(height: 20),

          _ProfileField(
            label: 'ኢሜይል አድራሻ',
            value: profile.email,
            isEditing: false, // Email cannot be edited
            icon: Icons.email,
            onChanged: (value) => viewModel.updateField('email', value),
          ),

          const SizedBox(height: 20),

          _ProfileField(
            label: 'ስልክ ቁጥር',
            value: profile.phone,
            isEditing: isEditing,
            icon: Icons.phone,
            onChanged: (value) => viewModel.updateField('phone', value),
          ),

          const SizedBox(height: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  const Text(
                    'አድራሻ',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Ethiopia',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (isEditing) ...[
                TextField(
                  controller: viewModel.locationController,
                  decoration: InputDecoration(
                    hintText: 'አድራሻ ይፈልጉ...',
                    hintStyle: const TextStyle(fontFamily: 'Ethiopia'),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: viewModel.loadingSuggestions
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                  onChanged: viewModel.searchLocations,
                ),
                if (viewModel.suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 150),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: viewModel.suggestions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, idx) {
                        final loc = viewModel.suggestions[idx];
                        return ListTile(
                          title: Text(loc.name),
                          // subtitle: Text('የመላኪያ ክፍያ: ${loc.deliveryFee} ብር'),
                          onTap: () => viewModel.selectLocation(loc),
                        );
                      },
                    ),
                  ),
              ] else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    profile.address.name,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),

          if (isEditing) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      viewModel.cancelEditing();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: AppColors.textLight.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ሰርዝ',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontFamily: 'Ethiopia',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: viewModel.isSaving
                        ? null
                        : () async {
                            final success = await viewModel.saveProfile();
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('መገለጫዎ በተሳካ ሁኔታ ተሻሽሏል!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: viewModel.isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'ለውጦችን አስቀምጥ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ethiopia',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditing;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _ProfileField({
    Key? key,
    required this.label,
    required this.value,
    required this.isEditing,
    required this.icon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Ethiopia',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        isEditing
            ? TextFormField(
                initialValue: value,
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value.isNotEmpty ? value : 'የለም',
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                  ),
                ),
              ),
      ],
    );
  }
}

class _ProfileActions extends StatelessWidget {
  final ProfileViewModel viewModel;

  const _ProfileActions({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _ActionButton(
            icon: Icons.lock_reset,
            title: 'የይለፍ ቃል ለውጥ',
            color: AppColors.secondary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordView(
                    userEmail: viewModel.profile?.email ?? '',
                  ),
                ),
              );
            },
          ),
          const Divider(height: 32),
          _ActionButton(
            icon: Icons.info_outline,
            title: 'ስለ እኛ',
            color: AppColors.accent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsView()),
              );
            },
          ),
          const Divider(height: 32),
          _ActionButton(
            icon: Icons.logout,
            title: 'ውጣ',
            color: Colors.red,
            onTap: () {
              _showLogoutDialog(context, viewModel);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ውጣ', style: TextStyle(fontFamily: 'Ethiopia')),
        content: const Text('እርግጠኛ ነህ መውጣት ትፈልጋለህ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'ሰርዝ',
              style: TextStyle(
                color: AppColors.textLight,
                fontFamily: 'Ethiopia',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'ውጣ',
              style: TextStyle(color: Colors.white, fontFamily: 'Ethiopia'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
          fontFamily: 'Ethiopia',
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      contentPadding: EdgeInsets.zero,
    );
  }
}

// Updated Change Password View in Amharic
class ChangePasswordView extends StatefulWidget {
  final String userEmail;

  const ChangePasswordView({Key? key, required this.userEmail})
    : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userEmail;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'የይለፍ ቃል ለውጥ',
          style: TextStyle(fontFamily: 'Ethiopia'),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'መለያዎን ይከልሱ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Ethiopia',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ማረጋገጫ ኮድ ለመቀበል ኢሜይልዎን ያስገቡ',
                style: TextStyle(fontSize: 16, color: AppColors.textLight),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'ኢሜይል አድራሻ',
                  labelStyle: const TextStyle(fontFamily: 'Ethiopia'),
                  prefixIcon: Icon(Icons.email, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'እባክዎ ኢሜይልዎን ያስገቡ';
                  }
                  if (!value.contains('@')) {
                    return 'ትክክለኛ ኢሜይል ያስገቡ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await viewModel.sendPasswordResetCode(
                                _emailController.text.trim(),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ማረጋገጫ ኮድ ወደ ኢሜይልዎ ተልኳል'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangePasswordCodeView(
                                    email: _emailController.text.trim(),
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('ኮድ መላክ አልተሳካም: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'ማረጋገጫ ኮድ ላክ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ethiopia',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordCodeView extends StatefulWidget {
  final String email;

  const ChangePasswordCodeView({Key? key, required this.email})
    : super(key: key);

  @override
  State<ChangePasswordCodeView> createState() => _ChangePasswordCodeViewState();
}

class _ChangePasswordCodeViewState extends State<ChangePasswordCodeView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  int _resendSeconds = 60;
  bool _canResend = false;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
        if (mounted) setState(() => _canResend = true);
      } else {
        if (mounted) {
          setState(() => _resendSeconds--);
        } else {
          timer.cancel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ማረጋገጫ ኮድ', style: TextStyle(fontFamily: 'Ethiopia')),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'ኮድ ያስገቡ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Ethiopia',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ወደ ${widget.email} የተላከውን ኮድ ያስገቡ',
                style: TextStyle(fontSize: 16, color: AppColors.textLight),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'ማረጋገጫ ኮድ',
                  labelStyle: const TextStyle(fontFamily: 'Ethiopia'),
                  prefixIcon: Icon(Icons.code, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'እባክዎ ማረጋገጫ ኮድ ያስገቡ';
                  }
                  if (value.length != 6) {
                    return 'ኮድ 6 አሃዝ መሆን አለበት';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await viewModel.verifyOtp(
                              widget.email.trim(),
                              _codeController.text.trim(),
                            );

                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ኮድ በተሳካ ሁኔታ ተረጋግጧል'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangePasswordNewPasswordView(
                                    email: widget.email.trim(),
                                    code: _codeController.text.trim(),
                                  ),
                                ),
                              );
                            } else if (context.mounted &&
                                viewModel.errorMessage.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.errorMessage),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'ኮድ አረጋግጥ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ethiopia',
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                await viewModel.sendPasswordResetCode(
                                  widget.email.trim(),
                                );
                                _startResendTimer();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("ማረጋገጫ ኮድ እንደገና ተልኳል"),
                                    ),
                                  );
                                }
                              },
                        child: const Text(
                          "ኮድ እንደገና ላክ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Ethiopia',
                          ),
                        ),
                      )
                    : Text(
                        "እንደገና ለመላክ በ $_resendSeconds ሰከንድ ይጠብቁ",
                        style: const TextStyle(color: Colors.grey),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordNewPasswordView extends StatefulWidget {
  final String email;
  final String code;

  const ChangePasswordNewPasswordView({
    Key? key,
    required this.email,
    required this.code,
  }) : super(key: key);

  @override
  State<ChangePasswordNewPasswordView> createState() =>
      _ChangePasswordNewPasswordViewState();
}

class _ChangePasswordNewPasswordViewState
    extends State<ChangePasswordNewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'አዲስ የይለፍ ቃል',
          style: TextStyle(fontFamily: 'Ethiopia'),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'አዲስ የይለፍ ቃል ያስገቡ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Ethiopia',
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'አዲስ የይለፍ ቃል',
                  labelStyle: const TextStyle(fontFamily: 'Ethiopia'),
                  prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'እባክዎ አዲስ የይለፍ ቃል ያስገቡ';
                  }
                  if (value.length < 6) {
                    return 'የይለፍ ቃል ቢያንስ 6 ቁምፊ መሆን አለበት';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'አዲሱን የይለፍ ቃል ያረጋግጡ',
                  labelStyle: const TextStyle(fontFamily: 'Ethiopia'),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _confirmPasswordVisible = !_confirmPasswordVisible,
                      );
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'እባክዎ የይለፍ ቃልዎን ያረጋግጡ';
                  }
                  if (value != _newPasswordController.text) {
                    return 'የይለፍ ቃሎች አንድ ዓይነት አይደሉም';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final request = ChangePasswordRequest(
                              email: widget.email.trim(),
                              code: widget.code.trim(),
                              newPassword: _newPasswordController.text,
                            );

                            final success = await viewModel.changePassword(
                              request,
                            );
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('የይለፍ ቃል በተሳካ ሁኔታ ተቀይሯል!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'የይለፍ ቃል ቀይር',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ethiopia',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated About Us View in Amharic
class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ስለ እኛ', style: TextStyle(fontFamily: 'Ethiopia')),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.business,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),

            _SectionCard(
              icon: Icons.history,
              title: 'የእኛ ታሪክ',
              content:
                  'በ 2024 ዓ.ም የተመሠረተው የእኛ ኩባንያ ቀላል አስተሳሰብ ያለው ነበር፡ ግለሰቦችን እና ንግዶችን የሚችሉ ትርጉም ያላቸውን መፍትሄዎች መፍጠር። ከትርፋማ አጀማመር እስከ የሥራ መስክ መሪ መሆን ድረስ ጉዞዎችን አድናቂነት፣ ቁርጠኝነት እና ለብቃት ቁርጠኝነት ተነሳሽነት አድርጓል።',
            ),
            const SizedBox(height: 24),

            _SectionCard(
              icon: Icons.flag,
              title: 'የእኛ ተልዕኮ',
              content:
                  'ሰዎች ከቴክኖሎጂ ጋር የሚገናኙበትን መንገድ ማለወጥ ቀላል፣ ደህንነቱ የተጠበቀ እና ኃይለኛ መፍትሄዎችን በማቅረብ የዕለት ተዕለት ተግባራትን ለማቃለል እና ምርታማነትን ለማሳደግ። መስፈርቶችን ብቻ ሳይሆን ከጠበቀው በላይ የሚሰጡ መሳሪያዎችን መፍጠር እናምናለን።',
            ),
            const SizedBox(height: 24),

            _SectionCard(
              icon: Icons.star,
              title: 'የእኛ እሴቶች',
              children: [
                _ValueItem(
                  icon: Icons.security,
                  title: 'ደህንነት',
                  description: 'የእርስዎ ውሂብ ጥበቃ የእኛ ከፍተኛ ቅድሚያ ነው።',
                ),
                _ValueItem(
                  icon: Icons.people,
                  title: 'ማህበረሰብ',
                  description: 'ከተጠቃሚዎቻችን ጋር በጋራ መገንባት',
                ),
                _ValueItem(
                  icon: Icons.thumb_up,
                  title: 'ብቃት',
                  description: 'ሁሉንም ነገር ለማሳካት መሞከር',
                ),
              ],
            ),
            const SizedBox(height: 24),

            _SectionCard(
              icon: Icons.contact_mail,
              title: 'አግኙን',
              children: [
                _ContactItem(
                  icon: Icons.email,
                  title: 'ኢሜይል',
                  value: 'ድጋፍ@ኩባንያ.com',
                  onTap: () => _launchEmail('support@company.com'),
                ),
                _ContactItem(
                  icon: Icons.phone,
                  title: 'ስልክ',
                  value: '+251 911 234 567',
                  onTap: () => _launchPhone('+251911234567'),
                ),
                _ContactItem(
                  icon: Icons.location_on,
                  title: 'አድራሻ',
                  value: '123 አድጋ ድሪቭ\nአዲስ አበባ, ኢትዮጵያ',
                ),
              ],
            ),
            const SizedBox(height: 24),

            _SectionCard(
              icon: Icons.developer_mode,
              title: 'ስለ አበልጻጊው',
              content:
                  'ይህ መተግበሪያ ውብ እና ግብረገብ የሆኑ የሞባይል ልምዶችን ለመፍጠር የተለየ የሆኑ የ Flutter አበልጻጊዎች ቡድን አዘጋጀው። በዘመናዊ UI/UX ዲዛይን፣ ንጹህ አርክቴክቸር እና ጠንካራ የበኋላ ማቀፊያ ውህደት እንጠቀማለን።',
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'የመተግበሪያ ስሪት',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1.0.0 • ግንባታ 2024.12.01',
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) {
    // Implement email launch
  }

  void _launchPhone(String phone) {
    // Implement phone launch
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final List<Widget>? children;

  const _SectionCard({
    Key? key,
    required this.icon,
    required this.title,
    this.content,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Ethiopia',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (content != null)
            Text(
              content!,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textLight,
              ),
            ),
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

class _ValueItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ValueItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontFamily: 'Ethiopia',
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: AppColors.textLight, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _ContactItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      fontFamily: 'Ethiopia',
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
