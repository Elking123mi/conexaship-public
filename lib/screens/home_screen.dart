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
  int _selectedCategoryIndex = 0;
  
  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home & Kitchen',
    'Books',
    'Sports',
    'Toys',
    'Beauty',
    'Automotive',
  ];

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
          // Top Navigation Bar - Amazon Style
          _buildTopNavBar(context, authProvider, cartProvider),
          
          // User Dashboard Section (only when logged in)
          if (authProvider.isLoggedIn)
            _buildUserDashboard(context, authProvider),
          
          // Categories Bar
          _buildCategoriesBar(),
          
          // Main Content
          Expanded(
            child: productsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productsProvider.products.isEmpty
                    ? const Center(child: Text('No products available'))
                    : RefreshIndicator(
                        onRefresh: () => productsProvider.loadProducts(),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: productsProvider.products.length,
                          itemBuilder: (context, index) {
                            final product = productsProvider.products[index];
                            return ProductCard(product: product);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  // Top Navigation Bar with Account Menu
  Widget _buildTopNavBar(BuildContext context, AuthProvider authProvider, CartProvider cartProvider) {
    return Material(
      elevation: 4,
      color: const Color(0xFF232F3E),
      child: Column(
        children: [
          // Main Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                // Menu Button (Drawer)
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: 'Menu',
                ),
                const SizedBox(width: 16),
                
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
                const SizedBox(width: 32),
                
                // Search Bar
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search for products, brands and more...',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              // TODO: Implement search
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                
                // User Account Menu
                if (authProvider.isLoggedIn) ...[
                  _buildAccountMenu(context, authProvider),
                  const SizedBox(width: 24),
                  _buildReturnsOrders(context),
                  const SizedBox(width: 24),
                ] else ...[
                  TextButton.icon(
                    icon: const Icon(Icons.person, color: Colors.white),
                    label: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () => context.push('/login'),
                  ),
                  const SizedBox(width: 16),
                ],
                
                // Cart
                _buildCartButton(context, cartProvider),
              ],
            ),
          ),
          
          // Secondary Navigation (if logged in)
          if (authProvider.isLoggedIn)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF37475A),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade800, width: 1),
                ),
              ),
              child: Row(
                children: [
                  _buildNavButton(context, Icons.dashboard, 'Dashboard', () {
                    // Toggle dashboard view
                  }),
                  _buildNavButton(context, Icons.receipt_long, 'Orders', () => context.push('/orders')),
                  _buildNavButton(context, Icons.favorite, 'Wishlist', () {}),
                  _buildNavButton(context, Icons.location_on, 'Addresses', () {}),
                  _buildNavButton(context, Icons.credit_card, 'Payment Methods', () {}),
                  _buildNavButton(context, Icons.notifications, 'Notifications', () {}),
                  const Spacer(),
                  _buildNavButton(context, Icons.settings, 'Settings', () => context.push('/profile')),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccountMenu(BuildContext context, AuthProvider authProvider) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade700,
            radius: 18,
            child: Text(
              _getInitials(authProvider.currentCustomer?.fullName ?? 'U'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                authProvider.currentCustomer?.fullName.split(' ').first ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 12),
              Text('My Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'account',
          child: Row(
            children: [
              Icon(Icons.account_circle, size: 20),
              SizedBox(width: 12),
              Text('Account Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'wishlist',
          child: Row(
            children: [
              Icon(Icons.favorite, size: 20),
              SizedBox(width: 12),
              Text('My Wishlist'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'rewards',
          child: Row(
            children: [
              Icon(Icons.card_giftcard, size: 20),
              SizedBox(width: 12),
              Text('Rewards & Coupons'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          case 'profile':
            context.push('/profile');
            break;
          case 'account':
            context.push('/profile');
            break;
          case 'wishlist':
            // TODO: Navigate to wishlist
            break;
          case 'rewards':
            // TODO: Navigate to rewards
            break;
          case 'logout':
            await authProvider.logout();
            if (context.mounted) {
              context.go('/');
            }
            break;
        }
      },
    );
  }

  Widget _buildReturnsOrders(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/orders'),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Returns',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '& Orders',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartButton(BuildContext context, CartProvider cartProvider) {
    return InkWell(
      onTap: () => context.push('/cart'),
      child: badges.Badge(
        badgeContent: Text(
          '${cartProvider.itemCount}',
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        showBadge: cartProvider.isNotEmpty,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Colors.orange.shade700,
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 28),
              SizedBox(width: 4),
              Text(
                'Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // User Dashboard Section with Quick Access Cards
  Widget _buildUserDashboard(BuildContext context, AuthProvider authProvider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange.shade700,
                radius: 32,
                child: Text(
                  _getInitials(authProvider.currentCustomer?.fullName ?? 'U'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${authProvider.currentCustomer?.fullName.split(' ').first ?? 'User'}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      authProvider.currentCustomer?.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Quick Access Cards
          Row(
            children: [
              Expanded(
                child: _buildDashboardCard(
                  context,
                  icon: Icons.receipt_long,
                  title: 'My Orders',
                  subtitle: 'Track, return, or buy again',
                  color: Colors.blue,
                  onTap: () => context.push('/orders'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDashboardCard(
                  context,
                  icon: Icons.favorite,
                  title: 'Wishlist',
                  subtitle: 'Your saved items',
                  color: Colors.pink,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDashboardCard(
                  context,
                  icon: Icons.location_on,
                  title: 'Addresses',
                  subtitle: 'Manage delivery addresses',
                  color: Colors.green,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDashboardCard(
                  context,
                  icon: Icons.credit_card,
                  title: 'Payments',
                  subtitle: 'Payment methods & cards',
                  color: Colors.orange,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDashboardCard(
                  context,
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Edit your information',
                  color: Colors.purple,
                  onTap: () => context.push('/profile'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Categories Bar
  Widget _buildCategoriesBar() {
    return Container(
      color: const Color(0xFF37475A),
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.orange.shade700 : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
