import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategoryId = '1';

  @override
  Widget build(BuildContext context) {
    final foods = DummyData.getFoodsByCategory(_selectedCategoryId);
    final selectedCat =
        DummyData.categories.firstWhere((c) => c.id == _selectedCategoryId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // ── Category Tab Bar ──────────────────────
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: DummyData.categories.length,
              itemBuilder: (context, index) {
                final cat = DummyData.categories[index];
                final isSelected = cat.id == _selectedCategoryId;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryId = cat.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppTheme.primaryColor.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          cat.iconPath,
                          width: 28,
                          height: 28,
                          color: isSelected ? Colors.white : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cat.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Results header ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Row(
              children: [
                Text(
                  selectedCat.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${foods.length} items',
                    style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // ── Food Grid ─────────────────────────────
          Expanded(
            child: foods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu,
                            size: 70, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text('No items in this category',
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return _buildFoodCard(context, foods[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, Food food, int index) {
    return GestureDetector(
      onTap: () => context.push('/food/${food.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.asset(
                food.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(height: 120, color: Colors.grey.shade200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 13),
                      const SizedBox(width: 3),
                      Text('${food.rating}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(food.prepTime,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
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
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: (60 * index).ms).scale(begin: const Offset(0.95, 0.95));
  }
}
