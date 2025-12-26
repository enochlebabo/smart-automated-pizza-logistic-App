import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/providers/menu_provider.dart';
import '../../../../core/providers/cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().fetchMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Column(
      children: [
        // Categories
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip('All', _selectedCategory == 'All'),
              const SizedBox(width: 8),
              ...menuProvider.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildCategoryChip(category, _selectedCategory == category),
                );
              }),
            ],
          ),
        ),
        
        // Menu Items
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => menuProvider.fetchMenu(),
            child: _buildMenuList(menuProvider, cartProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? label : 'All';
        });
      },
      selectedColor: const Color(0xFF689F38),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildMenuList(MenuProvider menuProvider, CartProvider cartProvider) {
    if (menuProvider.isLoading) {
      return _buildShimmerLoader();
    }

    if (menuProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(menuProvider.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: menuProvider.fetchMenu,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final items = _selectedCategory == 'All'
        ? menuProvider.menuItems
        : menuProvider.getByCategory(_selectedCategory);

    if (items.isEmpty) {
      return const Center(
        child: Text('No items found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMenuItem(item, cartProvider);
      },
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(MenuItem item, CartProvider cartProvider) {
    final isInCart = cartProvider.items.containsKey(item.id);
    final cartItem = isInCart ? cartProvider.items[item.id] : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF689F38).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.fastfood,
            color: Color(0xFF689F38),
            size: 30,
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF689F38),
              ),
            ),
          ],
        ),
        trailing: isInCart
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF689F38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => cartProvider.removeItem(item.id),
                    ),
                    Text(
                      '${cartItem!.quantity}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => cartProvider.addItem(
                        item.id,
                        item.name,
                        item.price,
                      ),
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  cartProvider.addItem(
                    item.id,
                    item.name,
                    item.price,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${item.name} to cart'),
                      backgroundColor: const Color(0xFF689F38),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF689F38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Add'),
              ),
      ),
    );
  }
}
