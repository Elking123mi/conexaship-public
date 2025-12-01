import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final customer = authProvider.currentCustomer;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
            IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: View notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personalized greeting
            Text(
              'Hello, ${customer?.firstName ?? "User"}! 👋',
              style: TextStyle(
                fontSize: isDesktop ? 32 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to your control panel',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Quick stats cards
            if (isDesktop)
              Row(
                children: [
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.shopping_bag,
                      title: 'Active Orders',
                      value: '3',
                      color: Colors.blue,
                      subtitle: '2 on the way',
                      onTap: () => context.push('/orders'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.shopping_cart,
                      title: 'In Cart',
                      value: '${cartProvider.itemCount}',
                      color: Colors.orange,
                      subtitle: '\$${cartProvider.total.toStringAsFixed(2)}',
                      onTap: () => context.push('/cart'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.favorite,
                      title: 'Wishlist',
                      value: '12',
                      color: Colors.red,
                      subtitle: '3 with discount',
                      onTap: () {
                        // TODO: View wishlist
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.star,
                      title: 'Points',
                      value: '850',
                      color: Colors.amber,
                      subtitle: 'Gold Level',
                      onTap: () {
                        // TODO: View rewards
                      },
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.shopping_bag,
                          title: 'Orders',
                          value: '3',
                          color: Colors.blue,
                          subtitle: 'Active',
                          onTap: () => context.push('/orders'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.shopping_cart,
                          title: 'Cart',
                          value: '${cartProvider.itemCount}',
                          color: Colors.orange,
                          subtitle: 'items',
                          onTap: () => context.push('/cart'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.favorite,
                          title: 'Wishlist',
                          value: '12',
                          color: Colors.red,
                          subtitle: 'products',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.star,
                          title: 'Points',
                          value: '850',
                          color: Colors.amber,
                          subtitle: 'Gold',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 32),

            // Quick Access
            Text(
              'Quick Access',
              style: TextStyle(
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: isDesktop ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isDesktop ? 1.5 : 1.2,
              children: [
                _QuickAccessCard(
                  icon: Icons.store,
                  title: 'Store',
                  color: Colors.purple,
                  onTap: () => context.go('/'),
                ),
                _QuickAccessCard(
                  icon: Icons.local_shipping,
                  title: 'Tracking',
                  color: Colors.green,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.receipt_long,
                  title: 'Invoices',
                  color: Colors.indigo,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.support_agent,
                  title: 'Support',
                  color: Colors.teal,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.location_on,
                  title: 'Addresses',
                  color: Colors.red.shade400,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.payment,
                  title: 'Payments',
                  color: Colors.blue.shade400,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  color: Colors.grey,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.person,
                  title: 'My Profile',
                  color: Colors.orange,
                  onTap: () => context.push('/profile'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Activity
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _ActivityCard(
              icon: Icons.shopping_bag,
              title: 'Order #1234 shipped',
              subtitle: 'Your order is on the way',
              time: '2 hours ago',
              color: Colors.blue,
            ),
            _ActivityCard(
              icon: Icons.local_offer,
              title: 'New deal available',
              subtitle: '30% off electronics',
              time: '5 hours ago',
              color: Colors.green,
            ),
            _ActivityCard(
              icon: Icons.star,
              title: 'You earned 50 points',
              subtitle: 'From your last purchase',
              time: 'Yesterday',
              color: Colors.amber,
            ),
            _ActivityCard(
              icon: Icons.receipt_long,
              title: 'Order #1233 delivered',
              subtitle: 'Rate your experience',
              time: '2 days ago',
              color: Colors.purple,
            ),

            const SizedBox(height: 32),

            // Promotional banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade700,
                    Colors.orange.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FREE Shipping!',
                    style: TextStyle(
                      fontSize: isDesktop ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'On purchases over \$500',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Shop Now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 24 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isDesktop ? 48 : 36, color: color),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isDesktop ? 14 : 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
