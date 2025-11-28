/// Dashboard screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../tiers/domain/tier_definitions.dart';
import '../../../tiers/presentation/widgets/tier_popup.dart';

/// Main dashboard screen for authenticated users
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userTier = ref.watch(userTierProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appName),
        actions: [
          // Tier badge
          GestureDetector(
            onTap: () => showTierPopup(context, currentTier: userTier),
            child: Container(
              margin: const EdgeInsets.only(right: UIConstants.paddingSM),
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.paddingSM,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Tiers.fromTier(userTier).color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(UIConstants.radiusSM),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Tiers.fromTier(userTier).icon,
                    size: 16,
                    color: Tiers.fromTier(userTier).color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    Tiers.fromTier(userTier).name,
                    style: TextStyle(
                      color: Tiers.fromTier(userTier).color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile avatar
          IconButton(
            onPressed: () => context.push(RoutePaths.profile),
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _DashboardDrawer(user: user, currentTier: userTier),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            _WelcomeSection(user: user),
            const SizedBox(height: UIConstants.paddingLG),

            // Quick stats
            _StatsSection(userTier: userTier),
            const SizedBox(height: UIConstants.paddingLG),

            // Quick actions
            _QuickActionsSection(userTier: userTier),
            const SizedBox(height: UIConstants.paddingLG),

            // Recent activity
            _RecentActivitySection(),
            const SizedBox(height: UIConstants.paddingLG),

            // Upgrade prompt (for free users)
            if (userTier == UserTier.free) _UpgradePromptSection(),
          ],
        ),
      ),
    );
  }
}

class _DashboardDrawer extends ConsumerWidget {
  final User user;
  final UserTier currentTier;

  const _DashboardDrawer({
    required this.user,
    required this.currentTier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.initials,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: UIConstants.paddingSM),
                Text(
                  user.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              context.push(RoutePaths.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.subscriptions),
            title: const Text('Subscription'),
            onTap: () {
              Navigator.pop(context);
              showTierPopup(context, currentTier: currentTier);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.push(RoutePaths.settings);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).logout();
              context.go(RoutePaths.landing);
            },
          ),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  final User user;

  const _WelcomeSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, ${user.displayName}!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: UIConstants.paddingXS),
        Text(
          "Here's what's happening with your projects today.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  final UserTier userTier;

  const _StatsSection({required this.userTier});

  @override
  Widget build(BuildContext context) {
    final tierDef = Tiers.fromTier(userTier);
    final projectLimit = tierDef.limits['projects'] as int;

    return Wrap(
      spacing: UIConstants.paddingMD,
      runSpacing: UIConstants.paddingMD,
      children: [
        _StatCard(
          title: 'Projects',
          value: '2',
          subtitle: projectLimit == -1 ? 'Unlimited' : 'of $projectLimit',
          icon: Icons.folder,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Team Members',
          value: '1',
          subtitle: 'Active',
          icon: Icons.people,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Storage',
          value: '0.5 GB',
          subtitle: 'of ${tierDef.limits['storage_gb']} GB',
          icon: Icons.storage,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'API Calls',
          value: userTier.hasPermission(Permission.useApi) ? '1,234' : '-',
          subtitle: userTier.hasPermission(Permission.useApi) ? 'This month' : 'Pro feature',
          icon: Icons.api,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(UIConstants.paddingMD),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.paddingSM),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  final UserTier userTier;

  const _QuickActionsSection({required this.userTier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: UIConstants.paddingSM),
        Wrap(
          spacing: UIConstants.paddingSM,
          runSpacing: UIConstants.paddingSM,
          children: [
            _ActionButton(
              icon: Icons.add,
              label: 'New Project',
              onPressed: () {},
            ),
            _ActionButton(
              icon: Icons.person_add,
              label: 'Invite Team',
              locked: !userTier.hasPermission(Permission.inviteTeamMember),
              onPressed: () {
                if (!userTier.hasPermission(Permission.inviteTeamMember)) {
                  showTierPopup(
                    context,
                    currentTier: userTier,
                    featureBlocked: 'Team invitations require Pro plan or higher',
                  );
                }
              },
            ),
            _ActionButton(
              icon: Icons.api,
              label: 'API Keys',
              locked: !userTier.hasPermission(Permission.createApiKey),
              onPressed: () {
                if (!userTier.hasPermission(Permission.createApiKey)) {
                  showTierPopup(
                    context,
                    currentTier: userTier,
                    featureBlocked: 'API access requires Pro plan or higher',
                  );
                }
              },
            ),
            _ActionButton(
              icon: Icons.download,
              label: 'Export Data',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool locked;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Stack(
        children: [
          Icon(icon),
          if (locked)
            Positioned(
              right: -4,
              top: -4,
              child: Icon(
                Icons.lock,
                size: 12,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.paddingMD,
          vertical: UIConstants.paddingSM,
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityItem(
        title: 'Project "Mobile App" created',
        time: '2 hours ago',
        icon: Icons.folder,
      ),
      _ActivityItem(
        title: 'Profile updated',
        time: 'Yesterday',
        icon: Icons.person,
      ),
      _ActivityItem(
        title: 'Welcome to FluttnBoil!',
        time: '3 days ago',
        icon: Icons.celebration,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: UIConstants.paddingSM),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: Icon(activity.icon, color: Theme.of(context).primaryColor),
                title: Text(activity.title),
                subtitle: Text(activity.time),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityItem {
  final String title;
  final String time;
  final IconData icon;

  const _ActivityItem({
    required this.title,
    required this.time,
    required this.icon,
  });
}

class _UpgradePromptSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingLG),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upgrade to Pro',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unlock more features and grow your business',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
          CustomButton(
            onPressed: () => showTierPopup(context, currentTier: UserTier.free),
            text: 'Upgrade',
            backgroundColor: Colors.white,
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
