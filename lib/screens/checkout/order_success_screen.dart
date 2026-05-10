import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate a random-ish order id
    final orderId = 'YG-${DateTime.now().millisecondsSinceEpoch % 100000}';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Success Icon ──────────────────
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ).animate().scale(
                          begin: const Offset(0, 0),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ).animate(delay: 100.ms).scale(
                          begin: const Offset(0, 0),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80)
                        .animate(delay: 200.ms)
                        .scale(
                          begin: const Offset(0, 0),
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                        ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Title ─────────────────────────
                const Text(
                  'Order Placed! 🎉',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ).animate(delay: 400.ms).fade(duration: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: 12),
                Text(
                  'Your order has been confirmed and the restaurant is preparing it now.',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 15, height: 1.5),
                  textAlign: TextAlign.center,
                ).animate(delay: 500.ms).fade(duration: 500.ms),
                const SizedBox(height: 28),

                // ── Order ID Card ─────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Order ID',
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(orderId,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ).animate(delay: 600.ms).fade(duration: 500.ms).slideY(begin: 0.2),
                const SizedBox(height: 16),

                // ── ETA Info ──────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, color: AppTheme.primaryColor, size: 20),
                      const SizedBox(width: 10),
                      const Text(
                        'Estimated delivery: 15–25 min',
                        style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ).animate(delay: 700.ms).fade(duration: 500.ms),
                const SizedBox(height: 40),

                // ── Buttons ───────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/tracking'),
                    icon: const Icon(Icons.delivery_dining),
                    label: const Text('Track My Order'),
                  ),
                ).animate(delay: 800.ms).fade(duration: 400.ms).slideY(begin: 0.2),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Back to Home'),
                  ),
                ).animate(delay: 900.ms).fade(duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
