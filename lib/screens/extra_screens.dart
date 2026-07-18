import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _kPrimary = Color(0xFF0B3D6E);
const _kAccent = Color(0xFF00C9A7);
const _kAccentDark = Color(0xFF00A98B);
const _kBg = Color(0xFFF8FAFC);
const _kBorder = Color(0xFFE5E7EB);
const _kText = Color(0xFF111827);
const _kMuted = Color(0xFF6B7280);

// ─── Offers Screen ────────────────────────────────────
class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String _selectedCategory = 'Todos';

  final _categories = ['Todos', 'Tecnología', 'Electrónica', 'Herramientas', 'Ropa', 'Hogar'];

  final _offers = [
    _OfferItem('💻', 'Best Buy', 'Open Box', 'Dell XPS 15 Open Box', 1299, 849, 'Tecnología', 'Excelente estado. Con todos los accesorios originales.'),
    _OfferItem('📷', 'B&H', 'Refurbished', 'Sony A7 IV Certified Refurb', 2499, 1799, 'Electrónica', 'Certificado por Sony. Garantía de 1 año.'),
    _OfferItem('⌚', 'Amazon', 'Oferta del día', 'Apple Watch Series 9', 399, 269, 'Electrónica', 'Nuevo sellado. Oferta por tiempo limitado.'),
    _OfferItem('🎮', 'Walmart', 'Liquidación', 'PS5 Slim Bundle + 2 juegos', 499, 399, 'Electrónica', 'Incluye PS5 Slim + Spider-Man 2 + FIFA 25.'),
    _OfferItem('🔧', 'Micro Center', 'Especial', 'Ryzen 9 9900X CPU', 449, 329, 'Tecnología', 'Procesador desktop de última generación.'),
    _OfferItem('📦', 'Amazon', 'Prime Deal', 'Echo Show 15 2da Gen', 249, 169, 'Hogar', 'Smart display para tu cocina u oficina.'),
    _OfferItem('🔨', 'Home Depot', 'Liquidación', 'DeWalt Drill Combo Kit', 299, 189, 'Herramientas', 'Kit completo con taladro, atornillador y accesorios.'),
    _OfferItem('👟', 'Amazon', 'Descuento', 'Nike Air Max 270 (varios tallas)', 130, 89, 'Ropa', 'Disponible en tallas 7–12 US. Nuevo.'),
    _OfferItem('🖥️', 'Newegg', 'Open Box', 'LG 27" 4K Monitor (27UK850)', 599, 379, 'Tecnología', 'Open Box grado A. Funciona perfectamente.'),
    _OfferItem('📱', 'Best Buy', 'Refurbished', 'iPad Pro 12.9" M2 Certified', 1099, 769, 'Tecnología', 'Certificado Apple. Con garantía de 90 días.'),
    _OfferItem('🎧', 'Amazon', 'Descuento', 'Sony WH-1000XM5', 349, 249, 'Electrónica', 'Los mejores audífonos con cancelación de ruido.'),
    _OfferItem('🔆', 'Home Depot', 'Especial', 'Philips Hue Starter Kit', 199, 129, 'Hogar', 'Kit inicial con 3 focos y hub incluido.'),
  ];

  List<_OfferItem> get _filtered =>
      _selectedCategory == 'Todos' ? _offers : _offers.where((o) => o.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _kPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Ofertas exclusivas',
            style: TextStyle(fontWeight: FontWeight.w800, color: _kPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _kBorder),
        ),
      ),
      body: Column(
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 40, vertical: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF08274A), _kPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Text('Productos seleccionados para Ecuador',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Precios en USA + envío estimado. Actualizados cada semana.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          // Category filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((c) {
                  final selected = c == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? _kPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: selected ? _kPrimary : _kBorder),
                      ),
                      child: Text(c, style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13,
                          color: selected ? Colors.white : _kText)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Divider(height: 1, color: _kBorder),
          // Grid
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No hay ofertas en esta categoría.',
                    style: TextStyle(color: _kMuted)))
                : GridView.builder(
                    padding: EdgeInsets.all(mobile ? 16 : 32),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: mobile ? 1 : (MediaQuery.of(context).size.width < 1100 ? 2 : 3),
                      crossAxisSpacing: 20, mainAxisSpacing: 20,
                      childAspectRatio: mobile ? 2.2 : 1.8,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _OfferCard(offer: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _OfferItem {
  final String emoji, store, tag, name, description, category;
  final double oldPrice, price;
  const _OfferItem(this.emoji, this.store, this.tag, this.name,
      this.oldPrice, this.price, this.category, this.description);
}

class _OfferCard extends StatelessWidget {
  final _OfferItem offer;
  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    final discount = ((offer.oldPrice - offer.price) / offer.oldPrice * 100).round();

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
                decoration: BoxDecoration(color: _kBg, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(offer.emoji, style: const TextStyle(fontSize: 28))),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8),
                ),
                child: Text('-$discount%', style: const TextStyle(
                    color: Color(0xFF92400E), fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(6),
                ),
                child: Text(offer.tag, style: const TextStyle(
                    color: _kAccentDark, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              Text(offer.store, style: const TextStyle(color: _kMuted, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(offer.name, style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: _kText),
                maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Text(offer.description, style: const TextStyle(color: _kMuted, fontSize: 12),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('US\$${offer.price.toStringAsFixed(0)}', style: const TextStyle(
                  color: _kPrimary, fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(width: 8),
              Text('US\$${offer.oldPrice.toStringAsFixed(0)}', style: const TextStyle(
                  color: _kMuted, fontSize: 13, decoration: TextDecoration.lineThrough)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.push('/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kAccent, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  elevation: 0, minimumSize: Size.zero,
                ),
                child: const Text('Quiero', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Group Buy Screen ─────────────────────────────────
class GroupBuyScreen extends StatelessWidget {
  const GroupBuyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    final groups = [
      _GroupItem('🔧', 'Raspberry Pi 5 (8GB)', 80, 68, 7, 3, 'Tecnología',
          'Ideal para proyectos universitarios, IoT y programación.'),
      _GroupItem('📱', 'Samsung Galaxy Tab S9', 449, 389, 12, 3, 'Electrónica',
          'Tablet premium con S Pen y pantalla AMOLED 120Hz.'),
      _GroupItem('💡', 'Arduino Mega Kit Pro', 65, 52, 5, 5, 'Componentes',
          'Kit completo con placa, sensores y componentes electrónicos.'),
      _GroupItem('🖨️', 'Bambu Lab A1 Mini 3D Printer', 349, 299, 4, 6, 'Tecnología',
          'Impresora 3D de última generación con multi-filamento.'),
      _GroupItem('⌨️', 'Keychron Q1 Pro Mechanical', 199, 169, 9, 1, 'Tecnología',
          'Teclado mecánico premium QMK/VIA wireless.'),
      _GroupItem('📡', 'TP-Link Deco XE75 Pro (3-pack)', 259, 219, 6, 4, 'Hogar',
          'Sistema WiFi 6E mesh para toda la casa.'),
    ];

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _kPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Compras grupales',
            style: TextStyle(fontWeight: FontWeight.w800, color: _kPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _kBorder),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explanation Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF08274A), _kPrimary],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('¿Cómo funciona?', style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          'Cuando varias personas compran el mismo producto, todos reciben un descuento en envío y comisión. Únete a una compra existente o propón una nueva.',
                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.groups_rounded, color: _kAccent, size: 48),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Benefits row
            Row(
              children: [
                _benefitChip('💰', 'Menos comisión'),
                const SizedBox(width: 12),
                _benefitChip('✈️', 'Envío compartido'),
                const SizedBox(width: 12),
                _benefitChip('⚡', 'Proceso rápido'),
              ],
            ),
            const SizedBox(height: 28),
            const Text('Compras activas', style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 20, color: _kText)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: mobile ? 1 : (MediaQuery.of(context).size.width < 1100 ? 2 : 3),
                crossAxisSpacing: 20, mainAxisSpacing: 20,
                childAspectRatio: mobile ? 1.6 : 1.4,
              ),
              itemCount: groups.length,
              itemBuilder: (_, i) => _GroupBuyCard(group: groups[i]),
            ),
            const SizedBox(height: 32),
            // Propose new group buy
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _kBorder),
              ),
              child: Column(
                children: [
                  const Icon(Icons.add_shopping_cart_rounded, color: _kAccent, size: 36),
                  const SizedBox(height: 12),
                  const Text('¿No encuentras tu producto?', style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16, color: _kText)),
                  const SizedBox(height: 8),
                  const Text('Propón una nueva compra grupal y te avisamos cuando haya suficientes interesados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _kMuted, fontSize: 14)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/register'),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Proponer compra grupal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      elevation: 0,
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

  Widget _benefitChip(String emoji, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(100),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 12, color: _kText)),
          ],
        ),
      );
}

class _GroupItem {
  final String emoji, name, category, description;
  final double price, groupPrice;
  final int interested, needed;
  const _GroupItem(this.emoji, this.name, this.price, this.groupPrice,
      this.interested, this.needed, this.category, this.description);
}

class _GroupBuyCard extends StatelessWidget {
  final _GroupItem group;
  const _GroupBuyCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final progress = group.interested / (group.interested + group.needed);
    final discount = ((group.price - group.groupPrice) / group.price * 100).round();

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
              Text(group.emoji, style: const TextStyle(fontSize: 28)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _kPrimary.withOpacity(0.08), borderRadius: BorderRadius.circular(100),
                ),
                child: Text(group.category, style: const TextStyle(
                    color: _kPrimary, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(group.name, style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: _kText),
                maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 4),
          Text(group.description, style: const TextStyle(color: _kMuted, fontSize: 11),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('US\$${group.groupPrice.toStringAsFixed(0)}', style: const TextStyle(
                  color: _kAccentDark, fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(width: 6),
              Text('US\$${group.price.toStringAsFixed(0)}', style: const TextStyle(
                  color: _kMuted, fontSize: 12, decoration: TextDecoration.lineThrough)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6),
                ),
                child: Text('-$discount%', style: const TextStyle(
                    color: Color(0xFF92400E), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress, backgroundColor: _kBorder,
              valueColor: const AlwaysStoppedAnimation(_kAccent), minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${group.interested} ya se unieron', style: const TextStyle(
                  color: _kAccentDark, fontWeight: FontWeight.w600, fontSize: 11)),
              const Spacer(),
              Text('Faltan ${group.needed}', style: const TextStyle(color: _kMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAccent, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
              ),
              child: const Text('Unirme', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Membership Screen ────────────────────────────────
class MembershipScreen extends StatefulWidget {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool _annual = false;

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _kPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('ConexaShip Plus',
            style: TextStyle(fontWeight: FontWeight.w800, color: _kPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _kBorder),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mobile ? 20 : 40),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF08274A), _kPrimary],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: _kAccent, size: 36),
                  ),
                  const SizedBox(height: 20),
                  const Text('ConexaShip Plus', style: TextStyle(
                      color: _kAccent, fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('La membresía que paga por sí sola', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    'Desde tu primer envío, los ahorros superan el costo de la membresía.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Toggle
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(100),
                border: Border.all(color: _kBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _annual = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: !_annual ? _kPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text('Mensual', style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14,
                          color: !_annual ? Colors.white : _kMuted)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _annual = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: _annual ? _kPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Text('Anual', style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14,
                              color: _annual ? Colors.white : _kMuted)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _kAccent, borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text('2 meses gratis', style: TextStyle(
                                color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Plans
            mobile
                ? Column(children: [
                    _PlanCard(isPro: false, annual: _annual),
                    const SizedBox(height: 20),
                    _PlanCard(isPro: true, annual: _annual),
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _PlanCard(isPro: false, annual: _annual)),
                      const SizedBox(width: 24),
                      Expanded(child: _PlanCard(isPro: true, annual: _annual)),
                    ],
                  ),
            const SizedBox(height: 40),
            // Comparison Table
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Comparación completa', style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 18, color: _kText)),
                  const SizedBox(height: 20),
                  _compRow('Comisión de compra asistida', '5%', '3%'),
                  _compRow('Inspecciones premium', 'US\$8 c/u', '1 gratis/mes'),
                  _compRow('Consolidación de paquetes', 'US\$5', 'Gratis'),
                  _compRow('Descuento en envíos', '—', '10%'),
                  _compRow('Prioridad en atención', '—', '✓'),
                  _compRow('Acceso anticipado a ofertas', '—', '✓'),
                  _compRow('Devoluciones con descuento', 'Precio normal', '20% menos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compRow(String feature, String free, String plus) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _kBorder))),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(feature,
                style: const TextStyle(fontSize: 14, color: _kText))),
            Expanded(child: Text(free, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: _kMuted))),
            Expanded(child: Text(plus, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: _kAccentDark, fontWeight: FontWeight.w700))),
          ],
        ),
      );
}

class _PlanCard extends StatelessWidget {
  final bool isPro;
  final bool annual;
  const _PlanCard({required this.isPro, required this.annual});

  @override
  Widget build(BuildContext context) {
    final price = isPro ? (annual ? 39.99 : 4.99) : 0.0;
    final features = isPro
        ? ['Comisión al 3% (antes 5%)', '1 inspección premium/mes', 'Consolidación gratis', '10% descuento en envíos', 'Prioridad en atención', 'Acceso anticipado a ofertas']
        : ['Comisión estándar 5%', 'Inspección US\$8–10 c/u', 'Consolidación US\$5', 'Sin descuentos en envío', 'Atención regular', 'Ofertas sin prioridad'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isPro ? _kPrimary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPro ? _kPrimary : _kBorder, width: isPro ? 2 : 1),
        boxShadow: isPro ? [BoxShadow(color: _kPrimary.withOpacity(0.3),
            blurRadius: 24, offset: const Offset(0, 8))] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPro)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _kAccent, borderRadius: BorderRadius.circular(100),
              ),
              child: const Text('RECOMENDADO', style: TextStyle(
                  color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800,
                  letterSpacing: 1)),
            ),
          if (isPro) const SizedBox(height: 12),
          Text(isPro ? 'ConexaShip Plus' : 'Gratis',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18,
                  color: isPro ? Colors.white : _kText)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(isPro ? 'US\$${price.toStringAsFixed(2)}' : 'US\$0',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32,
                      color: isPro ? _kAccent : _kPrimary)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(isPro ? (annual ? '/ año' : '/ mes') : '/ siempre',
                    style: TextStyle(color: isPro ? Colors.white60 : _kMuted, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...features.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(isPro ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isPro ? _kAccent : _kMuted, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value, style: TextStyle(
                        color: isPro ? Colors.white70 : _kMuted, fontSize: 13))),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPro ? _kAccent : _kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(isPro ? 'Comenzar con Plus' : 'Crear cuenta gratis',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tracking Screen ──────────────────────────────────
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _trackingCtrl = TextEditingController();
  bool _searched = false;

  @override
  void dispose() {
    _trackingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _kPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Rastrear paquete',
            style: TextStyle(fontWeight: FontWeight.w800, color: _kPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _kBorder),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mobile ? 20 : 40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kBorder),
              ),
              child: Column(
                children: [
                  const Icon(Icons.track_changes_rounded, color: _kAccent, size: 48),
                  const SizedBox(height: 16),
                  const Text('Ingresa tu número de rastreo', style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18, color: _kText)),
                  const SizedBox(height: 8),
                  const Text('Puedes encontrarlo en el correo de confirmación de tu pedido.',
                      style: TextStyle(color: _kMuted, fontSize: 14), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _trackingCtrl,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Ej: CSH-2026-00123',
                            hintStyle: const TextStyle(color: _kMuted),
                            fillColor: _kBg, filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: _kBorder)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: _kBorder)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: _kAccent, width: 2)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => setState(() => _searched = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kAccent, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text('Rastrear', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_searched) ...[
              const SizedBox(height: 24),
              _TrackingResult(),
            ],
            const SizedBox(height: 32),
            _LoginPrompt(),
          ],
        ),
      ),
    );
  }
}

