import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';

const _mapboxToken =
    'pk.eyJ1IjoiYW1tYXIyMyIsImEiOiJjbXAwYjc4aXMwMzhsMnNxeGJxcjA4dnhkIn0.ShO3Ar9_H2hBpmZ9gBMdfA';

/// Full-screen interactive map picker.
/// Returns a [LatLng] when the user confirms their location.
class MapPickerScreen extends StatefulWidget {
  final LatLng initialPosition;
  final bool readOnly;       // read-only view mode
  final String? readOnlyLabel;

  const MapPickerScreen({
    super.key,
    this.initialPosition = const LatLng(24.6877, 46.7219), // Riyadh
    this.readOnly = false,
    this.readOnlyLabel,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen>
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late LatLng _selected;
  bool _isMoving = false;

  late final AnimationController _pinAnim;
  late final Animation<double> _pinLift;
  late final Animation<double> _shadowScale;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selected = widget.initialPosition;

    _pinAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _pinLift = Tween<double>(begin: 0, end: 18)
        .animate(CurvedAnimation(parent: _pinAnim, curve: Curves.easeOut));
    _shadowScale = Tween<double>(begin: 1.0, end: 0.5)
        .animate(CurvedAnimation(parent: _pinAnim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pinAnim.dispose();
    super.dispose();
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    setState(() {
      _selected = camera.center;
      if (!_isMoving) {
        _isMoving = true;
        _pinAnim.forward();
      }
    });
  }

  void _onMoveEnd() {
    setState(() => _isMoving = false);
    _pinAnim.reverse();
  }

  String get _coordsLabel =>
      '${_selected.latitude.toStringAsFixed(5)},  ${_selected.longitude.toStringAsFixed(5)}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapStyle = isDark ? 'dark-v11' : 'streets-v12';
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.readOnly ? widget.readOnlyLabel ?? 'Location' : 'Pick Your Location'),
        actions: [
          if (!widget.readOnly)
            TextButton(
              onPressed: () => Navigator.pop(context, _selected),
              child: const Text(
                'Done',
                style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selected,
              initialZoom: 15.5,
              minZoom: 5,
              maxZoom: 18,
              onPositionChanged: widget.readOnly ? null : _onPositionChanged,
              onMapEvent: (event) {
                if (!widget.readOnly &&
                    (event is MapEventFlingAnimationEnd ||
                        event is MapEventScrollWheelZoom)) {
                  _onMoveEnd();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/$mapStyle/tiles/256/{z}/{x}/{y}@2x?access_token=$_mapboxToken',
                userAgentPackageName: 'com.yummygo.app',
                retinaMode: true,
              ),

              // Read-only: show a fixed marker
              if (widget.readOnly)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected,
                      width: 56,
                      height: 70,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: AppTheme.primaryColor
                                        .withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2),
                              ],
                            ),
                            child: const Icon(Icons.location_on,
                                color: Colors.white, size: 24),
                          ),
                          Container(
                              width: 2, height: 12, color: AppTheme.primaryColor),
                          Container(
                            width: 8,
                            height: 4,
                            decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // ── Center Pin (picker mode) ──────────────────
          if (!widget.readOnly)
            IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _pinAnim,
                  builder: (_, __) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pin head
                        Transform.translate(
                          offset: Offset(0, -_pinLift.value),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.45),
                                  blurRadius: _isMoving ? 18 : 10,
                                  spreadRadius: _isMoving ? 4 : 1,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.location_on,
                                color: Colors.white, size: 26),
                          ),
                        ),
                        // Pin needle
                        Transform.translate(
                          offset: Offset(0, -_pinLift.value),
                          child: Container(
                              width: 3,
                              height: 18,
                              color: AppTheme.primaryColor),
                        ),
                        // Shadow under pin
                        Transform.scale(
                          scale: _shadowScale.value,
                          child: Container(
                            width: 14,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

          // ── Instruction chip ──────────────────────────
          if (!widget.readOnly)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pan_tool_alt_outlined,
                          size: 16, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        _isMoving ? 'Move to your location…' : 'Drag map to position pin',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Attribution ───────────────────────────────
          Positioned(
            bottom: widget.readOnly ? 4 : 170,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(4)),
              child: const Text('© Mapbox © OSM',
                  style: TextStyle(fontSize: 8, color: Colors.black54)),
            ),
          ),

          // ── Bottom Confirm Panel (picker mode) ────────
          if (!widget.readOnly)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                decoration: BoxDecoration(
                  color: scaffoldBg,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(26)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 16),

                    // Coordinates display
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.my_location,
                              color: AppTheme.primaryColor, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Selected Location',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                const SizedBox(height: 2),
                                Text(
                                  _coordsLabel,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context, _selected),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Confirm This Location'),
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
}
