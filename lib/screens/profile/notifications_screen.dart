import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final s = user.notifSettings;
    final cardColor = Theme.of(context).cardColor;

    final sections = [
      {
        'title': 'Order Notifications',
        'items': [
          {
            'key': 'orderUpdates',
            'icon': Icons.delivery_dining_outlined,
            'title': 'Order Updates',
            'subtitle': 'Get notified about your order status',
            'value': s.orderUpdates,
          },
          {
            'key': 'smsAlerts',
            'icon': Icons.sms_outlined,
            'title': 'SMS Alerts',
            'subtitle': 'Receive text messages for deliveries',
            'value': s.smsAlerts,
          },
        ],
      },
      {
        'title': 'Marketing',
        'items': [
          {
            'key': 'promotions',
            'icon': Icons.local_offer_outlined,
            'title': 'Promotions & Offers',
            'subtitle': 'Discounts, deals and special offers',
            'value': s.promotions,
          },
          {
            'key': 'newRestaurants',
            'icon': Icons.restaurant_outlined,
            'title': 'New Restaurants',
            'subtitle': 'When new restaurants join your area',
            'value': s.newRestaurants,
          },
          {
            'key': 'newsletter',
            'icon': Icons.mail_outline,
            'title': 'Newsletter',
            'subtitle': 'Weekly digest of top picks',
            'value': s.newsletter,
          },
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Push notification master switch
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.white, size: 28),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Push Notifications',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text('Manage all your notifications',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Switch(
                  value: s.orderUpdates || s.promotions || s.smsAlerts,
                  onChanged: (val) {
                    for (final key in [
                      'orderUpdates',
                      'promotions',
                      'newRestaurants',
                      'newsletter',
                      'smsAlerts',
                    ]) {
                      context.read<UserProvider>().updateNotification(key, val);
                    }
                  },
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.white.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),

          for (final section in sections) ...[
            Text(section['title'] as String,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: (section['items'] as List<Map<String, dynamic>>)
                    .asMap()
                    .entries
                    .map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  final isLast = i ==
                      (section['items'] as List).length - 1;
                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'] as IconData,
                              color: AppTheme.primaryColor, size: 20),
                        ),
                        title: Text(item['title'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(item['subtitle'] as String,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                        trailing: Switch(
                          value: item['value'] as bool,
                          onChanged: (val) =>
                              context.read<UserProvider>().updateNotification(
                                    item['key'] as String,
                                    val,
                                  ),
                          activeThumbColor: AppTheme.primaryColor,
                          activeTrackColor:
                              AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      if (!isLast)
                        Divider(
                          height: 1,
                          indent: 60,
                          color: Colors.grey.withValues(alpha: 0.15),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
