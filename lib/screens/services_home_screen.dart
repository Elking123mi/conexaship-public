import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────
//  ConexaShip – Landing Page principal  (Diseño fintech)
// ─────────────────────────────────────────────────────

const _kPrimary = Color(0xFF0B3D6E);
const _kAccent = Color(0xFF00C9A7);
const _kAccentDark = Color(0xFF00A98B);
const _kBg = Color(0xFFF8FAFC);
const _kBorder = Color(0xFFE5E7EB);
const _kText = Color(0xFF111827);
const _kMuted = Color(0xFF6B7280);

class ServicesHomeScreen extends StatefulWidget {
  const ServicesHomeScreen({Key? key}) : super(key: key);

  @override
  State<ServicesHomeScreen> createState() => _ServicesHomeScreenState();
}

class _ServicesHomeScreenState extends State<ServicesHomeScreen> {
  final _urlController = TextEditingController();
  final _calcPriceController = TextEditingController(text: '500');
  final _calcWeightController = TextEditingController(text: '2');
  final _scrollController = ScrollController();
  int _comparatorIndex = 0;
  int _openFaq = -1;

  @override
  void dispose() {
    _urlController.dispose();
    _calcPriceController.dispose();
    _calcWeightController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          _NavBar(onNavigate: (r) { if (r.startsWith('/')) context.push(r); }),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildHero(context),
                  _buildHowItWorks(context),
                  _buildCompatibleStores(context),
                  _buildCalculatorSection(context),
                  _buildComparatorSection(context),
                  _buildOffersSection(context),
                  _buildGroupBuySection(context),
                  _buildMembershipSection(context),
                  _buildBenefitsSection(context),
                  _buildTestimonialsSection(context),
                  _buildFaqSection(context),
                  _buildFinalCta(context),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.chat_rounded),
        label: const Text('WhatsApp',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 4,
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────
  Widget _buildHero(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final mobile = w < 700;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF08274A), _kPrimary, Color(0xFF0E5A82)],
        ),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: mobile ? 24 : 80, vertical: mobile ? 60 : 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _kAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: _kAccent.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: _kAccent, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                const Text('Courier inteligente · Ecuador ↔ USA',
                    style: TextStyle(color: _kAccent, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Tu compra en USA,\nen tu puerta en Ecuador.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: mobile ? 36 : 60,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Pega el enlace del producto y recibe al instante el precio\nfinal con envío, impuestos y entrega incluida.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: mobile ? 15 : 19,
                color: Colors.white.withOpacity(0.75), height: 1.6),
          ),
          const SizedBox(height: 40),
          // URL Input Box
          Container(
            constraints: const BoxConstraints(maxWidth: 680),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18),
                  blurRadius: 30, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.link_rounded, color: _kMuted),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    style: const TextStyle(fontSize: 15, color: _kText),
                    decoration: const InputDecoration(
                      hintText: 'Pega aquí el enlace de Amazon, eBay, Best Buy…',
                      hintStyle: TextStyle(color: _kMuted, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_urlController.text.isNotEmpty) {
                      context.push('/register');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: mobile ? 18 : 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(mobile ? 'Cotizar' : 'Cotizar ahora',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10, runSpacing: 8,
            alignment: WrapAlignment.center,
            children: ['Amazon', 'eBay', 'Best Buy', 'Walmart', 'Target', 'Micro Center', 'B&H']
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Text(s, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 56),
          if (!mobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statWidget('3,400+', 'Paquetes entregados'),
                _vDivider(),
                _statWidget('US\$9.99', 'Por libra desde Miami'),
                _vDivider(),
                _statWidget('5–10 días', 'Tiempo de entrega'),
                _vDivider(),
                _statWidget('4.9 ⭐', 'Calificación promedio'),
              ],
            )
          else
            Wrap(
              spacing: 24, runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _statWidget('3,400+', 'Entregas'),
                _statWidget('US\$9.99', 'Por libra'),
                _statWidget('5–10 días', 'Entrega'),
                _statWidget('4.9 ⭐', 'Rating'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _statWidget(String val, String label) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12)),
        ],
      );

  Widget _vDivider() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      height: 40, width: 1, color: Colors.white.withOpacity(0.2));

  // ── Cómo funciona ──────────────────────────────────
  Widget _buildHowItWorks(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    final steps = [
      _StepData(Icons.link_rounded, '01', 'Pega el enlace',
          'Copia el URL de cualquier producto en Amazon, eBay, Best Buy u otras tiendas.'),
      _StepData(Icons.calculate_outlined, '02', 'Recibe el precio total',
          'Te mostramos el precio final con envío, impuestos 4×4 y entrega en Ecuador.'),
      _StepData(Icons.local_shipping_outlined, '03', 'Recibe en Ecuador',
          'Compramos por ti, recibimos en Miami y lo entregamos en tu puerta en 5–10 días.'),
    ];

    return _Section(
      bg: Colors.white,
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Simple y rápido',
            title: '¿Cómo funciona?',
            subtitle: 'Tres pasos y tu producto llega a Ecuador desde cualquier tienda de USA.',
          ),
          const SizedBox(height: 48),
          mobile
              ? Column(children: steps.map((s) => _StepCard(data: s)).toList())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _StepCard(data: steps[0])),
                    const Padding(padding: EdgeInsets.only(top: 32),
                        child: Icon(Icons.arrow_forward_ios_rounded, color: _kBorder, size: 20)),
                    Expanded(child: _StepCard(data: steps[1])),
                    const Padding(padding: EdgeInsets.only(top: 32),
                        child: Icon(Icons.arrow_forward_ios_rounded, color: _kBorder, size: 20)),
                    Expanded(child: _StepCard(data: steps[2])),
                  ],
                ),
        ],
      ),
    );
  }

  // ── Tiendas compatibles ────────────────────────────
  Widget _buildCompatibleStores(BuildContext context) {
    final stores = [
      ('Amazon', '📦'), ('eBay', '🛍️'), ('Best Buy', '💻'),
      ('Walmart', '🏪'), ('Target', '🎯'), ('Micro Center', '🔧'),
      ('B&H Photo', '📷'), ('Newegg', '⚡'), ('Home Depot', '🏗️'), ('Costco', '🛒'),
    ];

    return _Section(
      bg: _kBg,
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Compatibilidad',
            title: 'Compramos en cualquier tienda',
            subtitle: 'Si tiene envío a Miami, nosotros lo traemos a Ecuador.',
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16, runSpacing: 16,
            alignment: WrapAlignment.center,
            children: stores.map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kBorder),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
                        blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.$2, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(s.$1, style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14, color: _kText)),
                    ],
                  ),
                )).toList(),
          ),
          const SizedBox(height: 24),
          const Text('¿Tu tienda no está? Escríbenos — casi siempre podemos ayudarte.',
              style: TextStyle(color: _kMuted, fontSize: 14), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ── Calculadora 4×4 ───────────────────────────────
  Widget _buildCalculatorSection(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;
    return _Section(
      bg: Colors.white,
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Herramienta gratuita',
            title: 'Calculadora 4×4',
            subtitle: 'Estima tu costo total antes de comprar. Incluye envío, impuestos y entrega.',
          ),
          const SizedBox(height: 40),
          mobile
              ? Column(children: [_CalcInputs(calcPriceCtrl: _calcPriceController, calcWeightCtrl: _calcWeightController), const SizedBox(height: 24), _CalcResult(calcPriceCtrl: _calcPriceController, calcWeightCtrl: _calcWeightController)])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _CalcInputs(calcPriceCtrl: _calcPriceController, calcWeightCtrl: _calcWeightController)),
                    const SizedBox(width: 32),
                    Expanded(child: _CalcResult(calcPriceCtrl: _calcPriceController, calcWeightCtrl: _calcWeightController)),
                  ],
                ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.push('/calculator'),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Ver calculadora completa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _kPrimary,
              side: const BorderSide(color: _kPrimary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ── Comparador de precios ─────────────────────────
  Widget _buildComparatorSection(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;
    final examples = [
      _CompItem('MacBook Air M3 13"', '💻', 1099, 1389, 1699),
      _CompItem('iPhone 16 Pro', '📱', 999, 1189, 1450),
      _CompItem('Raspberry Pi 5', '🔧', 80, 130, 220),
      _CompItem('Sony WH-1000XM5', '🎧', 349, 450, 640),
    ];

    return _Section(
      bg: _kBg,
      child: Column(
        children: [
          const _SectionHeader(
            tag: '¿Vale la pena?',
            title: '¿Más barato con ConexaShip\no en Ecuador?',
            subtitle: 'Compara precios y descubre cuánto puedes ahorrar.',
          ),
          const SizedBox(height: 32),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: examples.asMap().entries.map((e) {
                final selected = e.key == _comparatorIndex;
                return GestureDetector(
                  onTap: () => setState(() => _comparatorIndex = e.key),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? _kPrimary : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: selected ? _kPrimary : _kBorder),
                    ),
                    child: Text('${e.value.emoji}  ${e.value.name}',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                            color: selected ? Colors.white : _kText)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),
          _ComparatorCard(item: examples[_comparatorIndex], mobile: mobile),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => context.push('/register'),
            icon: const Icon(Icons.compare_arrows_rounded, size: 18),
            label: const Text('Cotizar tu producto'),
            style: TextButton.styleFrom(foregroundColor: _kPrimary),
          ),
        ],
      ),
    );
  }

  // ── Ofertas exclusivas ─────────────────────────────
  Widget _buildOffersSection(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    final offers = [
      _Offer('💻', 'Best Buy', 'Open Box', 'Dell XPS 15 Open Box', 1299, 849),
      _Offer('📷', 'B&H', 'Refurbished', 'Sony A7 IV Certified Refurb', 2499, 1799),
      _Offer('⌚', 'Amazon', 'Oferta del día', 'Apple Watch Series 9', 399, 269),
      _Offer('🎮', 'Walmart', 'Liquidación', 'PS5 Slim Bundle', 499, 399),
      _Offer('🔧', 'Micro Center', 'Especial', 'Ryzen 9 9900X CPU', 449, 329),
      _Offer('📦', 'Amazon', 'Prime Deal', 'Echo Show 15 2da Gen', 249, 169),
    ];

    return _Section(
      bg: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: _SectionHeader(
                tag: 'Solo disponible aquí',
                title: 'Ofertas exclusivas',
                subtitle: 'Productos seleccionados a precios que no encontrarás en Ecuador.',
              )),
              if (!mobile)
                TextButton.icon(
                  onPressed: () => context.push('/offers'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Ver todas'),
                  style: TextButton.styleFrom(foregroundColor: _kPrimary),
                ),
            ],
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: mobile ? 1 : (MediaQuery.of(context).size.width < 1100 ? 2 : 3),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: mobile ? 2.8 : 2.0,
            ),
            itemCount: offers.length,
            itemBuilder: (_, i) => _OfferCard(offer: offers[i]),
          ),
          if (mobile)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: OutlinedButton(
                  onPressed: () => context.push('/offers'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _kPrimary,
                    side: const BorderSide(color: _kPrimary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text('Ver todas las ofertas'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Compras grupales ───────────────────────────────
  Widget _buildGroupBuySection(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;
    final groups = [
      _Group('🔧', 'Raspberry Pi 5 (8GB)', 80, 68, 7, 3, 'Tecnología'),
      _Group('📱', 'Samsung Galaxy Tab S9', 449, 389, 12, 3, 'Electrónica'),
      _Group('💡', 'Arduino Mega Kit Pro', 65, 52, 5, 5, 'Componentes'),
    ];

    return _Section(
      bg: _kBg,
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Nuevo',
            title: 'Compras grupales',
            subtitle: 'Únete a otros compradores y paga menos en envío y comisión.',
          ),
          const SizedBox(height: 40),
          mobile
              ? Column(children: groups.map((g) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _GroupCard(group: g))).toList())
              : Row(
                  children: groups.map((g) => Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _GroupCard(group: g)))).toList()),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/group-buy'),
            icon: const Icon(Icons.groups_rounded),
            label: const Text('Ver todas las compras grupales'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Membresía Plus ─────────────────────────────────
  Widget _buildMembershipSection(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;
    final benefits = [
      'Comisión de compra reducida al 3%',
      '1 inspección premium mensual gratis (valor US\$8)',
      'Consolidación sin costo adicional',
      'Prioridad en atención al cliente',
      'Descuento del 10% en envíos',
      'Acceso anticipado a ofertas exclusivas',
      'Devoluciones con tarifa reducida',
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF08274A), _kPrimary],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 80, vertical: 72),
      child: mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_MembershipHero(), const SizedBox(height: 32), _MembershipCard(benefits: benefits)],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _MembershipHero()),
                const SizedBox(width: 48),
                Expanded(child: _MembershipCard(benefits: benefits)),
              ],
            ),
    );
  }

  // ── Beneficios ─────────────────────────────────────
  Widget _buildBenefitsSection(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    final items = [
      (Icons.photo_camera_outlined, 'Fotografías del paquete',
          'Recibe fotos al llegar a la bodega: caja, producto y empaque.'),
      (Icons.verified_outlined, 'Inspección certificada',
          'Verificamos número de serie, estado y peso real del producto.'),
      (Icons.group_add_outlined, 'Sistema de referidos',
          'Invita a amigos y ambos reciben US\$5 tras el primer envío.'),
      (Icons.support_agent_outlined, 'Atención humana',
          'Un asesor real responde tus dudas por WhatsApp en minutos.'),
      (Icons.security_outlined, 'Seguro incluido',
          'Todo paquete tiene cobertura básica contra pérdida o daño.'),
      (Icons.calculate_outlined, 'Control del cupo 4×4',
          'Te avisamos antes de que superes el límite anual de importación.'),
    ];

    return _Section(
      bg: _kBg,
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Por qué elegirnos',
            title: 'Más que un courier',
            subtitle: 'ConexaShip combina tecnología, transparencia y servicio humano.',
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: mobile ? 1 : 3,
              crossAxisSpacing: 20, mainAxisSpacing: 20,
              childAspectRatio: mobile ? 4.0 : 2.4,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _kBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: _kAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(items[i].$1, color: _kAccentDark, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(items[i].$2, style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14, color: _kText)),
                        const SizedBox(height: 4),
                        Text(items[i].$3, style: const TextStyle(
                            color: _kMuted, fontSize: 12, height: 1.5),
                            maxLines: 3, overflow: TextOverflow.ellipsis),
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

  // ── Testimonios ────────────────────────────────────
  Widget _buildTestimonialsSection(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    final testimonials = [
      _Testimonial('Andrés M.', 'Ingeniero en Quito',
          'Compré mi MacBook Pro desde Amazon. Me mostraron foto del empaque al llegar a Miami y llegó en perfectas condiciones. El precio fue US\$280 menos que en Quito.', 5),
      _Testimonial('Valeria C.', 'Diseñadora en Guayaquil',
          'La calculadora me ayudó a saber exactamente cuánto iba a pagar antes de comprar. Cero sorpresas. El proceso fue rapidísimo y muy transparente.', 5),
      _Testimonial('Roberto S.', 'Empresario en Cuenca',
          'He hecho 6 compras con ConexaShip. La compra grupal me ahorró en el envío de los Raspberry Pi para mi equipo. Excelente servicio.', 5),
    ];

    return _Section(
      bg: Colors.white,
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Opiniones reales',
            title: 'Lo que dicen nuestros clientes',
            subtitle: 'Más de 3,400 entregas exitosas y 4.9 estrellas de calificación.',
          ),
          const SizedBox(height: 40),
          mobile
              ? Column(children: testimonials.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _TestimonialCard(t: t))).toList())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: testimonials.map((t) => Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _TestimonialCard(t: t)))).toList()),
        ],
      ),
    );
  }

  // ── FAQ ────────────────────────────────────────────
  Widget _buildFaqSection(BuildContext context) {
    final faqs = [
      ('¿Cuánto cuesta enviar un paquete?',
          'La tarifa base incluye el envío desde Miami a Ecuador, la tarifa aduanera fija del régimen 4×4 (US\$20 desde junio 2025), manejo y la comisión de ConexaShip. Te damos el precio exacto antes de confirmar.'),
      ('¿Qué es el régimen 4×4?',
          'Es la normativa ecuatoriana que permite importar hasta 4 paquetes por año con un valor máximo de US\$400 y 4 kg cada uno, pagando una tarifa aduanera fija de US\$20 por paquete (vigente desde junio 2025). ConexaShip te ayuda a rastrear tu cupo disponible.'),
      ('¿Pueden comprar el producto por mí?',
          'Sí. Si no tienes tarjeta internacional, nosotros realizamos la compra por ti y te cobramos una comisión del 5% sobre el valor del producto (3% con ConexaShip Plus).'),
      ('¿Qué pasa si el producto llega dañado?',
          'Todos los paquetes tienen cobertura básica incluida. Con el servicio de inspección premium, fotografiamos y verificamos el estado antes de enviarlo a Ecuador.'),
      ('¿Cuánto tiempo tarda en llegar?',
          'Generalmente entre 5 y 10 días hábiles desde que el paquete llega a nuestra bodega en Miami hasta que lo recibes en Ecuador.'),
      ('¿Puedo rastrear mi paquete?',
          'Sí. Desde tu panel de cliente puedes ver el estado en tiempo real: Recibido → Inspeccionado → En camino → En aduana → Entregado.'),
    ];

    return _Section(
      bg: _kBg,
      child: Column(
        children: [
          const _SectionHeader(
            tag: 'Preguntas frecuentes',
            title: '¿Tienes dudas?',
            subtitle: 'Las respuestas más comunes sobre ConexaShip.',
          ),
          const SizedBox(height: 32),
          ...faqs.asMap().entries.map((e) => _FaqItem(
                question: e.value.$1,
                answer: e.value.$2,
                isOpen: _openFaq == e.key,
                onTap: () => setState(
                    () => _openFaq = _openFaq == e.key ? -1 : e.key),
              )),
        ],
      ),
    );
  }

  // ── CTA final ──────────────────────────────────────
  Widget _buildFinalCta(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;

    return Container(
      width: double.infinity,
      color: _kAccent,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 80, vertical: 72),
      child: Column(
        children: [
          Text(
            'Comienza a ahorrar hoy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: mobile ? 32 : 48,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Crea tu cuenta gratis y recibe un casillero en Miami en menos de 2 minutos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.85),
                fontSize: mobile ? 15 : 18, height: 1.6),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.push('/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  elevation: 0,
                ),
                child: const Text('Crear cuenta gratis',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              OutlinedButton(
                onPressed: () => context.push('/how-it-works'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                ),
                child: const Text('Cómo funciona',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Footer ─────────────────────────────────────────
  Widget _buildFooter(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;

    return Container(
      color: const Color(0xFF08274A),
      padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 80, vertical: 56),
      child: Column(
        children: [
          mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterBrand(),
                    const SizedBox(height: 40),
                    _footerLinks('Servicios', ['Cotizar', 'Compra asistida', 'Casillero Miami', 'Inspección premium', 'ConexaShip Plus']),
                    const SizedBox(height: 32),
                    _footerLinks('Empresa', ['Quiénes somos', 'Cómo funciona', 'Preguntas frecuentes', 'Contacto']),
                    const SizedBox(height: 32),
                    _footerLinks('Legal', ['Términos de uso', 'Privacidad', 'Política de devoluciones']),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _FooterBrand()),
                    Expanded(child: _footerLinks('Servicios', ['Cotizar', 'Compra asistida', 'Casillero', 'Inspección premium', 'Plus'])),
                    Expanded(child: _footerLinks('Empresa', ['Quiénes somos', 'Cómo funciona', 'FAQ', 'Contacto'])),
                    Expanded(child: _footerLinks('Legal', ['Términos', 'Privacidad', 'Devoluciones'])),
                  ],
                ),
          const SizedBox(height: 48),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© 2026 ConexaShip. Todos los derechos reservados.',
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
              Text('Hecho para Ecuador 🇪🇨',
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLinks(String title, List<String> links) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 16),
          ...links.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(l, style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 13)),
              )),
        ],
      );
}

