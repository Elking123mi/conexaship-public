import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

const _kPrimary = Color(0xFF0B3D6E);
const _kAccent = Color(0xFF00C9A7);
const _kAccentDark = Color(0xFF00A98B);
const _kBg = Color(0xFFF8FAFC);
const _kBorder = Color(0xFFE5E7EB);
const _kText = Color(0xFF111827);
const _kMuted = Color(0xFF6B7280);

// ─────────────────────────────────────────────────────
//  Panel del cliente – rediseño fintech
// ─────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final customer = authProvider.currentCustomer;
    final firstName = customer?.firstName ?? 'Cliente';
    final mobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: _kBg,
      body: mobile
          ? _mobileLayout(firstName)
          : _desktopLayout(firstName),
    );
  }

  // ── Desktop layout (sidebar + content) ────────────
  Widget _desktopLayout(String firstName) {
    return Row(
      children: [
        _Sidebar(
          firstName: firstName,
          selectedIndex: _selectedTab,
          onSelect: (i) => setState(() => _selectedTab = i),
        ),
        Expanded(
          child: Column(
            children: [
              _TopBar(firstName: firstName),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: _tabContent(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Mobile layout (bottom nav) ─────────────────────
  Widget _mobileLayout(String firstName) {
    return Column(
      children: [
        _TopBar(firstName: firstName, mobile: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _tabContent(),
          ),
        ),
        BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (i) => setState(() => _selectedTab = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _kPrimary,
          unselectedItemColor: _kMuted,
          backgroundColor: Colors.white,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Resumen'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Paquetes'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Facturas'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
          ],
        ),
      ],
    );
  }

  Widget _tabContent() {
    switch (_selectedTab) {
      case 0:
        return _SummaryTab();
      case 1:
        return _PackagesTab();
      case 2:
        return _InvoicesTab();
      case 3:
        return _ProfileTab();
      default:
        return _SummaryTab();
    }
  }
}

// ─────────────────────────────────────────────────────
//  Sidebar (desktop)
// ─────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final String firstName;
  final int selectedIndex;
  final void Function(int) onSelect;
  const _Sidebar({required this.firstName, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.dashboard_rounded, 'Resumen'),
      (Icons.inventory_2_outlined, 'Mis paquetes'),
      (Icons.receipt_long_outlined, 'Facturas'),
      (Icons.person_outline_rounded, 'Perfil'),
    ];

    return Container(
      width: 240,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF08274A),
        border: Border(right: BorderSide(color: Color(0xFF0F3D6E))),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: _kAccent, shape: BoxShape.circle),
                  child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('ConexaShip', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.08), height: 1),
          const SizedBox(height: 16),
          // User
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18, backgroundColor: _kAccent,
                    child: Text(firstName[0], style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(firstName, style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                            overflow: TextOverflow.ellipsis),
                        const Text('Cliente Plus', style: TextStyle(
                            color: _kAccent, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Nav items
          ...items.asMap().entries.map((e) {
            final selected = e.key == selectedIndex;
            return GestureDetector(
              onTap: () => onSelect(e.key),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: selected ? Border.all(color: _kAccent.withOpacity(0.3)) : null,
                ),
                child: Row(
                  children: [
                    Icon(e.value.$1,
                        color: selected ? _kAccent : Colors.white54, size: 20),
                    const SizedBox(width: 12),
                    Text(e.value.$2, style: TextStyle(
                        color: selected ? Colors.white : Colors.white60,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        fontSize: 14)),
                    if (selected) ...[const Spacer(), Container(
                      width: 4, height: 4, decoration: const BoxDecoration(
                          color: _kAccent, shape: BoxShape.circle))],
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton.icon(
              onPressed: () => context.go('/'),
              icon: Icon(Icons.logout_rounded, color: Colors.white38, size: 18),
              label: const Text('Salir', style: TextStyle(color: Colors.white38, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Top Bar
// ─────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String firstName;
  final bool mobile;
  const _TopBar({required this.firstName, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          if (mobile) ...[
            Row(children: [
              Container(width: 28, height: 28,
                  decoration: const BoxDecoration(color: _kPrimary, shape: BoxShape.circle),
                  child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 16)),
              const SizedBox(width: 8),
              const Text('ConexaShip', style: TextStyle(
                  color: _kPrimary, fontWeight: FontWeight.w800, fontSize: 15)),
            ]),
          ] else
            Text('Hola, $firstName 👋', style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 20, color: _kText)),
          const Spacer(),
          // Casillero chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _kBg, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined, color: _kPrimary, size: 16),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Tu casillero Miami', style: TextStyle(
                        color: _kMuted, fontSize: 10)),
                    const Text('CSH-ECU-10042', style: TextStyle(
                        color: _kText, fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: _kMuted),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Tab: Resumen
// ─────────────────────────────────────────────────────
class _SummaryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats row
        mobile
            ? Column(children: [
                _statCard('3', 'Paquetes este año', Icons.inventory_2_outlined, _kPrimary),
                const SizedBox(height: 12),
                _statCard('1', 'En camino', Icons.flight_outlined, _kAccentDark),
                const SizedBox(height: 12),
                _statCard('US\$1,240', 'Total importado', Icons.paid_outlined, const Color(0xFF6366F1)),
                const SizedBox(height: 12),
                _statCard('1 disponible', 'Cupo 4×4', Icons.calculate_outlined, const Color(0xFFF59E0B)),
              ])
            : Row(
                children: [
                  Expanded(child: _statCard('3', 'Paquetes este año', Icons.inventory_2_outlined, _kPrimary)),
                  const SizedBox(width: 16),
                  Expanded(child: _statCard('1', 'En camino', Icons.flight_outlined, _kAccentDark)),
                  const SizedBox(width: 16),
                  Expanded(child: _statCard('US\$1,240', 'Total importado', Icons.paid_outlined, const Color(0xFF6366F1))),
                  const SizedBox(width: 16),
                  Expanded(child: _statCard('1 disponible', 'Cupo 4×4', Icons.calculate_outlined, const Color(0xFFF59E0B))),
                ],
              ),
        const SizedBox(height: 32),
        // 4x4 Quota card
        _QuotaCard(),
        const SizedBox(height: 24),
        // Active shipments
        const Text('Envíos activos', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 20, color: _kText)),
        const SizedBox(height: 16),
        _ShipmentCard(
          trackingId: 'CSH-2026-00124',
          productName: 'MacBook Air M3 13"',
          emoji: '💻',
          status: ShipmentStatus.inTransit,
          date: '18 Jun 2026',
          fromStore: 'Amazon',
          weight: '3.2 lbs',
          price: 'US\$1,389',
        ),
        const SizedBox(height: 12),
        _ShipmentCard(
          trackingId: 'CSH-2026-00119',
          productName: 'Sony WH-1000XM5',
          emoji: '🎧',
          status: ShipmentStatus.inspected,
          date: '22 Jun 2026',
          fromStore: 'Best Buy',
          weight: '0.8 lbs',
          price: 'US\$450',
        ),
        const SizedBox(height: 32),
        // Quick actions
        const Text('Acciones rápidas', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 20, color: _kText)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: [
            _quickAction(context, Icons.calculate_rounded, 'Calculadora 4×4', '/calculator'),
            _quickAction(context, Icons.local_offer_rounded, 'Ver ofertas', '/offers'),
            _quickAction(context, Icons.groups_rounded, 'Compras grupales', '/group-buy'),
            _quickAction(context, Icons.workspace_premium_rounded, 'ConexaShip Plus', '/membership'),
            _quickAction(context, Icons.track_changes_rounded, 'Rastrear paquete', '/tracking'),
            _quickAction(context, Icons.chat_rounded, 'WhatsApp', '/'),
          ],
        ),
      ],
    );
  }

  Widget _quickAction(BuildContext context, IconData icon, String label, String route) =>
      GestureDetector(
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _kAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _kAccentDark, size: 18),
              ),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13, color: _kText)),
            ],
          ),
        ),
      );
}

