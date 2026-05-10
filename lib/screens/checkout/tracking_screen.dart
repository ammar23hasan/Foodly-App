import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../theme/app_theme.dart';

// ── Mapbox Token ────────────────────────────────────────
const _mapboxToken =
    'pk.eyJ1IjoiYW1tYXIyMyIsImEiOiJjbXAwYjc4aXMwMzhsMnNxeGJxcjA4dnhkIn0.ShO3Ar9_H2hBpmZ9gBMdfA';

// ── Route waypoints (Riyadh — restaurant → home) ────────
const _restaurantPos = LatLng(24.7136, 46.6753);  // Al-Murabba
const _homePos        = LatLng(24.6907, 46.6839);  // Al-Olaya

const List<LatLng> _routePoints = [
  LatLng(24.7136, 46.6753),
  LatLng(24.7110, 46.6760),
  LatLng(24.7083, 46.6770),
  LatLng(24.7060, 46.6780),
  LatLng(24.7040, 46.6795),
  LatLng(24.7020, 46.6810),
  LatLng(24.7000, 46.6820),
  LatLng(24.6975, 46.6828),
  LatLng(24.6950, 46.6833),
  LatLng(24.6930, 46.6836),
  LatLng(24.6907, 46.6839),
];

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  int _routeIndex = 0;
  int _currentStep = 1; // 0=confirmed,1=preparing,2=on-the-way,3=delivered
  Timer? _moveTimer;
  Timer? _stepTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  LatLng get _driverPos => _routePoints[_routeIndex];

  @override
  void initState() {
    super.initState();

    // Pulsing animation for driver marker
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Move driver along route
    _moveTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_routeIndex < _routePoints.length - 1 && mounted) {
        setState(() => _routeIndex++);
        _animateMapToDriver();
      } else {
        _moveTimer?.cancel();
      }
    });

    // Progress steps
    _stepTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_currentStep < 3 && mounted) {
        setState(() => _currentStep++);
      } else {
        _stepTimer?.cancel();
      }
    });
  }

  void _animateMapToDriver() {
    _mapController.move(_driverPos, _mapController.camera.zoom);
  }

  double _driverRotation() {
    if (_routeIndex == 0) return 0;
    final prev = _routePoints[_routeIndex - 1];
    final curr = _driverPos;
    final dy = curr.latitude - prev.latitude;
    final dx = curr.longitude - prev.longitude;
    return -(atan2(dx, dy) * 180 / pi);
  }

  double get _progressPercent =>
      _routeIndex / (_routePoints.length - 1);

  @override
  void dispose() {
    _moveTimer?.cancel();
    _stepTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mapbox style URL (dark/light)
    final mapStyle = isDark
        ? 'dark-v11'
        : 'streets-v12';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _animateMapToDriver,
            tooltip: 'Center on driver',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Mapbox Map ────────────────────────────────
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(24.7020, 46.6800),
                    initialZoom: 14.0,
                    minZoom: 10,
                    maxZoom: 18,
                  ),
                  children: [
                    // ── Tile Layer (Mapbox) ───────────
                    TileLayer(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/mapbox/$mapStyle/tiles/256/{z}/{x}/{y}@2x?access_token=$_mapboxToken',
                      userAgentPackageName: 'com.yummygo.app',
                      retinaMode: true,
                    ),

                    // ── Route Polyline ────────────────
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: Colors.grey.withValues(alpha: 0.4),
                          strokeWidth: 5,
                        ),
                        Polyline(
                          points: _routePoints.sublist(0, _routeIndex + 1),
                          color: AppTheme.primaryColor,
                          strokeWidth: 5,
                          strokeCap: StrokeCap.round,
                        ),
                      ],
                    ),

                    // ── Markers ───────────────────────
                    MarkerLayer(
                      markers: [
                        // Restaurant marker
                        Marker(
                          point: _restaurantPos,
                          width: 50,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.primaryColor, width: 2),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 6)
                              ],
                            ),
                            child: const Icon(Icons.restaurant,
                                color: AppTheme.primaryColor, size: 22),
                          ),
                        ),

                        // Home marker
                        Marker(
                          point: _homePos,
                          width: 50,
                          height: 50,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blue.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        spreadRadius: 2)
                                  ],
                                ),
                                child: const Icon(Icons.home,
                                    color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                        ),

                        // Driver marker (animated)
                        Marker(
                          point: _driverPos,
                          width: 60,
                          height: 60,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (_, child) => Transform.scale(
                              scale: _pulseAnimation.value,
                              child: child,
                            ),
                            child: Transform.rotate(
                              angle: _driverRotation() * pi / 180,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor
                                          .withValues(alpha: 0.5),
                                      blurRadius: 12,
                                      spreadRadius: 3,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.delivery_dining,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ── Progress bar overlay ──────────────
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.delivery_dining,
                                color: AppTheme.primaryColor, size: 18),
                            const SizedBox(width: 6),
                            const Text('Driver is on the way',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                            const Spacer(),
                            Text(
                              '${(_progressPercent * 100).toInt()}%',
                              style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _progressPercent,
                            backgroundColor: Colors.grey.shade200,
                            color: AppTheme.primaryColor,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Map Attribution fix ───────────────
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('© Mapbox © OpenStreetMap',
                        style: TextStyle(fontSize: 8, color: Colors.black54)),
                  ),
                ),
              ],
            ),
          ),

          // ── Tracking Panel ────────────────────────────
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 16),

                  // ETA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimated Delivery',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14)),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _currentStep == 3 ? '✅ Delivered!' : '~15–25 min',
                          key: ValueKey(_currentStep == 3),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _currentStep == 3
                                ? Colors.green
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 22),

                  // Tracking steps
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildStep(0, 'Order Confirmed',
                            'Restaurant received your order'),
                        _buildStep(1, 'Preparing',
                            'Chef is cooking your meal'),
                        _buildStep(2, 'On the Way',
                            'Driver picked up & heading to you'),
                        _buildStep(3, 'Delivered',
                            'Enjoy your meal! 😋',
                            isLast: true),

                        const SizedBox(height: 12),

                        // Driver card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8)
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    AppTheme.primaryColor.withValues(alpha: 0.15),
                                child: const Text('J',
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('John Doe',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Text('Delivery Driver  ⭐ 4.9',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              _circleBtn(Icons.call, AppTheme.primaryColor),
                              const SizedBox(width: 8),
                              _circleBtn(
                                  Icons.chat_bubble_outline, Colors.blue),
                            ],
                          ),
                        ).animate().fade(duration: 600.ms, delay: 800.ms),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int index, String title, String subtitle,
      {bool isLast = false}) {
    final done = _currentStep >= index;
    final active = _currentStep == index;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: done ? AppTheme.primaryColor : Colors.grey.shade300,
                shape: BoxShape.circle,
                boxShadow: active
                    ? [
                        BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.4),
                            blurRadius: 8)
                      ]
                    : null,
              ),
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            if (!isLast)
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 2,
                height: 30,
                color: done ? AppTheme.primaryColor : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: done
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.grey,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    ).animate().fade(duration: 400.ms, delay: (80 * index).ms).slideX(begin: 0.1);
  }

  Widget _circleBtn(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
