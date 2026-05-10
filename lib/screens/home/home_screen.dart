import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/dummy_data.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../profile/addresses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _bannerIndex = 0;
  bool _isLoading = true;
  Timer? _bannerTimer;

  final List<Map<String, dynamic>> _banners = [
    {
      'image': 'images/Top view full table of food.jpg',
      'title': 'Special Offer',
      'subtitle': 'Discount 25%',
      'color': Colors.orange,
    },
    {
      'image': 'images/Sushi roll platter.webp',
      'title': 'New Arrival',
      'subtitle': 'Sushi Platter',
      'color': Colors.blue,
    },
    {
      'image': 'images/Indian chicken tikka masala with naan.png',
      'title': 'Today\'s Special',
      'subtitle': 'Indian Cuisine',
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
    // Auto-scroll banner
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_bannerController.hasClients) {
        final next = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // ── Delivery Address Sheet ────────────────────────────────
  void _showDeliverySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DeliverySheet(
        onAddNew: () {
          Navigator.pop(ctx);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddressesScreen()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => _isLoading = true);
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) setState(() => _isLoading = false);
          },
          color: AppTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Consumer<UserProvider>(
                  builder: (_, user, __) {
                    final addr = user.deliveryAddress;
                    final label = addr != null
                        ? '${addr.label}  ·  ${addr.city}'
                        : 'Add Address';
                    return GestureDetector(
                      onTap: () => _showDeliverySheet(context),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deliver to',
                            style: TextStyle(
                                fontSize: 12, color: AppTheme.textLight),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on,
                                  color: AppTheme.primaryColor, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                label,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.keyboard_arrow_down,
                                  size: 18, color: AppTheme.primaryColor),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.bell),
                    onPressed: () {},
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      InkWell(
                        onTap: () => context.push('/search'),
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).inputDecorationTheme.fillColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.search, color: AppTheme.textLight),
                              const SizedBox(width: 10),
                              Text(
                                'What are you craving?',
                                style: TextStyle(color: AppTheme.textLight),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(duration: 400.ms).slideY(begin: -0.1),
                      const SizedBox(height: 25),

                      // ── Auto-scrolling Banner Carousel ──
                      _isLoading ? _shimmerBanner() : _buildBannerCarousel(),
                      const SizedBox(height: 25),

                      // ── Categories ──
                      _buildSectionHeader('Categories', () => context.push('/categories')),
                      const SizedBox(height: 10),
                      _isLoading ? _shimmerCategoryRow() : _buildCategoryList(),
                      const SizedBox(height: 25),

                      // ── Popular Foods ──
                      _buildSectionHeader('Popular Dishes', null),
                      const SizedBox(height: 10),
                      _isLoading ? _shimmerPopularFoods() : _buildPopularFoodsList(),
                      const SizedBox(height: 25),

                      // ── Restaurants ──
                      _buildSectionHeader('Restaurants', null),
                      const SizedBox(height: 10),
                      _isLoading ? _shimmerRestaurantList() : _buildRestaurantList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Section Header ───────────────────────────────────
  Widget _buildSectionHeader(String title, VoidCallback? onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('See All')),
      ],
    );
  }

  // ─── Banner Carousel ──────────────────────────────────
  Widget _buildBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(banner['image'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.65), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(banner['title'] as String,
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(banner['subtitle'] as String,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Order Now', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _bannerIndex == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _bannerIndex == i ? AppTheme.primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ─── Category List ────────────────────────────────────
  Widget _buildCategoryList() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: DummyData.categories.length,
        itemBuilder: (context, index) {
          final category = DummyData.categories[index];
          return Container(
            margin: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () => context.push('/categories'),
              borderRadius: BorderRadius.circular(15),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(category.iconPath, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 8),
                  Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
            ),
          ).animate().fade(duration: 400.ms, delay: (50 * index).ms).slideX(begin: 0.2);
        },
      ),
    );
  }

  // ─── Popular Foods Horizontal List ────────────────────
  Widget _buildPopularFoodsList() {
    final foods = DummyData.popularFoods.take(6).toList();
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return GestureDetector(
            onTap: () => context.push('/food/${food.id}'),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10)],
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 13),
                            const SizedBox(width: 2),
                            Text('${food.rating}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('\$${food.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 500.ms, delay: (60 * index).ms).slideX(begin: 0.2);
        },
      ),
    );
  }

  // ─── Restaurant List ──────────────────────────────────
  Widget _buildRestaurantList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: DummyData.restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = DummyData.restaurants[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
          ),
          child: InkWell(
            onTap: () => context.push('/restaurant/${restaurant.id}'),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(
                        restaurant.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Container(height: 150, color: Colors.grey.shade200),
                      ),
                    ),
                    // Open/Closed badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: restaurant.isOpen ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          restaurant.isOpen ? 'Open' : 'Closed',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(restaurant.name,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 3),
                              Text(restaurant.rating.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(' (${restaurant.reviews})',
                                  style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.clock, size: 14, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Text(restaurant.deliveryTime,
                              style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                          const SizedBox(width: 15),
                          const Icon(Icons.delivery_dining, size: 14, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.deliveryFee == 0
                                ? 'Free'
                                : '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                            style: TextStyle(color: AppTheme.textLight, fontSize: 13),
                          ),
                          const SizedBox(width: 15),
                          Icon(Icons.shopping_bag_outlined, size: 14, color: AppTheme.textLight),
                          const SizedBox(width: 4),
                          Text('Min \$${restaurant.minimumOrder.toStringAsFixed(0)}',
                              style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade(duration: 500.ms, delay: (100 * index).ms).slideY(begin: 0.1);
      },
    );
  }

  // ─── Shimmer Widgets ─────────────────────────────────
  Widget _shimmerBanner() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _shimmerCategoryRow() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 70,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerPopularFoods() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerRestaurantList() {
    return Column(
      children: List.generate(
        3,
        (_) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 220,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// _DeliverySheet — Address selection bottom sheet
// ─────────────────────────────────────────────────────────
const _mapboxToken =
    'pk.eyJ1IjoiYW1tYXIyMyIsImEiOiJjbXAwYjc4aXMwMzhsMnNxeGJxcjA4dnhkIn0.ShO3Ar9_H2hBpmZ9gBMdfA';

class _DeliverySheet extends StatelessWidget {
  final VoidCallback onAddNew;
  const _DeliverySheet({required this.onAddNew});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final addresses = user.addresses;
    final selected = user.deliveryAddress;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: BoxDecoration(
        color: scaffoldBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 18),

          // ── Header ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                const Icon(Icons.local_shipping_outlined,
                    color: AppTheme.primaryColor),
                const SizedBox(width: 10),
                const Text('Deliver To',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddNew,
                  icon: const Icon(Icons.add_location_alt_outlined,
                      size: 16),
                  label: const Text('Add New'),
                  style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor),
                ),
              ],
            ),
          ),
          const Divider(height: 16),

          // ── Address list ──────────────────────────
          addresses.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Icon(Icons.location_off_outlined,
                          size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      const Text('No saved addresses',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      const Text('Add your first address to get started.',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: onAddNew,
                        icon: const Icon(Icons.add_location_alt_outlined),
                        label: const Text('Add Address on Map'),
                      ),
                    ],
                  ),
                )
              : Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final addr = addresses[index];
                      final isSelected = selected?.id == addr.id;
                      final hasMap = addr.lat != null && addr.lng != null;

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<UserProvider>()
                              .selectDeliveryAddress(addr.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Delivering to ${addr.label} · ${addr.city}'),
                              backgroundColor: AppTheme.primaryColor,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor.withValues(alpha: 0.06)
                                : cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: isSelected
                                ? Border.all(
                                    color: AppTheme.primaryColor,
                                    width: 2)
                                : Border.all(
                                    color: Colors.transparent, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Mini map
                              if (hasMap)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: SizedBox(
                                    height: 100,
                                    child: FlutterMap(
                                      options: MapOptions(
                                        initialCenter:
                                            LatLng(addr.lat!, addr.lng!),
                                        initialZoom: 15.0,
                                        interactionOptions:
                                            const InteractionOptions(
                                          flags: InteractiveFlag.none,
                                        ),
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=$_mapboxToken',
                                          userAgentPackageName:
                                              'com.yummygo.app',
                                          retinaMode: true,
                                        ),
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              point: LatLng(
                                                  addr.lat!, addr.lng!),
                                              width: 36,
                                              height: 44,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? AppTheme.primaryColor
                                                          : Colors.grey,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: (isSelected
                                                                  ? AppTheme
                                                                      .primaryColor
                                                                  : Colors.grey)
                                                              .withValues(
                                                                  alpha: 0.4),
                                                          blurRadius: 6,
                                                        )
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                        Icons.location_on,
                                                        color: Colors.white,
                                                        size: 14),
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 8,
                                                    color: isSelected
                                                        ? AppTheme.primaryColor
                                                        : Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // Info row
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                                .withValues(alpha: 0.12)
                                            : Colors.grey
                                                .withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        addr.label == 'Home'
                                            ? Icons.home_outlined
                                            : addr.label == 'Work'
                                                ? Icons.work_outline
                                                : Icons.location_on_outlined,
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                addr.label,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: isSelected
                                                      ? AppTheme.primaryColor
                                                      : null,
                                                ),
                                              ),
                                              if (addr.isDefault) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 7,
                                                          vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber
                                                        .withValues(alpha: 0.15),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Text('Default',
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${addr.street}, ${addr.city}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Selection indicator
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppTheme.primaryColor
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check,
                                              color: Colors.white, size: 13)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fade(duration: 350.ms, delay: (60 * index).ms)
                          .slideX(begin: 0.05);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
