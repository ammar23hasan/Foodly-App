import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final orders = user.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No orders yet',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Your orders will appear here.',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Start Ordering'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(context, orders[index], index);
              },
            ),
    );
  }

  Widget _buildOrderCard(BuildContext context, PastOrder order, int index) {
    final cardColor = Theme.of(context).cardColor;
    final isDelivered = order.status == 'Delivered';
    final isCancelled = order.status == 'Cancelled';

    final statusColor = isDelivered
        ? Colors.green
        : isCancelled
            ? Colors.red
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.06),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.restaurantName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(order.date),
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isDelivered
                                ? Icons.check_circle_outline
                                : isCancelled
                                    ? Icons.cancel_outlined
                                    : Icons.pending_outlined,
                            color: statusColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(order.status,
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(order.id,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text('${item.quantity}',
                                style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(item.foodName,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                    )),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.primaryColor)),
                  ],
                ),
              ],
            ),
          ),

          // Reorder button
          if (isDelivered)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Items from ${order.restaurantName} added to cart!'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                    context.go('/home');
                  },
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text('Reorder'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
        ],
      ),
    ).animate().fade(duration: 400.ms, delay: (80 * index).ms).slideY(begin: 0.1);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
