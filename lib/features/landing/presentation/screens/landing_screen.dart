/// Landing page screen
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../tiers/domain/tier_definitions.dart';

/// Landing page for unauthenticated users
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _LandingHeader(),
            _HeroSection(),
            _FeaturesSection(),
            _PricingSection(),
            _CTASection(),
            _FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _LandingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < UIConstants.breakpointTablet;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingLG,
        vertical: UIConstants.paddingMD,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Icon(
                Icons.rocket_launch,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
              const SizedBox(width: UIConstants.paddingSM),
              Text(
                AppConfig.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),

          // Auth buttons
          Row(
            children: [
              if (!isMobile)
                TextButton(
                  onPressed: () => context.push(RoutePaths.login),
                  child: const Text('Sign In'),
                ),
              const SizedBox(width: UIConstants.paddingSM),
              CustomButton(
                onPressed: () => context.push(RoutePaths.signup),
                text: isMobile ? 'Start' : 'Get Started',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingLG,
        vertical: UIConstants.paddingXXL,
      ),
      child: Column(
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.paddingMD,
              vertical: UIConstants.paddingXS,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(UIConstants.radiusRound),
            ),
            child: Text(
              '🚀 Now in Beta',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: UIConstants.paddingLG),

          // Title
          Text(
            'Build Your SaaS\nFaster Than Ever',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.paddingMD),

          // Subtitle
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'FluttnBoil is a comprehensive Flutter SaaS boilerplate with authentication, subscription management, and everything you need to launch your product.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: UIConstants.paddingXL),

          // CTA Buttons
          Wrap(
            spacing: UIConstants.paddingMD,
            runSpacing: UIConstants.paddingMD,
            alignment: WrapAlignment.center,
            children: [
              CustomButton(
                onPressed: () => context.push(RoutePaths.signup),
                text: 'Start Free Trial',
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.paddingXL,
                  vertical: UIConstants.paddingMD,
                ),
              ),
              SecondaryButton(
                onPressed: () => context.push(RoutePaths.login),
                text: 'View Demo',
                icon: Icons.play_circle_outline,
              ),
            ],
          ),
          const SizedBox(height: UIConstants.paddingXL),

          // Demo preview placeholder
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIConstants.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(UIConstants.radiusLG),
              child: Container(
                height: 400,
                color: Colors.grey.shade200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard,
                        size: 64,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: UIConstants.paddingMD),
                      Text(
                        'Dashboard Preview',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      _Feature(
        icon: Icons.lock_outline,
        title: 'Authentication',
        description: 'Email, social login, password reset - all built-in and ready to use.',
      ),
      _Feature(
        icon: Icons.credit_card,
        title: 'Stripe Subscriptions',
        description: 'Integrated payment processing with subscription management.',
      ),
      _Feature(
        icon: Icons.admin_panel_settings,
        title: 'RBAC & Tiers',
        description: 'Role-based access control with free, pro, and enterprise tiers.',
      ),
      _Feature(
        icon: Icons.architecture,
        title: 'Clean Architecture',
        description: 'Well-organized codebase following best practices.',
      ),
      _Feature(
        icon: Icons.route,
        title: 'GoRouter',
        description: 'Declarative routing with guards and deep linking.',
      ),
      _Feature(
        icon: Icons.widgets,
        title: 'Reusable Components',
        description: 'Beautiful, customizable UI components ready to use.',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingLG,
        vertical: UIConstants.paddingXXL,
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Text(
            'Everything You Need',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: UIConstants.paddingSM),
          Text(
            'All the features to build your SaaS faster',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: UIConstants.paddingXL),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: UIConstants.maxContentWidth),
            child: Wrap(
              spacing: UIConstants.paddingLG,
              runSpacing: UIConstants.paddingLG,
              alignment: WrapAlignment.center,
              children: features.map((f) => _FeatureCard(feature: f)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;

  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(UIConstants.paddingLG),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(UIConstants.paddingSM),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(UIConstants.radiusMD),
            ),
            child: Icon(
              feature.icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: UIConstants.paddingMD),
          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: UIConstants.paddingSM),
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

class _PricingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingLG,
        vertical: UIConstants.paddingXXL,
      ),
      child: Column(
        children: [
          Text(
            'Simple, Transparent Pricing',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: UIConstants.paddingSM),
          Text(
            'Choose the plan that fits your needs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: UIConstants.paddingXL),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: UIConstants.maxContentWidth),
            child: Wrap(
              spacing: UIConstants.paddingLG,
              runSpacing: UIConstants.paddingLG,
              alignment: WrapAlignment.center,
              children: Tiers.all.map((tier) => _PricingCard(tier: tier)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final TierDefinition tier;

  const _PricingCard({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(UIConstants.paddingLG),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
        border: Border.all(
          color: tier.isPopular
              ? Theme.of(context).primaryColor
              : Colors.grey.shade200,
          width: tier.isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tier.isPopular)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.paddingSM,
                vertical: 4,
              ),
              margin: const EdgeInsets.only(bottom: UIConstants.paddingSM),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(UIConstants.radiusSM),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            tier.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: UIConstants.paddingXS),
          Text(
            tier.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: UIConstants.paddingMD),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tier.monthlyPrice == 0
                    ? 'Free'
                    : '\$${tier.monthlyPrice.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (tier.monthlyPrice > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '/month',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: UIConstants.paddingMD),
          CustomButton(
            onPressed: () => context.push(RoutePaths.signup),
            text: tier.monthlyPrice == 0 ? 'Get Started' : 'Start Trial',
            isOutlined: !tier.isPopular,
            width: double.infinity,
          ),
          const SizedBox(height: UIConstants.paddingMD),
          const Divider(),
          const SizedBox(height: UIConstants.paddingMD),
          ...tier.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: UIConstants.paddingSM),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 16,
                      color: tier.color,
                    ),
                    const SizedBox(width: UIConstants.paddingSM),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingLG,
        vertical: UIConstants.paddingXXL,
      ),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Text(
            'Ready to Get Started?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: UIConstants.paddingSM),
          Text(
            'Start building your SaaS today with FluttnBoil',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: UIConstants.paddingLG),
          CustomButton(
            onPressed: () => context.push(RoutePaths.signup),
            text: 'Start Free Trial',
            backgroundColor: Colors.white,
            textColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.paddingXL,
              vertical: UIConstants.paddingMD,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingLG),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rocket_launch,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: UIConstants.paddingSM),
              Text(
                AppConfig.appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.paddingMD),
          Text(
            '© ${DateTime.now().year} ${AppConfig.appName}. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
