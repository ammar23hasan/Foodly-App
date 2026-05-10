import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/dummy_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';

  final List<String> _recentSearches = ['Burger', 'Pizza', 'Sushi', 'Ramen'];
  final List<String> _filterCategories = ['All', 'Burger', 'Pizza', 'Kebab', 'Pasta', 'Snacks', 'Drinks'];

  List<Food> get _filteredFoods {
    final q = _query.toLowerCase();
    return DummyData.allFoods.where((food) {
      final matchesQuery = q.isEmpty ||
          food.name.toLowerCase().contains(q) ||
          food.description.toLowerCase().contains(q);
      final catMap = {'Burger': '1', 'Pizza': '2', 'Snacks': '3', 'Drinks': '4', 'Pasta': '5', 'Kebab': '6'};
      final matchesCat = _selectedCategory == 'All' ||
          food.categoryId == catMap[_selectedCategory];
      return matchesQuery && matchesCat;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search Field ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: 'Search for food or restaurants...',
                prefixIcon: const Icon(CupertinoIcons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Category Filter Chips ─────────────────
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filterCategories.length,
              itemBuilder: (context, i) {
                final cat = _filterCategories[i];
                final selected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: AppTheme.primaryColor,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: selected ? FontWeight.bold : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // ── Content ───────────────────────────────
          Expanded(
            child: _query.isEmpty && _selectedCategory == 'All'
                ? _buildDefaultContent()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Recent Searches
        const Text('Recent Searches',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _recentSearches.map((term) {
            return ActionChip(
              label: Text(term),
              avatar: const Icon(Icons.history, size: 16),
              onPressed: () {
                _searchController.text = term;
                setState(() => _query = term);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Recommended
        const Text('Recommended',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...DummyData.popularFoods.take(5).map((food) => _buildFoodTile(food)),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredFoods;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.search, size: 70, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No results for "$_query"',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Try a different keyword', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: results.length,
      itemBuilder: (context, index) =>
          _buildFoodTile(results[index]).animate().fade(duration: 300.ms, delay: (40 * index).ms),
    );
  }

  Widget _buildFoodTile(Food food) {
    return InkWell(
      onTap: () => context.push('/food/${food.id}'),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                food.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(width: 70, height: 70, color: Colors.grey.shade200),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 13),
                      const SizedBox(width: 3),
                      Text('${food.rating}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(' · ${food.prepTime}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Text('\$${food.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
