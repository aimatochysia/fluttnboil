/// Tier popup/modal widget for upgrade prompts
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/tier_definitions.dart';

/// Shows a tier upgrade popup
Future<UserTier?> showTierPopup(
  BuildContext context, {
  UserTier? currentTier,
  String? featureBlocked,
  Permission? requiredPermission,
}) {
  return showModalBottomSheet<UserTier>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TierPopup(
      currentTier: currentTier ?? AppConfig.tiers.defaultTier,
      featureBlocked: featureBlocked,
      requiredPermission: requiredPermission,
    ),
  );
}

/// Tier upgrade popup widget
class TierPopup extends StatefulWidget {
  final UserTier currentTier;
  final String? featureBlocked;
  final Permission? requiredPermission;

  const TierPopup({
    super.key,
    required this.currentTier,
    this.featureBlocked,
    this.requiredPermission,
  });

  @override
  State<TierPopup> createState() => _TierPopupState();
}

class _TierPopupState extends State<TierPopup> {
  bool _isYearly = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UIConstants.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: UIConstants.paddingMD),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(UIConstants.paddingLG),
            child: Column(
              children: [
                if (widget.featureBlocked != null) ...[
                  Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: UIConstants.paddingSM),
                  Text(
                    'Upgrade to Unlock',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: UIConstants.paddingXS),
                  Text(
                    widget.featureBlocked!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'Choose Your Plan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],

                // Billing toggle
                const SizedBox(height: UIConstants.paddingMD),
                _buildBillingToggle(),
              ],
            ),
          ),

          // Tier cards
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.paddingMD,
              ),
              child: Column(
                children: [
                  for (final tier in Tiers.all)
                    _TierCard(
                      tier: tier,
                      isYearly: _isYearly,
                      isCurrentTier: tier.tier == widget.currentTier,
                      onSelect: () => _selectTier(tier),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BillingOption(
            label: 'Monthly',
            isSelected: !_isYearly,
            onTap: () => setState(() => _isYearly = false),
          ),
          _BillingOption(
            label: 'Yearly',
            isSelected: _isYearly,
            badge: 'Save 17%',
            onTap: () => setState(() => _isYearly = true),
          ),
        ],
      ),
    );
  }

  void _selectTier(TierDefinition tier) {
    if (tier.tier == widget.currentTier) {
      Navigator.pop(context);
      return;
    }

    // Navigate to payment with selected tier
    Navigator.pop(context, tier.tier);

    if (tier.monthlyPrice > 0) {
      context.push(
        '${RoutePaths.payment}?tier=${tier.tier.name}&billing=${_isYearly ? "yearly" : "monthly"}',
      );
    }
  }
}

class _BillingOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _BillingOption({
    required this.label,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: UIConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.paddingMD,
          vertical: UIConstants.paddingSM,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(UIConstants.radiusMD),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final TierDefinition tier;
  final bool isYearly;
  final bool isCurrentTier;
  final VoidCallback onSelect;

  const _TierCard({
    required this.tier,
    required this.isYearly,
    required this.isCurrentTier,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final price = isYearly ? tier.yearlyPrice / 12 : tier.monthlyPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: UIConstants.paddingMD),
      decoration: BoxDecoration(
        border: Border.all(
          color: tier.isPopular
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          width: tier.isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(UIConstants.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: tier.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(tier.icon, color: tier.color),
                    ),
                    const SizedBox(width: UIConstants.paddingSM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            tier.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.paddingMD),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      tier.monthlyPrice == 0 ? 'Free' : '\$${price.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
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
                    if (isYearly && tier.yearlySavingsPercent > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Save ${tier.yearlySavingsPercent}%',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: UIConstants.paddingMD),

                // Features
                ...tier.features.take(5).map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: tier.color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: UIConstants.paddingMD),

                // Button
                CustomButton(
                  onPressed: onSelect,
                  text: isCurrentTier ? 'Current Plan' : 'Select ${tier.name}',
                  isOutlined: isCurrentTier,
                  backgroundColor: tier.color,
                  width: double.infinity,
                ),
              ],
            ),
          ),

          // Popular badge
          if (tier.isPopular)
            Positioned(
              top: 0,
              right: UIConstants.paddingMD,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.paddingSM,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(UIConstants.radiusSM),
                  ),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