Widget _statCard(String value, String label, IconData icon, Color color) =>
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 20, color: color)),
              Text(label, style: const TextStyle(color: _kMuted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );

// ─────────────────────────────────────────────────────
//  4×4 Quota Card
// ─────────────────────────────────────────────────────
class _QuotaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF08274A), _kPrimary],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_rounded, color: _kAccent, size: 22),
              const SizedBox(width: 10),
              const Text('Cupo anual 4×4', style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(100),
                ),
                child: const Text('1 cupo libre', style: TextStyle(
                    color: _kAccent, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(4, (i) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 44,
                decoration: BoxDecoration(
                  color: i < 3 ? _kAccent : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: i >= 3 ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
                ),
                child: Center(
                  child: i < 3
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                      : Text('${i + 1}', style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontWeight: FontWeight.w700)),
                ),
              ),
            )),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(width: 10, height: 10, decoration: const BoxDecoration(
                          color: _kAccent, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('3 usados · US\$1,240 declarados',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('1 disponible · hasta US\$400',
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                    ]),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/calculator'),
                icon: Icon(Icons.open_in_new_rounded, size: 14, color: _kAccent),
                label: const Text('Calcular', style: TextStyle(color: _kAccent, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Shipment States
// ─────────────────────────────────────────────────────
enum ShipmentStatus { ordered, received, inspected, inTransit, customs, delivered }

class _ShipmentCard extends StatelessWidget {
  final String trackingId, productName, emoji, date, fromStore, weight, price;
  final ShipmentStatus status;
  const _ShipmentCard({
    required this.trackingId, required this.productName, required this.emoji,
    required this.status, required this.date, required this.fromStore,
    required this.weight, required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final states = [
      ShipmentStatus.ordered, ShipmentStatus.received, ShipmentStatus.inspected,
      ShipmentStatus.inTransit, ShipmentStatus.customs, ShipmentStatus.delivered,
    ];
    final labels = ['Comprada', 'En bodega', 'Inspeccionada', 'En camino', 'Aduana', 'Entregada'];
    final currentIdx = states.indexOf(status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: _kBg, borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15, color: _kText),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(fromStore, style: const TextStyle(color: _kMuted, fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(width: 3, height: 3, decoration: const BoxDecoration(
                            color: _kMuted, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(weight, style: const TextStyle(color: _kMuted, fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(width: 3, height: 3, decoration: const BoxDecoration(
                            color: _kMuted, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(price, style: const TextStyle(
                            color: _kPrimary, fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(_statusLabel(status), style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.w700, fontSize: 11)),
                  ),
                  const SizedBox(height: 4),
                  Text(trackingId, style: const TextStyle(color: _kMuted, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar
          Row(
            children: states.asMap().entries.map((e) {
              final done = e.key <= currentIdx;
              final active = e.key == currentIdx;
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: done ? _kAccent : _kBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(labels[e.key], textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          color: active ? _kAccentDark : done ? _kMuted : _kBorder,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Photos row (mock)
          Row(
            children: [
              const Text('Fotos:', style: TextStyle(color: _kMuted, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              ...List.generate(3, (i) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: _kBg, borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _kBorder),
                    ),
                    child: const Icon(Icons.photo_outlined, color: _kMuted, size: 18),
                  )),
              const Text('+2 más', style: TextStyle(color: _kMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(ShipmentStatus s) {
    switch (s) {
      case ShipmentStatus.ordered: return 'Comprado';
      case ShipmentStatus.received: return 'En bodega';
      case ShipmentStatus.inspected: return 'Inspeccionado';
      case ShipmentStatus.inTransit: return 'En camino';
      case ShipmentStatus.customs: return 'En aduana';
      case ShipmentStatus.delivered: return 'Entregado';
    }
  }

  Color _statusColor(ShipmentStatus s) {
    switch (s) {
      case ShipmentStatus.delivered: return const Color(0xFF10B981);
      case ShipmentStatus.inTransit:
      case ShipmentStatus.customs: return const Color(0xFFF59E0B);
      default: return _kAccentDark;
    }
  }
}

// ─────────────────────────────────────────────────────
//  Tab: Mis paquetes
// ─────────────────────────────────────────────────────
class _PackagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Historial de paquetes', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 20, color: _kText)),
        const SizedBox(height: 16),
        _ShipmentCard(
          trackingId: 'CSH-2026-00124',
          productName: 'MacBook Air M3 13"',
          emoji: '💻',
          status: ShipmentStatus.inTransit,
          date: '18 Jun 2026',
          fromStore: 'Amazon',
          weight: '3.2 lbs',
          price: 'US\$1,389',
        ),
        const SizedBox(height: 12),
        _ShipmentCard(
          trackingId: 'CSH-2026-00119',
          productName: 'Sony WH-1000XM5',
          emoji: '🎧',
          status: ShipmentStatus.inspected,
          date: '22 Jun 2026',
          fromStore: 'Best Buy',
          weight: '0.8 lbs',
          price: 'US\$450',
        ),
        const SizedBox(height: 12),
        _ShipmentCard(
          trackingId: 'CSH-2026-00098',
          productName: 'Raspberry Pi 5 Kit',
          emoji: '🔧',
          status: ShipmentStatus.delivered,
          date: '05 May 2026',
          fromStore: 'Micro Center',
          weight: '1.1 lbs',
          price: 'US\$130',
        ),
        const SizedBox(height: 12),
        _ShipmentCard(
          trackingId: 'CSH-2025-00412',
          productName: 'iPad Pro 12.9" M2',
          emoji: '📱',
          status: ShipmentStatus.delivered,
          date: '12 Nov 2025',
          fromStore: 'Amazon',
          weight: '1.5 lbs',
          price: 'US\$1,270',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
//  Tab: Facturas
// ─────────────────────────────────────────────────────
class _InvoicesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final invoices = [
      _InvoiceData('FAC-2026-00124', '18 Jun 2026', 'MacBook Air M3', 'US\$1,389', true),
      _InvoiceData('FAC-2026-00119', '22 Jun 2026', 'Sony WH-1000XM5', 'US\$450', true),
      _InvoiceData('FAC-2026-00098', '05 May 2026', 'Raspberry Pi 5 Kit', 'US\$130', true),
      _InvoiceData('FAC-2025-00412', '12 Nov 2025', 'iPad Pro 12.9" M2', 'US\$1,270', true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Facturas y pagos', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 20, color: _kText)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            children: invoices.asMap().entries.map((e) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: e.key < invoices.length - 1
                        ? const Border(bottom: BorderSide(color: _kBorder))
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: _kBg, borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.receipt_outlined, color: _kMuted, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.value.product, style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14, color: _kText)),
                            Text('${e.value.number} · ${e.value.date}',
                                style: const TextStyle(color: _kMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                      Text(e.value.amount, style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15, color: _kPrimary)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text('Pagado', style: TextStyle(
                            color: Color(0xFF065F46), fontWeight: FontWeight.w700, fontSize: 11)),
                      ),
                    ],
                  ),
                )).toList(),
          ),
        ),
      ],
    );
  }
}

class _InvoiceData {
  final String number, date, product, amount;
  final bool paid;
  const _InvoiceData(this.number, this.date, this.product, this.amount, this.paid);
}

// ─────────────────────────────────────────────────────
//  Tab: Perfil
// ─────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mi perfil', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 20, color: _kText)),
        const SizedBox(height: 20),
        // Profile card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36, backgroundColor: _kPrimary,
                child: const Text('C', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cliente ConexaShip', style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 18, color: _kText)),
                    const SizedBox(height: 4),
                    const Text('cliente@email.com', style: TextStyle(color: _kMuted)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _kAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text('ConexaShip Plus ⭐', style: TextStyle(
                          color: _kAccentDark, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Casillero info
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.location_on_outlined, color: _kPrimary, size: 20),
                SizedBox(width: 8),
                Text('Dirección del casillero en Miami', style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15, color: _kText)),
              ]),
              const SizedBox(height: 16),
              _addressRow('Nombre:', 'Cliente ConexaShip CSH-ECU-10042'),
              _addressRow('Dirección:', '3750 NW 87th Ave Suite 450'),
              _addressRow('Ciudad:', 'Miami, FL 33178'),
              _addressRow('País:', 'Estados Unidos'),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.copy_outlined, size: 16),
                label: const Text('Copiar dirección completa'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kPrimary,
                  side: const BorderSide(color: _kPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Menu items
        _profileMenuItem(Icons.notifications_outlined, 'Notificaciones'),
        _profileMenuItem(Icons.security_outlined, 'Seguridad'),
        _profileMenuItem(Icons.help_outline_rounded, 'Ayuda y soporte'),
        _profileMenuItem(Icons.logout_rounded, 'Cerrar sesión', isDestructive: true),
      ],
    );
  }

  Widget _addressRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 90, child: Text(label, style: const TextStyle(
                color: _kMuted, fontSize: 13))),
            Expanded(child: Text(value, style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13, color: _kText))),
          ],
        ),
      );

  Widget _profileMenuItem(IconData icon, String label, {bool isDestructive = false}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kBorder),
        ),
        child: ListTile(
          leading: Icon(icon, color: isDestructive ? Colors.red : _kPrimary, size: 20),
          title: Text(label, style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14,
              color: isDestructive ? Colors.red : _kText)),
          trailing: isDestructive
              ? null
              : const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _kMuted),
          onTap: () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}
