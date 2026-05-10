import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How can I track my order?',
      'a': 'After placing your order, go to the "Track Order" screen from the order success page or the tracking button. You will see live updates of your delivery status.',
    },
    {
      'q': 'Can I cancel my order?',
      'a': 'You can cancel your order within 2 minutes of placing it. Go to Order History, select the order and tap "Cancel Order". After 2 minutes, please contact support.',
    },
    {
      'q': 'How do I add a new delivery address?',
      'a': 'Go to Profile → Delivery Addresses → tap the "+ Add Address" button. Fill in the details and save.',
    },
    {
      'q': 'What payment methods are accepted?',
      'a': 'We accept Visa, Mastercard, Apple Pay, and Cash on Delivery. You can manage your saved cards in Profile → Payment Methods.',
    },
    {
      'q': 'How do I apply a promo code?',
      'a': 'On the Cart screen, tap "Add Promo Code" before proceeding to checkout. Enter your code and the discount will be applied automatically.',
    },
    {
      'q': 'What if my food arrived cold or wrong?',
      'a': 'We\'re sorry about that! Please contact our support team within 30 minutes of delivery. We\'ll make it right with a refund or free reorder.',
    },
    {
      'q': 'How do I delete my account?',
      'a': 'To delete your account, please contact our support team via email or live chat. Account deletion is permanent and cannot be undone.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Contact Options ───────────────────
          const Text('Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildContactCard(
                context,
                Icons.chat_bubble_outline,
                'Live Chat',
                'Available 24/7',
                const Color(0xFF4CAF50),
                () => _showContactDialog(context, 'Live Chat'),
                cardColor,
              ),
              const SizedBox(width: 14),
              _buildContactCard(
                context,
                Icons.phone_outlined,
                'Call Us',
                '+966 800 123 456',
                const Color(0xFF2196F3),
                () => _showContactDialog(context, 'Phone'),
                cardColor,
              ),
              const SizedBox(width: 14),
              _buildContactCard(
                context,
                Icons.email_outlined,
                'Email',
                'support@yummygo',
                AppTheme.primaryColor,
                () => _showContactDialog(context, 'Email'),
                cardColor,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // ── FAQ ────────────────────────────────
          const Text('Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ...List.generate(_faqs.length, (index) {
            final isExpanded = _expandedIndex == index;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: isExpanded
                    ? Border.all(
                        color: AppTheme.primaryColor.withValues(alpha: 0.5))
                    : null,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  onExpansionChanged: (expanded) {
                    setState(
                        () => _expandedIndex = expanded ? index : null);
                  },
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  leading: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isExpanded
                            ? Colors.white
                            : AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    _faqs[index]['q']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isExpanded ? AppTheme.primaryColor : null,
                    ),
                  ),
                  trailing: AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isExpanded ? AppTheme.primaryColor : Colors.grey,
                    ),
                  ),
                  children: [
                    Text(
                      _faqs[index]['a']!,
                      style: const TextStyle(
                          color: Colors.grey, height: 1.6, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: 400.ms, delay: (50 * index).ms);
          }),

          const SizedBox(height: 24),

          // ── Send Feedback ─────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Send Feedback',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                const SizedBox(height: 6),
                const Text(
                  'Help us improve by sharing your experience.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showFeedbackDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('Write Feedback'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
    Color cardColor,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06), blurRadius: 10)
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 2),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Contact via $method'),
        content: Text(
          method == 'Phone'
              ? 'Call us at +966 800 123 456\nAvailable 9AM – 9PM'
              : method == 'Email'
                  ? 'Email us at support@yummygo.com\nWe reply within 24 hours.'
                  : 'Starting live chat session...\nAverage wait time: 2 minutes.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(method == 'Phone' ? 'Call Now' : 'OK'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final ctrl = TextEditingController();
    int rating = 5;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Your Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setDialogState(() => rating = i + 1),
                    child: Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Tell us what you think...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback! ❤️'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
