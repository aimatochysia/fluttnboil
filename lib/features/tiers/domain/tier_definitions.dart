/// Tier/RBAC definitions and permissions
library;

import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';

/// Represents a subscription tier with its features and limits
class TierDefinition {
  final UserTier tier;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final Map<String, dynamic> limits;
  final Color color;
  final IconData icon;
  final bool isPopular;

  const TierDefinition({
    required this.tier,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    required this.limits,
    required this.color,
    required this.icon,
    this.isPopular = false,
  });

  /// Get yearly savings percentage
  int get yearlySavingsPercent {
    if (monthlyPrice == 0) return 0;
    final monthlyTotal = monthlyPrice * 12;
    final savings = ((monthlyTotal - yearlyPrice) / monthlyTotal * 100).round();
    return savings;
  }
}

/// All available tier definitions
class Tiers {
  Tiers._();

  static const TierDefinition free = TierDefinition(
    tier: UserTier.free,
    name: 'Free',
    description: 'Perfect for getting started',
    monthlyPrice: 0,
    yearlyPrice: 0,
    features: [
      'Up to 3 projects',
      '1 team member',
      '1 GB storage',
      'Community support',
      'Basic analytics',
    ],
    limits: {
      'projects': 3,
      'team_members': 1,
      'storage_gb': 1,
      'api_access': false,
      'priority_support': false,
      'custom_branding': false,
    },
    color: AppTheme.freeTierColor,
    icon: Icons.person_outline,
  );

  static const TierDefinition pro = TierDefinition(
    tier: UserTier.pro,
    name: 'Pro',
    description: 'For professionals and small teams',
    monthlyPrice: 19.99,
    yearlyPrice: 199.99,
    features: [
      'Up to 25 projects',
      '10 team members',
      '50 GB storage',
      'API access',
      'Priority support',
      'Advanced analytics',
      'Integrations',
    ],
    limits: {
      'projects': 25,
      'team_members': 10,
      'storage_gb': 50,
      'api_access': true,
      'priority_support': true,
      'custom_branding': false,
    },
    color: AppTheme.proTierColor,
    icon: Icons.star_outline,
    isPopular: true,
  );

  static const TierDefinition enterprise = TierDefinition(
    tier: UserTier.enterprise,
    name: 'Enterprise',
    description: 'For large organizations',
    monthlyPrice: 99.99,
    yearlyPrice: 999.99,
    features: [
      'Unlimited projects',
      'Unlimited team members',
      'Unlimited storage',
      'API access',
      'Priority support',
      'Custom branding',
      'SSO integration',
      'Dedicated account manager',
      'SLA guarantee',
    ],
    limits: {
      'projects': -1,
      'team_members': -1,
      'storage_gb': -1,
      'api_access': true,
      'priority_support': true,
      'custom_branding': true,
    },
    color: AppTheme.enterpriseTierColor,
    icon: Icons.business,
  );

  static List<TierDefinition> get all => [free, pro, enterprise];

  static TierDefinition fromTier(UserTier tier) {
    switch (tier) {
      case UserTier.free:
        return free;
      case UserTier.pro:
        return pro;
      case UserTier.enterprise:
        return enterprise;
    }
  }
}

/// Permission definitions for RBAC
enum Permission {
  // Project permissions
  createProject,
  deleteProject,
  editProject,
  viewProject,

  // Team permissions
  inviteTeamMember,
  removeTeamMember,
  manageRoles,

  // Content permissions
  uploadFiles,
  deleteFiles,
  exportData,

  // API permissions
  useApi,
  createApiKey,

  // Admin permissions
  viewAnalytics,
  manageSubscription,
  customBranding,
  accessSupport,
}

/// Check if a tier has a specific permission
extension TierPermissions on UserTier {
  bool hasPermission(Permission permission) {
    switch (permission) {
      // Everyone can do basic operations
      case Permission.viewProject:
      case Permission.createProject:
      case Permission.editProject:
      case Permission.uploadFiles:
        return true;

      // Delete requires at least free
      case Permission.deleteProject:
      case Permission.deleteFiles:
      case Permission.exportData:
        return true;

      // Team features require pro or higher
      case Permission.inviteTeamMember:
      case Permission.removeTeamMember:
      case Permission.manageRoles:
        return this == UserTier.pro || this == UserTier.enterprise;

      // API features require pro or higher
      case Permission.useApi:
      case Permission.createApiKey:
        return this == UserTier.pro || this == UserTier.enterprise;

      // Analytics available to pro and enterprise
      case Permission.viewAnalytics:
        return this == UserTier.pro || this == UserTier.enterprise;

      // Subscription management available to all
      case Permission.manageSubscription:
        return true;

      // Enterprise-only features
      case Permission.customBranding:
        return this == UserTier.enterprise;

      // Support based on tier
      case Permission.accessSupport:
        return true;
    }
  }

  /// Get the tier required for a permission
  static UserTier requiredTierFor(Permission permission) {
    if (UserTier.free.hasPermission(permission)) {
      return UserTier.free;
    }
    if (UserTier.pro.hasPermission(permission)) {
      return UserTier.pro;
    }
    return UserTier.enterprise;
  }
}

/// Feature gate helper
class FeatureGate {
  final UserTier currentTier;

  const FeatureGate(this.currentTier);

  /// Check if user can access a feature
  bool canAccess(Permission permission) {
    return currentTier.hasPermission(permission);
  }

  /// Check if user has reached a limit
  bool hasReachedLimit(String limitKey, int currentValue) {
    final tierDef = Tiers.fromTier(currentTier);
    final limit = tierDef.limits[limitKey];

    if (limit == null || limit == -1) return false; // No limit
    return currentValue >= limit;
  }

  /// Get remaining count for a limit
  int getRemainingCount(String limitKey, int currentValue) {
    final tierDef = Tiers.fromTier(currentTier);
    final limit = tierDef.limits[limitKey];

    if (limit == null || limit == -1) return -1; // Unlimited
    return (limit - currentValue).clamp(0, limit);
  }

  /// Get upgrade suggestion for a blocked feature
  UserTier? suggestUpgrade(Permission permission) {
    if (canAccess(permission)) return null;

    if (UserTier.pro.hasPermission(permission)) {
      return UserTier.pro;
    }
    return UserTier.enterprise;
  }
}
