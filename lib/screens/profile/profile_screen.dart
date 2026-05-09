import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 15),
            const Text('Ammar Hasan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('ammar@example.com', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 30),
            
            _buildProfileOption(context, Icons.person_outline, 'Edit Profile', () {}),
            _buildProfileOption(context, Icons.location_on_outlined, 'Delivery Addresses', () {}),
            _buildProfileOption(context, Icons.payment_outlined, 'Payment Methods', () {}),
            _buildProfileOption(context, Icons.history, 'Order History', () {}),
            _buildProfileOption(context, Icons.notifications_none, 'Notifications', () {}),
            _buildProfileOption(context, Icons.help_outline, 'Help & Support', () {}),
            
            const SizedBox(height: 20),
            _buildProfileOption(
              context, 
              Icons.logout, 
              'Log Out', 
              () => context.go('/login'),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : AppTheme.primaryColor),
        ),
        title: Text(
          title, 
          style: TextStyle(fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : Colors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
