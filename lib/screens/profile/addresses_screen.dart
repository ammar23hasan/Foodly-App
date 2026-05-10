import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import 'map_picker_screen.dart';

const _mapboxToken =
    'pk.eyJ1IjoiYW1tYXIyMyIsImEiOiJjbXAwYjc4aXMwMzhsMnNxeGJxcjA4dnhkIn0.ShO3Ar9_H2hBpmZ9gBMdfA';

// ── Default Riyadh center ──────────────────────────────────
const _riyadh = LatLng(24.6877, 46.7219);

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Addresses')),
      body: user.addresses.isEmpty
          ? _buildEmpty(context)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: user.addresses.length,
              itemBuilder: (context, index) =>
                  _buildAddressTile(context, user.addresses[index], index),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startAddFlow(context),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add Address'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No saved addresses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Add your first delivery address.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _startAddFlow(context),
            icon: const Icon(Icons.add_location_alt_outlined),
            label: const Text('Add on Map'),
          ),
        ],
      ),
    );
  }

  // ── Step 1: open map picker → get LatLng ─────────────────
  Future<void> _startAddFlow(BuildContext context) async {
    final LatLng? picked = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => const MapPickerScreen(initialPosition: _riyadh),
      ),
    );
    if (picked == null || !context.mounted) return;
    // Step 2: show form sheet
    _showAddSheet(context, picked);
  }

  // ── Step 2: fill address details ──────────────────────────
  void _showAddSheet(BuildContext context, LatLng position) {
    final labelCtrl = ValueNotifier<String>('Home');
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Riyadh');
    final zipCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sheet handle
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 18),

                const Text('Add New Address',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),

                // Mini map preview of picked location
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 130,
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: position,
                            initialZoom: 15.5,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.none,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=$_mapboxToken',
                              userAgentPackageName: 'com.yummygo.app',
                              retinaMode: true,
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: position,
                                  width: 44,
                                  height: 54,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primaryColor
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.location_on,
                                            color: Colors.white, size: 18),
                                      ),
                                      Container(
                                          width: 2,
                                          height: 10,
                                          color: AppTheme.primaryColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Tap to re-pick overlay
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              _startAddFlow(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 6)
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit_location_alt,
                                      size: 14, color: AppTheme.primaryColor),
                                  SizedBox(width: 4),
                                  Text('Change',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '📍 ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 18),

                // Label chips
                const Text('Label',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: labelCtrl,
                  builder: (_, selected, __) => Wrap(
                    spacing: 8,
                    children: ['Home', 'Work', 'Other'].map((label) {
                      final icons = {
                        'Home': Icons.home_outlined,
                        'Work': Icons.work_outline,
                        'Other': Icons.location_on_outlined,
                      };
                      return ChoiceChip(
                        avatar: Icon(icons[label]!,
                            size: 16,
                            color: selected == label
                                ? Colors.white
                                : Colors.grey),
                        label: Text(label),
                        selected: selected == label,
                        selectedColor: AppTheme.primaryColor,
                        labelStyle: TextStyle(
                            color: selected == label ? Colors.white : null),
                        onSelected: (_) => labelCtrl.value = label,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: streetCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Street address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: cityCtrl,
                        decoration: const InputDecoration(hintText: 'City'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: zipCtrl,
                        decoration: const InputDecoration(hintText: 'ZIP'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      final isFirstAddress =
                          context.read<UserProvider>().addresses.isEmpty;
                      context.read<UserProvider>().addAddress(UserAddress(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        label: labelCtrl.value,
                        street: streetCtrl.text,
                        city: cityCtrl.text,
                        zipCode: zipCtrl.text,
                        isDefault: isFirstAddress,
                        lat: position.latitude,
                        lng: position.longitude,
                      ));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Address saved! 📍'),
                            backgroundColor: Colors.green),
                      );
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save Address'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Address Tile ─────────────────────────────────────────
  Widget _buildAddressTile(
      BuildContext context, UserAddress addr, int index) {
    final iconMap = {
      'Home': Icons.home_outlined,
      'Work': Icons.work_outline,
      'Other': Icons.location_on_outlined,
    };
    final cardColor = Theme.of(context).cardColor;
    final hasCoords = addr.lat != null && addr.lng != null;

    return Slidable(
      key: ValueKey(addr.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) =>
                context.read<UserProvider>().removeAddress(addr.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
            borderRadius: BorderRadius.circular(15),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Mini Map Preview ──────────────────────────
          if (hasCoords)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 110,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter:
                            LatLng(addr.lat!, addr.lng!),
                        initialZoom: 15,
                        interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=$_mapboxToken',
                          userAgentPackageName: 'com.yummygo.app',
                          retinaMode: true,
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(addr.lat!, addr.lng!),
                              width: 36,
                              height: 44,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: addr.isDefault
                                          ? AppTheme.primaryColor
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: (addr.isDefault
                                                  ? AppTheme.primaryColor
                                                  : Colors.grey)
                                              .withValues(alpha: 0.4),
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
                                      color: addr.isDefault
                                          ? AppTheme.primaryColor
                                          : Colors.grey),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // View full map button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapPickerScreen(
                              initialPosition: LatLng(addr.lat!, addr.lng!),
                              readOnly: true,
                              readOnlyLabel: addr.label,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 6)
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.fullscreen,
                                  size: 14,
                                  color: AppTheme.primaryColor),
                              SizedBox(width: 4),
                              Text('View',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Info Row ──────────────────────────────────
          GestureDetector(
            onTap: () =>
                context.read<UserProvider>().setDefaultAddress(addr.id),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: hasCoords
                    ? const BorderRadius.vertical(bottom: Radius.circular(16))
                    : BorderRadius.circular(16),
                border: addr.isDefault
                    ? Border.all(color: AppTheme.primaryColor, width: 2)
                    : null,
                boxShadow: hasCoords
                    ? null
                    : [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10)
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: addr.isDefault
                          ? AppTheme.primaryColor.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconMap[addr.label] ?? Icons.location_on_outlined,
                      color: addr.isDefault
                          ? AppTheme.primaryColor
                          : Colors.grey,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(addr.label,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            if (addr.isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('Default',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${addr.street}, ${addr.city}'
                          '${addr.zipCode.isNotEmpty ? ' ${addr.zipCode}' : ''}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.radio_button_checked,
                      color: addr.isDefault
                          ? AppTheme.primaryColor
                          : Colors.grey.shade300),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fade(duration: 400.ms, delay: (70 * index).ms)
        .slideX(begin: 0.08);
  }
}