class _TrackingResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final states = [
      _TrackState('Compra realizada', '12 Jun 2026 · 10:30', true),
      _TrackState('Recibido en bodega Miami', '15 Jun 2026 · 14:20', true),
      _TrackState('Inspeccionado y fotografiado', '16 Jun 2026 · 09:15', true),
      _TrackState('Preparando envío', '17 Jun 2026 · 16:00', true),
      _TrackState('En camino a Ecuador', '18 Jun 2026 · 08:00', false),
      _TrackState('En aduana Ecuador', 'Pendiente', false),
      _TrackState('Entregado', 'Pendiente', false),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _kAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8),
                ),
                child: Text('CSH-2026-00123', style: TextStyle(
                    color: _kAccentDark, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('En camino', style: TextStyle(
                    color: Color(0xFF92400E), fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...states.asMap().entries.map((e) => _TrackRow(
                state: e.value,
                isLast: e.key == states.length - 1,
              )),
        ],
      ),
    );
  }
}

class _TrackState {
  final String label, date;
  final bool done;
  const _TrackState(this.label, this.date, this.done);
}

class _TrackRow extends StatelessWidget {
  final _TrackState state;
  final bool isLast;
  const _TrackRow({required this.state, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: state.done ? _kAccent : _kBg,
                shape: BoxShape.circle,
                border: Border.all(color: state.done ? _kAccent : _kBorder, width: 2),
              ),
              child: state.done
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40,
                  color: state.done ? _kAccent.withOpacity(0.3) : _kBorder),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.label, style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14,
                    color: state.done ? _kText : _kMuted)),
                const SizedBox(height: 2),
                Text(state.date, style: const TextStyle(color: _kMuted, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kPrimary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle_outlined, color: _kPrimary, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('¿Tienes una cuenta?', style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15, color: _kText)),
                const SizedBox(height: 4),
                const Text('Inicia sesión para ver todos tus paquetes con fotos y estado detallado.',
                    style: TextStyle(color: _kMuted, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () => context.push('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
            child: const Text('Entrar', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── How It Works Screen ──────────────────────────────
class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _kPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Cómo funciona',
            style: TextStyle(fontWeight: FontWeight.w800, color: _kPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _kBorder),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mobile ? 20 : 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero
            Center(
              child: Column(
                children: [
                  const Text('Cómo funciona ConexaShip', style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 32, color: _kText)),
                  const SizedBox(height: 12),
                  const Text('De la tienda en USA a tu casa en Ecuador, así funciona el proceso completo.',
                      style: TextStyle(color: _kMuted, fontSize: 16, height: 1.6),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 48),
            // Steps
            _StepDetail('01', Icons.link_rounded, 'Pega el enlace del producto',
                'Copia el URL de cualquier tienda en USA: Amazon, eBay, Best Buy, Walmart, Target, Micro Center y muchas más. Pégalo en la barra de búsqueda de ConexaShip.',
                ['Funciona con cualquier tienda que envíe a Miami', 'También puedes ingresar el nombre del producto', 'Si no tienes tarjeta, nosotros compramos por ti']),
            _StepDetail('02', Icons.receipt_long_outlined, 'Recibe el precio final al instante',
                'Te calculamos en tiempo real el costo total: precio del producto + envío desde Miami + tarifa aduanera fija 4×4 (US\$20) + manejo y comisión ConexaShip.',
                ['Sin sorpresas ni cobros ocultos', 'El precio incluye todo hasta tu puerta', 'Usamos el tipo de cambio oficial']),
            _StepDetail('03', Icons.shopping_cart_outlined, 'Confirma y paga',
                'Confirmas la compra y puedes pagar por transferencia, depósito, tarjeta o PayPal. Si no tienes tarjeta internacional, ConexaShip compra por ti (comisión 5%).',
                ['Pago seguro con múltiples métodos', 'Compra asistida disponible', 'Factura por cada transacción']),
            _StepDetail('04', Icons.warehouse_outlined, 'Llega a nuestra bodega en Miami',
                'El producto llega a nuestra dirección en Miami. Fotografiamos la caja y el producto, verificamos el peso real y el estado del empaque.',
                ['Foto de la caja al llegar', 'Verificación de número de serie', 'Opción de inspección premium (US\$8–10)']),
            _StepDetail('05', Icons.flight_outlined, 'Enviamos a Ecuador',
                'Consolidamos tu paquete y lo enviamos a Ecuador. Te notificamos el número de tracking de aerolínea y el estado en tiempo real.',
                ['Vuelo directo o conexión según disponibilidad', 'Notificaciones en cada paso', 'Seguro básico incluido']),
            _StepDetail('06', Icons.home_outlined, 'Recíbelo en tu puerta',
                'Cuando el paquete llega a Ecuador y pasa por aduana, lo entregamos directamente en tu dirección en 1-2 días hábiles.',
                ['Entrega en todo el Ecuador continental', 'Seguimiento hasta la entrega', 'Firma de conformidad']),
            const SizedBox(height: 48),
            // Trust section
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: _kPrimary, borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('¿Por qué confiar en ConexaShip?', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 20, runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _trustItem('🏢', 'Empresa registrada\nen Ecuador'),
                      _trustItem('📸', 'Fotos de cada\npaquete'),
                      _trustItem('🔒', 'Pago 100%\nseguro'),
                      _trustItem('⭐', '4.9/5 estrellas\nde clientes'),
                      _trustItem('📦', 'Más de 3,400\nentregas'),
                      _trustItem('🛡️', 'Seguro básico\nincluido'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.push('/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kAccent, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      elevation: 0,
                    ),
                    child: const Text('Crear cuenta gratis y comenzar',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trustItem(String emoji, String label) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(
              color: Colors.white.withOpacity(0.8), fontSize: 12, height: 1.4),
              textAlign: TextAlign.center),
        ],
      );
}

class _StepDetail extends StatelessWidget {
  final String num;
  final IconData icon;
  final String title;
  final String description;
  final List<String> bullets;

  const _StepDetail(this.num, this.icon, this.title, this.description, this.bullets);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 56, height: 56,
                decoration: const BoxDecoration(color: _kPrimary, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 8),
              Text(num, style: TextStyle(
                  fontWeight: FontWeight.w900, fontSize: 20,
                  color: _kPrimary.withOpacity(0.2))),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 17, color: _kText)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(
                    color: _kMuted, fontSize: 14, height: 1.6)),
                const SizedBox(height: 12),
                ...bullets.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_rounded, color: _kAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(b, style: const TextStyle(
                              color: _kText, fontSize: 13))),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
