/// Subscription entity
library;

import '../../../core/config/app_config.dart';

/// Represents a user's subscription
class Subscription {
  final String id;
  final String userId;
  final UserTier tier;
  final SubscriptionStatus status;
  final BillingCycle billingCycle;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;
  final double amount;
  final String currency;
  final String? stripeSubscriptionId;
  final String? stripeCustomerId;
  final DateTime createdAt;
  final DateTime? cancelledAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.tier,
    required this.status,
    required this.billingCycle,
    required this.startDate,
    this.endDate,
    this.nextBillingDate,
    required this.amount,
    this.currency = 'USD',
    this.stripeSubscriptionId,
    this.stripeCustomerId,
    required this.createdAt,
    this.cancelledAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      tier: UserTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => UserTier.free,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SubscriptionStatus.inactive,
      ),
      billingCycle: BillingCycle.values.firstWhere(
        (e) => e.name == json['billing_cycle'],
        orElse: () => BillingCycle.monthly,
      ),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      nextBillingDate: json['next_billing_date'] != null
          ? DateTime.parse(json['next_billing_date'] as String)
          : null,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      stripeSubscriptionId: json['stripe_subscription_id'] as String?,
      stripeCustomerId: json['stripe_customer_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tier': tier.name,
      'status': status.name,
      'billing_cycle': billingCycle.name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'next_billing_date': nextBillingDate?.toIso8601String(),
      'amount': amount,
      'currency': currency,
      'stripe_subscription_id': stripeSubscriptionId,
      'stripe_customer_id': stripeCustomerId,
      'created_at': createdAt.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
    };
  }

  /// Check if subscription is active
  bool get isActive => status == SubscriptionStatus.active;

  /// Check if subscription is cancelled but still usable
  bool get isCancelledButActive =>
      status == SubscriptionStatus.cancelled &&
      endDate != null &&
      DateTime.now().isBefore(endDate!);

  /// Days remaining in current period
  int get daysRemaining {
    if (endDate == null) return -1;
    return endDate!.difference(DateTime.now()).inDays;
  }

  Subscription copyWith({
    String? id,
    String? userId,
    UserTier? tier,
    SubscriptionStatus? status,
    BillingCycle? billingCycle,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextBillingDate,
    double? amount,
    String? currency,
    String? stripeSubscriptionId,
    String? stripeCustomerId,
    DateTime? createdAt,
    DateTime? cancelledAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tier: tier ?? this.tier,
      status: status ?? this.status,
      billingCycle: billingCycle ?? this.billingCycle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      stripeSubscriptionId: stripeSubscriptionId ?? this.stripeSubscriptionId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }
}

/// Subscription status
enum SubscriptionStatus {
  active,
  inactive,
  cancelled,
  pastDue,
  trialing,
  paused,
}

/// Billing cycle options
enum BillingCycle {
  monthly,
  yearly,
}

/// Payment method
class PaymentMethod {
  final String id;
  final String type;
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String?,
      last4: json['last4'] as String?,
      expMonth: json['exp_month'] as int?,
      expYear: json['exp_year'] as int?,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  /// Get display name for card
  String get displayName {
    if (type == 'card' && brand != null && last4 != null) {
      return '${brand!.toUpperCase()} ····$last4';
    }
    return type.toUpperCase();
  }

  /// Get expiry display
  String? get expiryDisplay {
    if (expMonth != null && expYear != null) {
      return '${expMonth!.toString().padLeft(2, '0')}/${expYear! % 100}';
    }
    return null;
  }
}

/// Payment intent for Stripe
class PaymentIntent {
  final String id;
  final String clientSecret;
  final double amount;
  final String currency;
  final String status;

  const PaymentIntent({
    required this.id,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'] as String,
      clientSecret: json['client_secret'] as String,
      amount: (json['amount'] as num).toDouble() / 100, // Convert from cents
      currency: json['currency'] as String,
      status: json['status'] as String,
    );
  }
}
