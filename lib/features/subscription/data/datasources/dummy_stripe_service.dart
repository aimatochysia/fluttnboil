/// Dummy Stripe service for development/demo
library;

import 'package:uuid/uuid.dart';

import '../../../../core/config/app_config.dart';
import '../../../tiers/domain/tier_definitions.dart';
import '../../domain/entities/subscription.dart';

/// Simulates Stripe API interactions
class DummyStripeService {
  DummyStripeService();

  // Simulated data store
  final Map<String, Subscription> _subscriptions = {};
  final List<PaymentMethod> _paymentMethods = [];

  /// Initialize dummy payment method
  Future<void> initialize() async {
    // Add a demo payment method
    _paymentMethods.add(const PaymentMethod(
      id: 'pm_demo_visa',
      type: 'card',
      brand: 'Visa',
      last4: '4242',
      expMonth: 12,
      expYear: 2028,
      isDefault: true,
    ));
  }

  /// Create a subscription
  Future<Subscription> createSubscription({
    required String userId,
    required UserTier tier,
    required BillingCycle billingCycle,
  }) async {
    await _simulateDelay();

    final tierDef = Tiers.fromTier(tier);
    final amount = billingCycle == BillingCycle.yearly
        ? tierDef.yearlyPrice
        : tierDef.monthlyPrice;

    final subscription = Subscription(
      id: const Uuid().v4(),
      userId: userId,
      tier: tier,
      status: SubscriptionStatus.active,
      billingCycle: billingCycle,
      startDate: DateTime.now(),
      nextBillingDate: billingCycle == BillingCycle.yearly
          ? DateTime.now().add(const Duration(days: 365))
          : DateTime.now().add(const Duration(days: 30)),
      amount: amount,
      currency: AppConfig.stripe.defaultCurrency,
      stripeSubscriptionId: 'sub_${const Uuid().v4().substring(0, 8)}',
      stripeCustomerId: 'cus_${const Uuid().v4().substring(0, 8)}',
      createdAt: DateTime.now(),
    );

    _subscriptions[subscription.id] = subscription;
    return subscription;
  }

  /// Get user's current subscription
  Future<Subscription?> getSubscription(String userId) async {
    await _simulateDelay(milliseconds: 300);

    return _subscriptions.values
        .where((s) => s.userId == userId && s.isActive)
        .firstOrNull;
  }

  /// Cancel subscription
  Future<Subscription> cancelSubscription(String subscriptionId) async {
    await _simulateDelay();

    final subscription = _subscriptions[subscriptionId];
    if (subscription == null) {
      throw Exception('Subscription not found');
    }

    final endDate = subscription.billingCycle == BillingCycle.yearly
        ? subscription.startDate.add(const Duration(days: 365))
        : subscription.startDate.add(const Duration(days: 30));

    final cancelledSubscription = subscription.copyWith(
      status: SubscriptionStatus.cancelled,
      cancelledAt: DateTime.now(),
      endDate: endDate,
    );

    _subscriptions[subscriptionId] = cancelledSubscription;
    return cancelledSubscription;
  }

  /// Update subscription tier
  Future<Subscription> updateSubscription({
    required String subscriptionId,
    required UserTier newTier,
  }) async {
    await _simulateDelay();

    final subscription = _subscriptions[subscriptionId];
    if (subscription == null) {
      throw Exception('Subscription not found');
    }

    final tierDef = Tiers.fromTier(newTier);
    final amount = subscription.billingCycle == BillingCycle.yearly
        ? tierDef.yearlyPrice
        : tierDef.monthlyPrice;

    final updatedSubscription = subscription.copyWith(
      tier: newTier,
      amount: amount,
    );

    _subscriptions[subscriptionId] = updatedSubscription;
    return updatedSubscription;
  }

  /// Create payment intent
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    await _simulateDelay();

    return PaymentIntent(
      id: 'pi_${const Uuid().v4().substring(0, 16)}',
      clientSecret: 'pi_secret_${const Uuid().v4()}',
      amount: amount,
      currency: currency.toLowerCase(),
      status: 'requires_payment_method',
    );
  }

  /// Confirm payment (simulated)
  Future<bool> confirmPayment(String paymentIntentId) async {
    await _simulateDelay(milliseconds: 1500);
    // Always succeed in demo mode
    return true;
  }

  /// Get payment methods
  Future<List<PaymentMethod>> getPaymentMethods(String customerId) async {
    await _simulateDelay(milliseconds: 300);
    return _paymentMethods;
  }

  /// Add payment method
  Future<PaymentMethod> addPaymentMethod({
    required String customerId,
    required String cardNumber,
    required int expMonth,
    required int expYear,
    required String cvc,
  }) async {
    await _simulateDelay();

    // Determine card brand from number
    String brand;
    if (cardNumber.startsWith('4')) {
      brand = 'Visa';
    } else if (cardNumber.startsWith('5')) {
      brand = 'Mastercard';
    } else if (cardNumber.startsWith('3')) {
      brand = 'Amex';
    } else {
      brand = 'Card';
    }

    final paymentMethod = PaymentMethod(
      id: 'pm_${const Uuid().v4().substring(0, 16)}',
      type: 'card',
      brand: brand,
      last4: cardNumber.substring(cardNumber.length - 4),
      expMonth: expMonth,
      expYear: expYear,
      isDefault: _paymentMethods.isEmpty,
    );

    _paymentMethods.add(paymentMethod);
    return paymentMethod;
  }

  /// Remove payment method
  Future<void> removePaymentMethod(String paymentMethodId) async {
    await _simulateDelay();
    _paymentMethods.removeWhere((pm) => pm.id == paymentMethodId);
  }

  /// Get subscription billing history
  Future<List<BillingHistoryItem>> getBillingHistory(String userId) async {
    await _simulateDelay(milliseconds: 300);

    // Return demo billing history
    return [
      BillingHistoryItem(
        id: 'inv_001',
        date: DateTime.now().subtract(const Duration(days: 30)),
        amount: 19.99,
        currency: 'USD',
        status: 'paid',
        description: 'Pro Plan - Monthly',
      ),
      BillingHistoryItem(
        id: 'inv_002',
        date: DateTime.now().subtract(const Duration(days: 60)),
        amount: 19.99,
        currency: 'USD',
        status: 'paid',
        description: 'Pro Plan - Monthly',
      ),
    ];
  }

  Future<void> _simulateDelay({int milliseconds = 500}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}

/// Billing history item
class BillingHistoryItem {
  final String id;
  final DateTime date;
  final double amount;
  final String currency;
  final String status;
  final String description;

  const BillingHistoryItem({
    required this.id,
    required this.date,
    required this.amount,
    required this.currency,
    required this.status,
    required this.description,
  });
}
