import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../profile/addresses_screen.dart';
import '../profile/payment_methods_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Selected payment: either a card id or 'cash'
  String? _selectedPaymentId;

  // Promo
  final _promoCtrl = TextEditingController();
  double _discount = 0;
  bool _promoApplied = false;
  bool _placingOrder = false;

  static const double _deliveryFee = 3.0;
  static const double _taxRate = 0.10;

  static const Map<String, String> _promoCodes = {
    'YUMMY10': '10',
    'SAVE20': '20',
    'FIRST50': '50',
  };

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    final pct = _promoCodes[code];
    if (pct != null) {
      setState(() {
        _discount = double.parse(pct);
        _promoApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('🎉 Promo applied! ${pct}% off'),
        backgroundColor: Colors.green,
      ));
    } else {
      setState(() => _promoApplied = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid promo code'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _placeOrder(BuildContext context, CartProvider cart) async {
    final user = context.read<UserProvider>();

    // Validate address
    if (user.deliveryAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please add a delivery address first'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Validate payment
    if (_selectedPaymentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a payment method'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() => _placingOrder = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    cart.clear();
    setState(() => _placingOrder = false);
    context.go('/order_success');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final user = context.watch<UserProvider>();
    final cardColor = Theme.of(context).cardColor;

    final addr = user.deliveryAddress;
    final cards = user.cards;

    // Initialize default payment selection
    if (_selectedPaymentId == null && cards.isNotEmpty) {
      _selectedPaymentId = user.defaultCard?.id ?? cards.first.id;
    }

    final subtotal = cart.subTotalAmount;
    final discountAmount = subtotal * (_discount / 100);
    final discountedSubtotal = subtotal - discountAmount;
    final tax = discountedSubtotal * _taxRate;
    final total = discountedSubtotal + _deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Browse Food'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Cart Items ────────────────────────
                  _sectionTitle('Order Items (${cart.items.length})'),
                  const SizedBox(height: 12),
                  _buildCartItems(cart, cardColor),
                  const SizedBox(height: 28),

                  // ── Delivery Address ──────────────────
                  _sectionTitle('Delivery Address'),
                  const SizedBox(height: 12),
                  _buildAddressCard(context, addr, cardColor),
                  const SizedBox(height: 28),

                  // ── Payment Method ────────────────────
                  _sectionTitle('Payment Method'),
                  const SizedBox(height: 12),
                  _buildPaymentSection(context, cards, cardColor),
                  const SizedBox(height: 28),

                  // ── Promo Code ────────────────────────
                  _sectionTitle('Promo Code'),
                  const SizedBox(height: 12),
                  _buildPromoField(cardColor),
                  const SizedBox(height: 28),

                  // ── Order Summary ─────────────────────
                  _sectionTitle('Order Summary'),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                      cardColor, subtotal, discountAmount, tax, total),
                  const SizedBox(height: 32),

                  // ── Place Order ───────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _placingOrder
                          ? null
                          : () => _placeOrder(context, cart),
                      child: _placingOrder
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              'Place Order  •  \$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // ── Cart Items ──────────────────────────────────────────
  Widget _buildCartItems(CartProvider cart, Color cardColor) {
    return Container(
      decoration: _cardDecor(cardColor),
      child: Column(
        children: cart.items.values.toList().asMap().entries.map((e) {
          final isLast = e.key == cart.items.length - 1;
          final item = e.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item.food.imageUrl,
                        width: 56, height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56, height: 56,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.food.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('x${item.quantity}',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(item.food.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
            ],
          );
        }).toList(),
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.05);
  }

  // ── Address Card ────────────────────────────────────────
  Widget _buildAddressCard(
      BuildContext context, UserAddress? addr, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(cardColor,
          highlight: addr != null ? AppTheme.primaryColor : Colors.red),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (addr != null ? AppTheme.primaryColor : Colors.red)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on,
                color: addr != null ? AppTheme.primaryColor : Colors.red),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: addr != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(addr.label,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 3),
                      Text('${addr.street}, ${addr.city}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  )
                : const Text('No delivery address selected',
                    style: TextStyle(color: Colors.red, fontSize: 14)),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddressesScreen()),
            ),
            child: Text(
              addr != null ? 'Change' : 'Add',
              style: TextStyle(
                  color: addr != null ? AppTheme.primaryColor : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms, delay: 100.ms).slideY(begin: 0.05);
  }

  // ── Payment Section ─────────────────────────────────────
  Widget _buildPaymentSection(
      BuildContext context, List<PaymentCard> cards, Color cardColor) {
    final all = [
      ...cards.map((c) => (
            id: c.id,
            label: '${c.type}  ····  ${c.last4}',
            icon: Icons.credit_card,
            sub: c.cardHolder,
          )),
      (
        id: 'cash',
        label: 'Cash on Delivery',
        icon: Icons.payments_outlined,
        sub: 'Pay when delivered',
      ),
    ];

    return Column(
      children: [
        Container(
          decoration: _cardDecor(cardColor),
          child: Column(
            children: all.asMap().entries.map((e) {
              final item = e.value;
              final isLast = e.key == all.length - 1;
              final selected = _selectedPaymentId == item.id;
              return Column(
                children: [
                  InkWell(
                    onTap: () =>
                        setState(() => _selectedPaymentId = item.id),
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTheme.primaryColor.withValues(alpha: 0.12)
                                  : Colors.grey.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(item.icon,
                                color: selected
                                    ? AppTheme.primaryColor
                                    : Colors.grey,
                                size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.label,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? AppTheme.primaryColor
                                            : null)),
                                Text(item.sub,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: selected
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 13)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                        height: 1,
                        indent: 58,
                        color: Colors.grey.withValues(alpha: 0.15)),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        // Manage cards link
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const PaymentMethodsScreen()),
            ),
            icon: const Icon(Icons.add_card, size: 16),
            label: const Text('Manage Cards'),
            style:
                TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
          ),
        ),
      ],
    ).animate().fade(duration: 400.ms, delay: 150.ms).slideY(begin: 0.05);
  }

  // ── Promo Code ──────────────────────────────────────────
  Widget _buildPromoField(Color cardColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: _cardDecor(cardColor),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined,
              color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _promoCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'Enter promo code (YUMMY10, SAVE20…)',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_promoApplied)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _applyPromo,
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Apply', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms, delay: 200.ms);
  }

  // ── Order Summary ───────────────────────────────────────
  Widget _buildSummaryCard(Color cardColor, double subtotal,
      double discountAmount, double tax, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(cardColor),
      child: Column(
        children: [
          _summaryRow('Subtotal', subtotal),
          if (_promoApplied) ...[
            const SizedBox(height: 10),
            _summaryRow('Discount (${_discount.toInt()}%)', -discountAmount,
                color: Colors.green),
          ],
          const SizedBox(height: 10),
          _summaryRow('Delivery Fee', _deliveryFee),
          const SizedBox(height: 10),
          _summaryRow('Tax (10%)', tax),
          const Divider(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor)),
            ],
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms, delay: 250.ms).slideY(begin: 0.05);
  }

  // ── Helpers ─────────────────────────────────────────────
  Widget _sectionTitle(String text) => Text(text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

  BoxDecoration _cardDecor(Color cardColor, {Color? highlight}) =>
      BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: highlight != null
            ? Border.all(color: highlight.withValues(alpha: 0.3))
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      );

  Widget _summaryRow(String label, double amount, {Color? color}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(
            '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color),
          ),
        ],
      );
}
