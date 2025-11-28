/// Social auth buttons widget
library;

import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/constants/app_constants.dart';

/// Social authentication buttons
class SocialAuthButtons extends StatelessWidget {
  final List<SocialAuthProvider> providers;
  final void Function(SocialAuthProvider provider) onProviderPressed;
  final bool isLoading;

  const SocialAuthButtons({
    super.key,
    required this.providers,
    required this.onProviderPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: UIConstants.paddingSM,
      runSpacing: UIConstants.paddingSM,
      children: providers.map((provider) {
        return _SocialButton(
          provider: provider,
          onPressed: isLoading ? null : () => onProviderPressed(provider),
        );
      }).toList(),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final SocialAuthProvider provider;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.provider,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(UIConstants.radiusMD),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          _getProviderIcon(),
          size: 24,
          color: _getProviderColor(),
        ),
        tooltip: 'Sign in with ${_getProviderName()}',
      ),
    );
  }

  IconData _getProviderIcon() {
    switch (provider) {
      case SocialAuthProvider.google:
        return Icons.g_mobiledata; // Using Material icon as placeholder
      case SocialAuthProvider.apple:
        return Icons.apple;
      case SocialAuthProvider.facebook:
        return Icons.facebook;
      case SocialAuthProvider.twitter:
        return Icons.alternate_email; // X icon placeholder
      case SocialAuthProvider.github:
        return Icons.code; // GitHub icon placeholder
    }
  }

  Color _getProviderColor() {
    switch (provider) {
      case SocialAuthProvider.google:
        return Colors.red;
      case SocialAuthProvider.apple:
        return Colors.black;
      case SocialAuthProvider.facebook:
        return const Color(0xFF1877F2);
      case SocialAuthProvider.twitter:
        return Colors.black;
      case SocialAuthProvider.github:
        return Colors.black;
    }
  }

  String _getProviderName() {
    switch (provider) {
      case SocialAuthProvider.google:
        return 'Google';
      case SocialAuthProvider.apple:
        return 'Apple';
      case SocialAuthProvider.facebook:
        return 'Facebook';
      case SocialAuthProvider.twitter:
        return 'X (Twitter)';
      case SocialAuthProvider.github:
        return 'GitHub';
    }
  }
}

/// Full-width social auth button
class SocialAuthFullButton extends StatelessWidget {
  final SocialAuthProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialAuthFullButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.paddingMD,
          vertical: UIConstants.paddingMD,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(_getProviderIcon(), color: _getProviderColor()),
          const SizedBox(width: UIConstants.paddingSM),
          Text('Continue with ${_getProviderName()}'),
        ],
      ),
    );
  }

  IconData _getProviderIcon() {
    switch (provider) {
      case SocialAuthProvider.google:
        return Icons.g_mobiledata;
      case SocialAuthProvider.apple:
        return Icons.apple;
      case SocialAuthProvider.facebook:
        return Icons.facebook;
      case SocialAuthProvider.twitter:
        return Icons.alternate_email;
      case SocialAuthProvider.github:
        return Icons.code;
    }
  }

  Color _getProviderColor() {
    switch (provider) {
      case SocialAuthProvider.google:
        return Colors.red;
      case SocialAuthProvider.apple:
        return Colors.black;
      case SocialAuthProvider.facebook:
        return const Color(0xFF1877F2);
      case SocialAuthProvider.twitter:
        return Colors.black;
      case SocialAuthProvider.github:
        return Colors.black;
    }
  }

  String _getProviderName() {
    switch (provider) {
      case SocialAuthProvider.google:
        return 'Google';
      case SocialAuthProvider.apple:
        return 'Apple';
      case SocialAuthProvider.facebook:
        return 'Facebook';
      case SocialAuthProvider.twitter:
        return 'X';
      case SocialAuthProvider.github:
        return 'GitHub';
    }
  }
}
