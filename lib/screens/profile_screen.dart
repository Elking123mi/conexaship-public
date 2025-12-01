import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final customer = authProvider.currentCustomer;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Ir a configuración
            },
          ),
        ],
      ),
      body: customer == null
          ? const Center(child: Text('No hay usuario logueado'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header con gradiente
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
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
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Avatar
                        CircleAvatar(
                          radius: isDesktop ? 80 : 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: isDesktop ? 75 : 55,
                            backgroundColor: Colors.orange.shade100,
                            child: Text(
                              _getInitials(customer.fullName),
                              style: TextStyle(
                                fontSize: isDesktop ? 48 : 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Nombre
                        Text(
                          customer.fullName,
                          style: TextStyle(
                            fontSize: isDesktop ? 32 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email
                        Text(
                          customer.email,
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Roles
                        if (customer.roles != null && customer.roles!.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: customer.roles!
                                .map((role) => Chip(
                                      label: Text(
                                        role.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.orange.shade900,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // Estadísticas
                  Padding(
                    padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatCard(
                              icon: Icons.shopping_bag,
                              title: 'Pedidos',
                              value: '12',
                              color: Colors.blue,
                            ),
                            _StatCard(
                              icon: Icons.favorite,
                              title: 'Favoritos',
                              value: '8',
                              color: Colors.red,
                            ),
                            _StatCard(
                              icon: Icons.star,
                              title: 'Puntos',
                              value: '350',
                              color: Colors.amber,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Opciones del perfil
                        _ProfileOption(
                          icon: Icons.person_outline,
                          title: 'Información Personal',
                          subtitle: 'Edita tus datos personales',
                          onTap: () {
                            // TODO: Ir a editar perfil
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.location_on_outlined,
                          title: 'Direcciones',
                          subtitle: 'Gestiona tus direcciones de envío',
                          onTap: () {
                            // TODO: Ir a direcciones
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.payment_outlined,
                          title: 'Métodos de Pago',
                          subtitle: 'Administra tus tarjetas y pagos',
                          onTap: () {
                            // TODO: Ir a métodos de pago
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.receipt_long_outlined,
                          title: 'Mis Pedidos',
                          subtitle: 'Historial y seguimiento',
                          onTap: () => context.push('/orders'),
                        ),
                        _ProfileOption(
                          icon: Icons.notifications_outlined,
                          title: 'Notificaciones',
                          subtitle: 'Configura tus preferencias',
                          onTap: () {
                            // TODO: Ir a notificaciones
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.lock_outline,
                          title: 'Seguridad',
                          subtitle: 'Cambiar contraseña y seguridad',
                          onTap: () {
                            // TODO: Ir a seguridad
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.help_outline,
                          title: 'Ayuda y Soporte',
                          subtitle: 'Preguntas frecuentes y contacto',
                          onTap: () {
                            // TODO: Ir a ayuda
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.info_outline,
                          title: 'Acerca de',
                          subtitle: 'Versión 1.0.0',
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'Conexa Ship',
                              applicationVersion: '1.0.0',
                              applicationIcon: const Icon(Icons.shopping_bag, size: 48),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Botón de cerrar sesión
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Cerrar Sesión'),
                                  content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Cerrar Sesión'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (confirm == true && context.mounted) {
                                await authProvider.logout();
                                if (context.mounted) {
                                  context.go('/');
                                }
                              }
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Cerrar Sesión'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                            ),
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
          child: Column(
            children: [
              Icon(icon, size: isDesktop ? 48 : 40, color: color),
              const SizedBox(height: 8),
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

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade50,
          child: Icon(icon, color: Colors.orange.shade700),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
