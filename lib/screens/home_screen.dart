import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Sticky Amazon-style header
          Material(
            elevation: 4,
            color: const Color(0xFF232F3E),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  // Logo
                  Row(
                    children: [
                      Icon(Icons.shopping_bag, color: Colors.orange.shade700, size: 32),
                      const SizedBox(width: 8),
                      const Text(
                        'ConexaShip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Search bar
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search for products, brands and more...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (value) {
                          // TODO: Implement search
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Account/Login
                  authProvider.isLoggedIn
                      ? PopupMenuButton<void>(
                          icon: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              _getInitials(authProvider.currentCustomer?.fullName ?? 'U'),
                              style: const TextStyle(
                                color: Color(0xFFFF9900),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          tooltip: 'My Account',
                          itemBuilder: (context) => <PopupMenuEntry<void>>[
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.dashboard, size: 20),
                                  const SizedBox(width: 12),
                                  const Text('Dashboard'),
                                ],
                              ),
                              onTap: () => Future.delayed(
                                Duration.zero,
                                () => context.push('/dashboard'),
                              ),
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.person, size: 20),
                                  const SizedBox(width: 12),
                                  const Text('My Profile'),
                                ],
                              ),
                              onTap: () => Future.delayed(
                                Duration.zero,
                                () => context.push('/profile'),
                              ),
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.receipt_long, size: 20),
                                  const SizedBox(width: 12),
                                  const Text('My Orders'),
                                ],
                              ),
                              onTap: () => Future.delayed(
                                Duration.zero,
                                () => context.push('/orders'),
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.logout, color: Colors.red, size: 20),
                                  const SizedBox(width: 12),
                                  const Text('Logout', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                              onTap: () async {
                                await Future.delayed(Duration.zero);
                                if (context.mounted) {
                                  await authProvider.logout();
                                  if (context.mounted) {
                                    context.go('/');
                                  }
                                }
                              },
                            ),
                          ],
                        )
                      : TextButton.icon(
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text('Sign In', style: TextStyle(color: Colors.white)),
                          onPressed: () => context.push('/login'),
                        ),
                  const SizedBox(width: 16),
                  // Cart
                  badges.Badge(
                    badgeContent: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    showBadge: cartProvider.isNotEmpty,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      tooltip: 'View Cart',
                      onPressed: () => context.push('/cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Categories bar (horizontal, sticky)
          Container(
            color: const Color(0xFF37475A),
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _CategoryChip(
                  label: 'Electronics',
                  icon: Icons.devices,
                  onTap: () => productsProvider.loadProducts(category: 'Electronics'),
                ),
                _CategoryChip(
                  label: 'Mobile Phones',
                  icon: Icons.smartphone,
                  onTap: () => productsProvider.loadProducts(category: 'Mobile Phones'),
                ),
                _CategoryChip(
                  label: 'Audio',
                  icon: Icons.headphones,
                  onTap: () => productsProvider.loadProducts(category: 'Audio'),
                ),
                _CategoryChip(
                  label: 'Video Games',
                  icon: Icons.sports_esports,
                  onTap: () => productsProvider.loadProducts(category: 'Video Games'),
                ),
                _CategoryChip(
                  label: 'Home',
                  icon: Icons.chair,
                  onTap: () => productsProvider.loadProducts(category: 'Home'),
                ),
                _CategoryChip(
                  label: 'Fashion',
                  icon: Icons.checkroom,
                  onTap: () => productsProvider.loadProducts(category: 'Fashion'),
                ),
                _CategoryChip(
                  label: 'Toys',
                  icon: Icons.toys,
                  onTap: () => productsProvider.loadProducts(category: 'Toys'),
                ),
              ],
            ),
          ),
          // Main content scrollable
          Expanded(
            child: productsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => productsProvider.loadProducts(),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // Banner principal
                        Container(
                          height: 220,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade700,
                                Colors.orange.shade400,
                                Colors.orange.shade200,
                              ],
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Welcome to ConexaShip',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Best deals, fast shipping, and more!',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Featured products
                        if (productsProvider.featuredProducts.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: Text(
                              'Featured Deals',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        // Grid of products
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = 2;
                              if (constraints.maxWidth > 1200) {
                                crossAxisCount = 5;
                              } else if (constraints.maxWidth > 900) {
                                crossAxisCount = 4;
                              } else if (constraints.maxWidth > 600) {
                                crossAxisCount = 3;
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: productsProvider.products.length,
                                itemBuilder: (context, index) {
                                  final product = productsProvider.products[index];
                                  return ProductCard(product: product);
                                },
                              );
                            },
                          ),
                        ),
                        // Footer
                        Container(
                          margin: const EdgeInsets.only(top: 32),
                          color: const Color(0xFF232F3E),
                          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/logo_amazon_style.png', height: 32),
                                  const SizedBox(width: 16),
                                  Text('ConexaShip', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 32,
                                runSpacing: 12,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('About Us', style: TextStyle(color: Colors.white70)),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Contact', style: TextStyle(color: Colors.white70)),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Terms of Service', style: TextStyle(color: Colors.white70)),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Privacy Policy', style: TextStyle(color: Colors.white70)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Icons.email, color: Colors.white70, size: 18),
                                  const SizedBox(width: 8),
                                  Text('support@conexaship.com', style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.white70, size: 18),
                                  const SizedBox(width: 8),
                                  Text('+1 800 123 4567', style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Icons.copyright, color: Colors.white38, size: 16),
                                  const SizedBox(width: 8),
                                  Text('2025 ConexaShip. All rights reserved.', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                                ],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
