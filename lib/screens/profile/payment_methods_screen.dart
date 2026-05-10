import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: user.cards.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: user.cards.length,
              itemBuilder: (context, index) {
                return _buildCardTile(context, user.cards[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        icon: const Icon(Icons.add_card),
        label: const Text('Add Card'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No payment methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Add a card to pay faster.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCardTile(BuildContext context, PaymentCard card, int index) {
    final isVisa = card.type == 'Visa';
    final isMaster = card.type == 'Mastercard';

    return Slidable(
      key: ValueKey(card.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                context.read<UserProvider>().removeCard(card.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
            borderRadius: BorderRadius.circular(15),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => context.read<UserProvider>().setDefaultCard(card.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: card.isDefault
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12)
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isVisa
                      ? [const Color(0xFF1A237E), const Color(0xFF283593)]
                      : isMaster
                          ? [const Color(0xFF4A148C), const Color(0xFF6A1B9A)]
                          : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(card.type,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                      if (card.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Default',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('•••• •••• •••• ${card.last4}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Card Holder',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(card.cardHolder,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Expires',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(card.expiry,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: (80 * index).ms).slideY(begin: 0.1);
  }

  void _showAddSheet(BuildContext context) {
    final holderCtrl = TextEditingController();
    final numberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    final typeNotifier = ValueNotifier<String>('Visa');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add New Card',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Card type
                ValueListenableBuilder<String>(
                  valueListenable: typeNotifier,
                  builder: (_, selected, __) => Row(
                    children: ['Visa', 'Mastercard'].map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: selected == type,
                          selectedColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                              color: selected == type ? Colors.white : null),
                          onSelected: (_) => typeNotifier.value = type,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: holderCtrl,
                  decoration: const InputDecoration(
                      hintText: 'Card Holder Name',
                      prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: numberCtrl,
                  decoration: const InputDecoration(
                      hintText: 'Card Number (16 digits)',
                      prefixIcon: Icon(Icons.credit_card)),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  validator: (v) {
                    if (v == null || v.length < 16) return 'Enter 16-digit card number';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: expiryCtrl,
                        decoration: const InputDecoration(hintText: 'MM/YY'),
                        keyboardType: TextInputType.datetime,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: cvvCtrl,
                        decoration: const InputDecoration(hintText: 'CVV'),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        obscureText: true,
                        validator: (v) =>
                            v == null || v.length < 3 ? 'Enter 3-digit CVV' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      final last4 = numberCtrl.text.length >= 4
                          ? numberCtrl.text.substring(numberCtrl.text.length - 4)
                          : '0000';
                      context.read<UserProvider>().addCard(PaymentCard(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        cardHolder: holderCtrl.text,
                        last4: last4,
                        expiry: expiryCtrl.text,
                        type: typeNotifier.value,
                        isDefault: context.read<UserProvider>().cards.isEmpty,
                      ));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Card added successfully!'),
                            backgroundColor: Colors.green),
                      );
                    },
                    child: const Text('Add Card'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