// ─────────────────────────────────────────────────────
//  Nav Bar
// ─────────────────────────────────────────────────────
class _NavBar extends StatefulWidget {
  final void Function(String) onNavigate;
  const _NavBar({required this.onNavigate});

  @override
  State<_NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<_NavBar> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 900;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
                  blurRadius: 12, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => widget.onNavigate('/'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: const BoxDecoration(color: _kPrimary, shape: BoxShape.circle),
                        child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text('ConexaShip', style: TextStyle(
                          color: _kPrimary, fontWeight: FontWeight.w800, fontSize: 18)),
                    ],
                  ),
                ),
                const Spacer(),
                if (!mobile) ...[
                  _navLink('Inicio', () => widget.onNavigate('/')),
                  _navLink('Cotizar', () => widget.onNavigate('/register')),
                  _navLink('Ofertas', () => widget.onNavigate('/offers')),
                  _navLink('Casillero', () => widget.onNavigate('/dashboard')),
                  _navLink('Cómo funciona', () => widget.onNavigate('/how-it-works')),
                  _navLink('Rastrear', () => widget.onNavigate('/tracking')),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () => widget.onNavigate('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text('Mi cuenta', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
                if (mobile)
                  IconButton(
                    icon: Icon(_menuOpen ? Icons.close_rounded : Icons.menu_rounded, color: _kPrimary),
                    onPressed: () => setState(() => _menuOpen = !_menuOpen),
                  ),
              ],
            ),
          ),
          if (mobile && _menuOpen)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _mobileNavTile('🏠  Inicio', () => widget.onNavigate('/')),
                  _mobileNavTile('🔗  Cotizar', () => widget.onNavigate('/register')),
                  _mobileNavTile('🎁  Ofertas', () => widget.onNavigate('/offers')),
                  _mobileNavTile('📦  Mi Casillero', () => widget.onNavigate('/dashboard')),
                  _mobileNavTile('🔍  Rastrear', () => widget.onNavigate('/tracking')),
                  _mobileNavTile('❓  Cómo funciona', () => widget.onNavigate('/how-it-works')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () { setState(() => _menuOpen = false); widget.onNavigate('/login'); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14), elevation: 0,
                    ),
                    child: const Text('Mi cuenta', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _navLink(String label, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(label, style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: _kText)),
          ),
        ),
      );

  Widget _mobileNavTile(String label, VoidCallback onTap) => InkWell(
        onTap: () { setState(() => _menuOpen = false); onTap(); },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(label, style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: _kText)),
        ),
      );
}

