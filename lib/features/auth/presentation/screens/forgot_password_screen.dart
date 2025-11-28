/// Forgot password screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';

/// Forgot password screen widget
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final success = await ref
        .read(authStateProvider.notifier)
        .forgotPassword(_emailController.text.trim());

    setState(() {
      _isLoading = false;
      _emailSent = success;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent! Check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UIConstants.paddingLG),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: UIConstants.maxFormWidth),
              child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(
            Icons.lock_reset,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: UIConstants.paddingMD),

          // Title
          Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.paddingSM),
          Text(
            "No worries! Enter your email and we'll send you a reset link.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.paddingXL),

          // Email field
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: UIConstants.paddingLG),

          // Submit button
          CustomButton(
            onPressed: _isLoading ? null : _handleForgotPassword,
            isLoading: _isLoading,
            text: 'Send Reset Link',
          ),
          const SizedBox(height: UIConstants.paddingMD),

          // Back to login
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read,
            size: 48,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: UIConstants.paddingLG),

        // Title
        Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: UIConstants.paddingSM),
        Text(
          "We've sent a password reset link to\n${_emailController.text.trim()}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: UIConstants.paddingXL),

        // Resend button
        OutlinedButton(
          onPressed: _isLoading ? null : _handleForgotPassword,
          child: Text(_isLoading ? 'Sending...' : 'Resend Email'),
        ),
        const SizedBox(height: UIConstants.paddingMD),

        // Back to login
        CustomButton(
          onPressed: () => context.go(RoutePaths.login),
          text: 'Back to Login',
        ),
      ],
    );
  }
}
