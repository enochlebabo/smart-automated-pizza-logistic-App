import 'package:flutter/material.dart';

class OrderTrackingWidget extends StatelessWidget {
  final String status;
  
  const OrderTrackingWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _OrderStep(
        title: 'Order Placed',
        icon: Icons.shopping_bag_outlined,
        isActive: true,
        isCompleted: true,
      ),
      _OrderStep(
        title: 'Preparing',
        icon: Icons.restaurant_outlined,
        isActive: status == 'preparing',
        isCompleted: ['preparing', 'ready', 'dispatched', 'delivered'].contains(status),
      ),
      _OrderStep(
        title: 'Ready',
        icon: Icons.check_circle_outline,
        isActive: status == 'ready',
        isCompleted: ['ready', 'dispatched', 'delivered'].contains(status),
      ),
      _OrderStep(
        title: 'On the Way',
        icon: Icons.delivery_dining_outlined,
        isActive: status == 'dispatched',
        isCompleted: ['dispatched', 'delivered'].contains(status),
      ),
      _OrderStep(
        title: 'Delivered',
        icon: Icons.home_outlined,
        isActive: status == 'delivered',
        isCompleted: status == 'delivered',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.map((step) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: step.isCompleted
                            ? const Color(0xFF689F38)
                            : step.isActive
                                ? const Color(0xFF689F38).withOpacity(0.2)
                                : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step.icon,
                        color: step.isCompleted
                            ? Colors.white
                            : step.isActive
                                ? const Color(0xFF689F38)
                                : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: step.isActive ? FontWeight.bold : FontWeight.normal,
                        color: step.isActive ? Colors.black : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: _getProgress(status),
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF689F38),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getProgress(String status) {
    switch (status) {
      case 'pending':
        return 0.2;
      case 'preparing':
        return 0.4;
      case 'ready':
        return 0.6;
      case 'dispatched':
        return 0.8;
      case 'delivered':
        return 1.0;
      default:
        return 0.0;
    }
  }
}

class _OrderStep {
  final String title;
  final IconData icon;
  final bool isActive;
  final bool isCompleted;

  _OrderStep({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.isCompleted,
  });
}
