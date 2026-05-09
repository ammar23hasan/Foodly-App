import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/models.dart';
import '../../data/dummy_data.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';

class FoodDetailsScreen extends StatefulWidget {
  final String foodId;

  const FoodDetailsScreen({super.key, required this.foodId});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int quantity = 1;
  List<String> selectedAddons = [];

  @override
  Widget build(BuildContext context) {
    // Find food or fallback to first
    final Food food = DummyData.popularFoods.firstWhere(
      (f) => f.id == widget.foodId,
      orElse: () => DummyData.popularFoods.first,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              child: Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  final isFav = favoritesProvider.isFavorite(food.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.black,
                    ),
                    onPressed: () => favoritesProvider.toggleFavorite(food.id),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // Space for bottom bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  food.imageUrl,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, err, stack) => Container(height: 350, color: Colors.grey),
                ),
                Container(
                  transform: Matrix4.translationValues(0, -30, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              food.name,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '\$${food.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 5),
                          Text('${food.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(' (${food.reviews} reviews)', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(food.description, style: const TextStyle(color: Colors.grey, height: 1.5)),
                      const SizedBox(height: 25),
                      
                      if (food.addons.isNotEmpty) ...[
                        const Text('Add-ons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...food.addons.map((addon) {
                          return CheckboxListTile(
                            title: Text(addon),
                            value: selectedAddons.contains(addon),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  selectedAddons.add(addon);
                                } else {
                                  selectedAddons.remove(addon);
                                }
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppTheme.primaryColor,
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Cart Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Quantity
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) setState(() => quantity--);
                            },
                          ),
                          Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartProvider>().addItem(food, quantity, selectedAddons);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${food.name} added to cart!')),
                          );
                          context.pop();
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
