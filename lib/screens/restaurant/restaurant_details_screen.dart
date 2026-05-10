import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../data/dummy_data.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant = DummyData.getRestaurantById(restaurantId)
        ?? DummyData.restaurants.first;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ──────────────────────
          SliverAppBar(
            expandedHeight: 260.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'restaurant_image_${restaurant.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey),
                    ),
                    // Gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Restaurant Info ───────────
                  Row(
                    children: [
                      Expanded(
                        child: Text(restaurant.name,
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: restaurant.isOpen
                              ? Colors.green.withOpacity(0.12)
                              : Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                size: 8,
                                color: restaurant.isOpen
                                    ? Colors.green
                                    : Colors.red),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.isOpen ? 'Open' : 'Closed',
                              style: TextStyle(
                                color: restaurant.isOpen
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Stats Row ─────────────────
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('${restaurant.rating}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(' (${restaurant.reviews}+ reviews)',
                          style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      const Icon(CupertinoIcons.clock,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(restaurant.deliveryTime,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.delivery_dining,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.deliveryFee == 0
                            ? 'Free'
                            : '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Min order: \$${restaurant.minimumOrder.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 16),

                  // ── Tags ─────────────────────
                  Wrap(
                    spacing: 8,
                    children: restaurant.tags.map((tag) => Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 12)),
                      backgroundColor:
                          AppTheme.primaryColor.withOpacity(0.1),
                      side: BorderSide.none,
                      labelStyle:
                          const TextStyle(color: AppTheme.primaryColor),
                    )).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ── Menu ─────────────────────
                  const Text('Menu',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ...restaurant.menu.asMap().entries.map((entry) {
                    return _buildMenuItem(context, entry.value)
                        .animate()
                        .fade(duration: 400.ms, delay: (100 * entry.key).ms)
                        .slideY(begin: 0.1);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Food food) {
    return InkWell(
      onTap: () => context.push('/food/${food.id}'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'food_image_${food.id}',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(15)),
                child: Image.asset(
                  food.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) =>
                      Container(width: 100, height: 100, color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 13),
                      const SizedBox(width: 3),
                      Text('${food.rating}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(' · ${food.calories} cal · ${food.prepTime}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('\$${food.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Consumer<CartProvider>(
                builder: (context, cart, _) {
                  final inCart = cart.items.containsKey(food.id);
                  return GestureDetector(
                    onTap: () {
                      cart.addItem(food, 1, []);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${food.name} added to cart!'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: inCart
                            ? AppTheme.primaryColor
                            : AppTheme.primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        inCart ? Icons.check : Icons.add,
                        color: inCart ? Colors.white : AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
