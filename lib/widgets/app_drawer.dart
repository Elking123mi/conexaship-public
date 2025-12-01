import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final customer = authProvider.currentCustomer;

    return Drawer(
      child: Column(
        children: [
          // Header del drawer con info del usuario
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade700,
                  Colors.orange.shade400,
                ],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: customer != null
                  ? Text(
                      _getInitials(customer.fullName),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    )
                  : const Icon(Icons.person, size: 48),
            ),
            accountName: Text(
              customer?.fullName ?? 'Invitado',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(customer?.email ?? 'No autenticado'),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Sección Principal
                _DrawerSection(title: 'Principal'),
                _DrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    context.pop();
                    context.push('/dashboard');
                  },
                ),
                _DrawerItem(
                  icon: Icons.home,
                  title: 'Inicio',
                  onTap: () {
                    context.pop();
                    context.go('/');
                  },
                ),
                _DrawerItem(
                  icon: Icons.shopping_bag,
                  title: 'Productos',
                  onTap: () {
                    context.pop();
                    context.go('/');
                  },
                ),

                const Divider(),

                // Sección de Compras
                _DrawerSection(title: 'Compras'),
                _DrawerItem(
                  icon: Icons.shopping_cart,
                  title: 'Mi Carrito',
                  badge: '3',
                  onTap: () {
                    context.pop();
                    context.push('/cart');
                  },
                ),
                _DrawerItem(
                  icon: Icons.receipt_long,
                  title: 'Mis Pedidos',
                  onTap: () {
                    context.pop();
                    context.push('/orders');
                  },
                ),
                _DrawerItem(
                  icon: Icons.favorite,
                  title: 'Favoritos',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar favoritos
                  },
                ),
                _DrawerItem(
                  icon: Icons.local_offer,
                  title: 'Ofertas',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar ofertas
                  },
                ),

                const Divider(),

                // Sección de Cuenta
                _DrawerSection(title: 'Mi Cuenta'),
                _DrawerItem(
                  icon: Icons.person,
                  title: 'Perfil',
                  onTap: () {
                    context.pop();
                    context.push('/profile');
                  },
                ),
                _DrawerItem(
                  icon: Icons.location_on,
                  title: 'Direcciones',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar direcciones
                  },
                ),
                _DrawerItem(
                  icon: Icons.payment,
                  title: 'Métodos de Pago',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar métodos de pago
                  },
                ),
                _DrawerItem(
                  icon: Icons.notifications,
                  title: 'Notificaciones',
                  badge: '5',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar notificaciones
                  },
                ),

                const Divider(),

                // Sección de Servicios
                _DrawerSection(title: 'Servicios'),
                _DrawerItem(
                  icon: Icons.local_shipping,
                  title: 'Seguimiento de Envíos',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar seguimiento
                  },
                ),
                _DrawerItem(
                  icon: Icons.help,
                  title: 'Ayuda y Soporte',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar ayuda
                  },
                ),
                _DrawerItem(
                  icon: Icons.star,
                  title: 'Recompensas',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar recompensas
                  },
                ),

                const Divider(),

                // Sección de Configuración
                _DrawerSection(title: 'Configuración'),
                _DrawerItem(
                  icon: Icons.settings,
                  title: 'Ajustes',
                  onTap: () {
                    context.pop();
                    // TODO: Implementar ajustes
                  },
                ),
                _DrawerItem(
                  icon: Icons.info,
                  title: 'Acerca de',
                  onTap: () {
                    context.pop();
                    showAboutDialog(
                      context: context,
                      applicationName: 'Conexa Ship',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.shopping_bag, size: 48, color: Colors.orange),
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),

          // Botón de logout al final
          if (authProvider.isLoggedIn)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  context.pop();
                  await authProvider.logout();
                  if (context.mounted) {
                    context.go('/');
                  }
                },
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.login, color: Colors.orange.shade700),
                title: Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  context.pop();
                  context.push('/login');
                },
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class _DrawerSection extends StatelessWidget {
  final String title;

  const _DrawerSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange.shade700),
      title: Row(
        children: [
          Expanded(child: Text(title)),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