// ─────────────────────────────────────────────────────
//  Shared Widgets
// ─────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final Color bg;
  final Widget child;
  const _Section({required this.bg, required this.child});

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    return Container(
      width: double.infinity,
      color: bg,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 80, vertical: 72),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String subtitle;
  const _SectionHeader({required this.tag, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _kAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(tag, style: const TextStyle(
              color: _kAccentDark, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center,
            style: TextStyle(fontSize: mobile ? 26 : 36,
                fontWeight: FontWeight.w800, color: _kText, height: 1.2)),
        const SizedBox(height: 12),
        Text(subtitle, textAlign: TextAlign.center,
            style: const TextStyle(color: _kMuted, fontSize: 16, height: 1.6)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
//  Step Card
// ─────────────────────────────────────────────────────
class _StepData {
  final IconData icon;
  final String num;
  final String title;
  final String desc;
  const _StepData(this.icon, this.num, this.title, this.desc);
}

class _StepCard extends StatelessWidget {
  final _StepData data;
  const _StepCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    return Container(
      margin: mobile ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: const BoxDecoration(color: _kPrimary, shape: BoxShape.circle),
                child: Icon(data.icon, color: Colors.white, size: 24),
              ),
              const Spacer(),
              Text(data.num, style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.w900,
                  color: _kPrimary.withOpacity(0.08))),
            ],
          ),
          const SizedBox(height: 20),
          Text(data.title, style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: _kText)),
          const SizedBox(height: 8),
          Text(data.desc, style: const TextStyle(color: _kMuted, fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Calculator Widgets
// ─────────────────────────────────────────────────────
class _CalcInputs extends StatefulWidget {
  final TextEditingController calcPriceCtrl;
  final TextEditingController calcWeightCtrl;
  const _CalcInputs({required this.calcPriceCtrl, required this.calcWeightCtrl});

  @override
  State<_CalcInputs> createState() => _CalcInputsState();
}

class _CalcInputsState extends State<_CalcInputs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ingresa los datos del producto',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _kText)),
          const SizedBox(height: 20),
          _InputField(label: 'Precio del producto (USD)', prefix: '\$',
              controller: widget.calcPriceCtrl, onChanged: (_) => setState(() {})),
          const SizedBox(height: 16),
          _InputField(label: 'Peso estimado (lbs)', prefix: '⚖',
              controller: widget.calcWeightCtrl, onChanged: (_) => setState(() {})),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _kAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: _kAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Tarifa de envío: US\$9.99/lb · IVA + Arancel: ~42% · Manejo: US\$5',
                      style: TextStyle(color: _kAccentDark, fontSize: 12, height: 1.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalcResult extends StatefulWidget {
  final TextEditingController calcPriceCtrl;
  final TextEditingController calcWeightCtrl;
  const _CalcResult({required this.calcPriceCtrl, required this.calcWeightCtrl});

  @override
  State<_CalcResult> createState() => _CalcResultState();
}

class _CalcResultState extends State<_CalcResult> {
  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(widget.calcPriceCtrl.text) ?? 0;
    final weight = double.tryParse(widget.calcWeightCtrl.text) ?? 0;
    // Envío: base US$15 + US$3.50/lb (mínimo US$18)
    final shipping = (weight * 3.5 + 15.0).clamp(18.0, 500.0);
    // Tarifa aduanera fija 4×4 (vigente desde junio 2025)
    const tariff4x4 = 20.0;
    // Comisión ConexaShip
    const commission = 15.0;
    const handling = 5.0;
    final total = price + shipping + tariff4x4 + commission + handling;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estimado con ConexaShip',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          _resultRow('Producto', 'US\$${price.toStringAsFixed(2)}'),
          const Divider(color: Colors.white24, height: 24),
          _resultRow('Envío (~${weight.toStringAsFixed(1)} lb)', 'US\$${shipping.toStringAsFixed(2)}'),
          _resultRow('Tarifa aduanera 4×4', 'US\$${tariff4x4.toStringAsFixed(2)}'),
          _resultRow('Manejo y entrega', 'US\$${handling.toStringAsFixed(2)}'),
          _resultRow('Comisión ConexaShip', 'US\$${commission.toStringAsFixed(2)}'),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL ESTIMADO', style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              Text('US\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(color: _kAccent, fontWeight: FontWeight.w800, fontSize: 26)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAccent, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16), elevation: 0,
              ),
              child: const Text('Crear cuenta gratis', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13))),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────
//  Input Field
// ─────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final String label;
  final String prefix;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _InputField({required this.label, required this.prefix,
      required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: _kText)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: onChanged,
          style: const TextStyle(fontSize: 15, color: _kText),
          decoration: InputDecoration(
            prefixText: '$prefix  ',
            prefixStyle: const TextStyle(color: _kMuted),
            fillColor: Colors.white, filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kAccent, width: 2)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
//  Comparator
// ─────────────────────────────────────────────────────
class _CompItem {
  final String name, emoji;
  final double usaPrice, conexaPrice, ecuPrice;
  const _CompItem(this.name, this.emoji, this.usaPrice, this.conexaPrice, this.ecuPrice);
}

class _ComparatorCard extends StatelessWidget {
  final _CompItem item;
  final bool mobile;
  const _ComparatorCard({required this.item, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final savings = item.ecuPrice - item.conexaPrice;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
            blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _compBox('🇺🇸 Precio en USA', item.usaPrice, _kBg, _kMuted)),
              const SizedBox(width: 12),
              Expanded(child: _compBox('📦 ConexaShip total', item.conexaPrice, _kPrimary.withOpacity(0.06), _kPrimary)),
              const SizedBox(width: 12),
              Expanded(child: _compBox('🇪🇨 En Ecuador', item.ecuPrice, Colors.red.withOpacity(0.05), Colors.red.shade600)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.savings_outlined, color: Color(0xFF10B981), size: 20),
                const SizedBox(width: 10),
                Flexible(child: Text(
                    'Ahorras US\$${savings.toStringAsFixed(0)} vs precio en Ecuador',
                    style: const TextStyle(color: Color(0xFF065F46),
                        fontWeight: FontWeight.w700, fontSize: 14))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _compBox(String label, double price, Color bg, Color textColor) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kBorder),
        ),
        child: Column(
          children: [
            Text(label, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: _kMuted)),
            const SizedBox(height: 8),
            Text('US\$${price.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: textColor)),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────
//  Offer
// ─────────────────────────────────────────────────────
class _Offer {
  final String emoji, store, tag, name;
  final double oldPrice, price;
  const _Offer(this.emoji, this.store, this.tag, this.name, this.oldPrice, this.price);
}

class _OfferCard extends StatelessWidget {
  final _Offer offer;
  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    final discount = ((offer.oldPrice - offer.price) / offer.oldPrice * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: _kBg, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(offer.emoji, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _kAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(offer.tag, style: const TextStyle(
                          color: _kAccentDark, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),
                    Text(offer.store, style: const TextStyle(color: _kMuted, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(offer.name, style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13, color: _kText),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('US\$${offer.price.toStringAsFixed(0)}',
                        style: const TextStyle(color: _kPrimary, fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(width: 6),
                    Text('US\$${offer.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(color: _kMuted, fontSize: 11,
                            decoration: TextDecoration.lineThrough)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('-$discount%', style: const TextStyle(
                          color: Color(0xFF92400E), fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Group Buy
// ─────────────────────────────────────────────────────
class _Group {
  final String emoji, name, category;
  final double price, groupPrice;
  final int interested, needed;
  const _Group(this.emoji, this.name, this.price, this.groupPrice,
      this.interested, this.needed, this.category);
}

class _GroupCard extends StatelessWidget {
  final _Group group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final progress = group.interested / (group.interested + group.needed);
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
              Text(group.emoji, style: const TextStyle(fontSize: 32)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(group.category, style: const TextStyle(
                    color: _kPrimary, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(group.name, style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 15, color: _kText)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('US\$${group.groupPrice.toStringAsFixed(0)}', style: const TextStyle(
                  color: _kAccentDark, fontWeight: FontWeight.w800, fontSize: 20)),
              const SizedBox(width: 8),
              Text('US\$${group.price.toStringAsFixed(0)}', style: const TextStyle(
                  color: _kMuted, fontSize: 13, decoration: TextDecoration.lineThrough)),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress, backgroundColor: _kBorder,
              valueColor: const AlwaysStoppedAnimation(_kAccent), minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${group.interested} interesados', style: const TextStyle(
                  color: _kAccentDark, fontWeight: FontWeight.w600, fontSize: 12)),
              const Spacer(),
              Text('Faltan ${group.needed} para activar',
                  style: const TextStyle(color: _kMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _kPrimary, side: const BorderSide(color: _kPrimary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Unirme a esta compra',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Membership
// ─────────────────────────────────────────────────────
class _MembershipHero extends StatelessWidget {
  const _MembershipHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _kAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(100),
            border: Border.all(color: _kAccent.withOpacity(0.4)),
          ),
          child: const Text('ConexaShip Plus', style: TextStyle(
              color: _kAccent, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
        const SizedBox(height: 20),
        const Text('La membresía que\npaga por sí sola.', style: TextStyle(
            color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, height: 1.15)),
        const SizedBox(height: 16),
        const Text('Ahorra en cada envío con comisiones más bajas, inspecciones gratis y descuentos.',
            style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.6)),
        const SizedBox(height: 32),
        Row(
          children: [
            _pricePill('US\$4.99', 'mes'),
            const SizedBox(width: 16),
            _pricePill('US\$39.99', 'año · 2 meses gratis'),
          ],
        ),
      ],
    );
  }

  Widget _pricePill(String price, String period) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(price, style: const TextStyle(color: _kAccent, fontWeight: FontWeight.w800, fontSize: 20)),
            Text('/ $period', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
          ],
        ),
      );
}

class _MembershipCard extends StatelessWidget {
  final List<String> benefits;
  const _MembershipCard({required this.benefits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Beneficios incluidos', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 20),
          ...benefits.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 20, height: 20,
                      decoration: const BoxDecoration(color: _kAccent, shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(b, style: const TextStyle(
                        color: Colors.white70, fontSize: 14, height: 1.4))),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/membership'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAccent, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16), elevation: 0,
              ),
              child: const Text('Comenzar con Plus',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Testimonial
// ─────────────────────────────────────────────────────
class _Testimonial {
  final String name, role, text;
  final int rating;
  const _Testimonial(this.name, this.role, this.text, this.rating);
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial t;
  const _TestimonialCard({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kBg, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: List.generate(t.rating,
              (_) => const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18))),
          const SizedBox(height: 14),
          Text('"${t.text}"', style: const TextStyle(color: _kText, fontSize: 14, height: 1.7)),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 18, backgroundColor: _kPrimary,
                child: Text(t.name[0], style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.name, style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13, color: _kText)),
                  Text(t.role, style: const TextStyle(color: _kMuted, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  FAQ Item
// ─────────────────────────────────────────────────────
class _FaqItem extends StatelessWidget {
  final String question, answer;
  final bool isOpen;
  final VoidCallback onTap;
  const _FaqItem({required this.question, required this.answer,
      required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isOpen ? _kAccent : _kBorder, width: isOpen ? 1.5 : 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: Text(question, style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15, color: _kText))),
                  const SizedBox(width: 12),
                  Icon(isOpen ? Icons.remove_rounded : Icons.add_rounded,
                      color: isOpen ? _kAccent : _kMuted),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(answer, style: const TextStyle(
                  color: _kMuted, fontSize: 14, height: 1.7)),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Footer Brand
// ─────────────────────────────────────────────────────
class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(color: _kAccent, shape: BoxShape.circle),
              child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('ConexaShip', style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        Text('Courier inteligente para Ecuador.\nCompramos en USA, entregamos en tu puerta.',
            style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13, height: 1.6)),
        const SizedBox(height: 20),
        Row(
          children: [
            _socialBtn(Icons.chat_rounded, 'WhatsApp'),
            const SizedBox(width: 8),
            _socialBtn(Icons.email_outlined, 'Email'),
            const SizedBox(width: 8),
            _socialBtn(Icons.photo_camera_outlined, 'Instagram'),
          ],
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, String label) => Tooltip(
        message: label,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Icon(icon, color: Colors.white60, size: 18),
        ),
      );
}
