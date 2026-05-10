import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'order_history_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final user = context.watch<UserProvider>();
    final cart = context.watch<CartProvider>();
    final favs = context.watch<FavoritesProvider>();
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar + Name ─────────────────────
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [user.avatarColor, user.avatarColor.withValues(alpha: 0.6)],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: user.avatarColor,
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                                fontSize: 38,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2),
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(user.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user.email,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(user.phone,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            ).animate().fade(duration: 400.ms).slideY(begin: -0.1),
            const SizedBox(height: 24),

            // ── Stats ─────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(
                      '${user.totalOrders}', 'Orders', AppTheme.primaryColor),
                  _buildDivider(),
                  _buildStat('${favs.favoriteFoodIds.length}', 'Favorites',
                      Colors.red),
                  _buildDivider(),
                  _buildStat('${cart.itemCount}', 'In Cart',
                      AppTheme.secondaryColor),
                ],
              ),
            ).animate(delay: 100.ms).fade(duration: 400.ms),
            const SizedBox(height: 24),

            // ── Dark Mode Toggle ──────────────────
            _buildToggleTile(
              context,
              icon: themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'Dark Mode',
              subtitle: themeProvider.isDark ? 'On' : 'Off',
              value: themeProvider.isDark,
              onChanged: (_) => themeProvider.toggleTheme(),
              cardColor: cardColor,
            ).animate(delay: 150.ms).fade(duration: 400.ms),
            const SizedBox(height: 8),

            // ── Menu Options ──────────────────────
            ...[
              (Icons.person_outline, 'Edit Profile', Colors.purple, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              }),
              (Icons.location_on_outlined, 'Delivery Addresses', Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressesScreen()),
                );
              }),
              (Icons.credit_card_outlined, 'Payment Methods', Colors.green, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PaymentMethodsScreen()),
                );
              }),
              (Icons.receipt_long_outlined, 'Order History', Colors.orange, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen()),
                );
              }),
              (Icons.notifications_outlined, 'Notifications', Colors.cyan, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()),
                );
              }),
              (Icons.help_outline, 'Help & Support', Colors.indigo, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen()),
                );
              }),
            ].asMap().entries.map((e) {
              final idx = e.key;
              final (icon, title, color, onTap) = e.value;
              return _buildMenuTile(
                context,
                icon: icon,
                title: title,
                accentColor: color,
                onTap: onTap,
                cardColor: cardColor,
              ).animate(delay: (200 + 50 * idx).ms).fade(duration: 400.ms).slideX(begin: 0.05);
            }),

            const SizedBox(height: 8),

            // ── Logout ────────────────────────────
            _buildMenuTile(
              context,
              icon: Icons.logout,
              title: 'Log Out',
              accentColor: Colors.red,
              onTap: () => _showLogoutDialog(context),
              cardColor: cardColor,
              isDestructive: true,
            ).animate(delay: 500.ms).fade(duration: 400.ms),

            const SizedBox(height: 20),

            // App version
            Text('YummyGo v1.0.0',
                style:
                    TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildDivider() =>
      Container(height: 30, width: 1, color: Colors.grey.shade200);

  Widget _buildToggleTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.primaryColor,
          activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color accentColor,
    required VoidCallback onTap,
    required Color cardColor,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDestructive ? Colors.red : null)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
