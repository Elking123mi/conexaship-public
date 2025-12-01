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
              // TODO: Ver notificaciones
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
            // Saludo personalizado
            Text(
              '¡Hola, ${customer?.firstName ?? "Usuario"}! 👋',
              style: TextStyle(
                fontSize: isDesktop ? 32 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bienvenido a tu panel de control',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Tarjetas de estadísticas rápidas
            if (isDesktop)
              Row(
                children: [
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.shopping_bag,
                      title: 'Pedidos Activos',
                      value: '3',
                      color: Colors.blue,
                      subtitle: '2 en camino',
                      onTap: () => context.push('/orders'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.shopping_cart,
                      title: 'En Carrito',
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
                      title: 'Favoritos',
                      value: '12',
                      color: Colors.red,
                      subtitle: '3 con descuento',
                      onTap: () {
                        // TODO: Ver favoritos
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickStatCard(
                      icon: Icons.star,
                      title: 'Puntos',
                      value: '850',
                      color: Colors.amber,
                      subtitle: 'Nivel Gold',
                      onTap: () {
                        // TODO: Ver recompensas
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
                          title: 'Pedidos',
                          value: '3',
                          color: Colors.blue,
                          subtitle: 'Activos',
                          onTap: () => context.push('/orders'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.shopping_cart,
                          title: 'Carrito',
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
                          title: 'Favoritos',
                          value: '12',
                          color: Colors.red,
                          subtitle: 'productos',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.star,
                          title: 'Puntos',
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

            // Accesos rápidos
            Text(
              'Accesos Rápidos',
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
                  title: 'Tienda',
                  color: Colors.purple,
                  onTap: () => context.go('/'),
                ),
                _QuickAccessCard(
                  icon: Icons.local_shipping,
                  title: 'Seguimiento',
                  color: Colors.green,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.receipt_long,
                  title: 'Facturas',
                  color: Colors.indigo,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.support_agent,
                  title: 'Soporte',
                  color: Colors.teal,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.location_on,
                  title: 'Direcciones',
                  color: Colors.red.shade400,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.payment,
                  title: 'Pagos',
                  color: Colors.blue.shade400,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.settings,
                  title: 'Configuración',
                  color: Colors.grey,
                  onTap: () {},
                ),
                _QuickAccessCard(
                  icon: Icons.person,
                  title: 'Mi Perfil',
                  color: Colors.orange,
                  onTap: () => context.push('/profile'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Actividad reciente
            Text(
              'Actividad Reciente',
              style: TextStyle(
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _ActivityCard(
              icon: Icons.shopping_bag,
              title: 'Pedido #1234 enviado',
              subtitle: 'Tu pedido está en camino',
              time: 'Hace 2 horas',
              color: Colors.blue,
            ),
            _ActivityCard(
              icon: Icons.local_offer,
              title: 'Nueva oferta disponible',
              subtitle: '30% de descuento en electrónica',
              time: 'Hace 5 horas',
              color: Colors.green,
            ),
            _ActivityCard(
              icon: Icons.star,
              title: 'Has ganado 50 puntos',
              subtitle: 'Por tu última compra',
              time: 'Ayer',
              color: Colors.amber,
            ),
            _ActivityCard(
              icon: Icons.receipt_long,
              title: 'Pedido #1233 entregado',
              subtitle: 'Califica tu experiencia',
              time: 'Hace 2 días',
              color: Colors.purple,
            ),

            const SizedBox(height: 32),

            // Banner promocional
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
                    '¡Envíos GRATIS!',
                    style: TextStyle(
                      fontSize: isDesktop ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'En compras mayores a \$500',
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
                      'Comprar Ahora',
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
