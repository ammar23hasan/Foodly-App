import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Column(
        children: [
          // Fake Map Placeholder
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.map, size: 100, color: Colors.grey.shade400),
                  ),
                  const Center(
                    child: Text('Map View Placeholder', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
          // Tracking Details
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimated Delivery', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text('15:30 PM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const Divider(height: 30),
                  _buildTrackingStep(context, 'Order Confirmed', 'Your order has been received', true),
                  _buildTrackingStep(context, 'Preparing', 'The restaurant is preparing your food', true),
                  _buildTrackingStep(context, 'On the way', 'Your driver is picking up the food', false),
                  _buildTrackingStep(context, 'Delivered', 'Enjoy your meal!', false, isLast: true),
                  
                  const Spacer(),
                  // Driver Info
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 15),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Delivery Driver', style: TextStyle(color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                          child: IconButton(
                            icon: const Icon(Icons.call, color: AppTheme.primaryColor),
                            onPressed: () {},
                          ),
                        ),
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

  Widget _buildTrackingStep(BuildContext context, String title, String subtitle, bool isCompleted, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.primaryColor : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppTheme.primaryColor : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isCompleted ? Colors.black : Colors.grey)),
              const SizedBox(height: 5),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
