import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/providers.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final favIds = favProvider.favoriteFoodIds;
    final favoriteFoods = DummyData.allFoods.where((f) => favIds.contains(f.id)).toList();
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteFoods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 90, color: Colors.grey.shade300),
                  const SizedBox(height: 20),
                  const Text('No favorites yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Tap ❤️ on any dish to save it here.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                final food = favoriteFoods[index];
                return InkWell(
                  onTap: () => context.push('/food/${food.id}'),
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                          child: Image.asset(
                            food.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                Container(width: 100, height: 100, color: Colors.grey.shade200),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(food.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 13),
                                  const SizedBox(width: 3),
                                  Text('${food.rating}',
                                      style: const TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.w600)),
                                  Text(' · ${food.prepTime}',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text('\$${food.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => favProvider.toggleFavorite(food.id),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(duration: 400.ms, delay: (60 * index).ms).slideX(begin: 0.1);
              },
            ),
    );
  }
}
