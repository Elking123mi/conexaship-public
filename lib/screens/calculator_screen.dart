import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

const _kPrimary = Color(0xFF0B3D6E);
const _kAccent = Color(0xFF00C9A7);
const _kAccentDark = Color(0xFF00A98B);
const _kBg = Color(0xFFF8FAFC);
const _kBorder = Color(0xFFE5E7EB);
const _kText = Color(0xFF111827);
const _kMuted = Color(0xFF6B7280);

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _priceCtrl = TextEditingController(text: '500');
  final _weightCtrl = TextEditingController(text: '2');
  final _packagesCtrl = TextEditingController(text: '1');
  int _packagesUsed = 1;
  bool _assistedPurchase = false;

  double get _price => double.tryParse(_priceCtrl.text) ?? 0;
  double get _weight => double.tryParse(_weightCtrl.text) ?? 0;
  int get _packages => int.tryParse(_packagesCtrl.text) ?? 1;

  // Envío: base US$15 + US$3.50/lb (mínimo US$18)
  double get _shipping => (_weight * 3.5 + 15.0).clamp(18.0, 500.0);
  // Tarifa aduanera fija del régimen 4×4 (vigente desde junio 2025)
  double get _tariff4x4 => 20.0;
  // Comisión ConexaShip
  double get _commission => _assistedPurchase ? (_price * 0.05).clamp(10.0, 500.0) : 15.0;
  double get _handling => 5.0;
  // Total solo cuando aplica régimen 4×4 (≤ US$400)
  double get _total4x4 => _price + _shipping + _tariff4x4 + _handling + _commission;
  // Total parcial sin impuestos para productos > US$400
  double get _totalSinImpuestos => _price + _shipping + _commission;

  int get _cupoUsado => _packagesUsed;
  int get _cupoDisponible => 4 - _cupoUsado;
  bool get _excedeCupo => _packages + _packagesUsed > 4;
  bool get _excedeValor => _price > 400;

  @override
  void dispose() {
    _priceCtrl.dispose();
    _weightCtrl.dispose();
    _packagesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _kPrimary,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        title: const Text('Calculadora 4×4',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF08274A), _kPrimary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Calculadora 4×4',
                            style: TextStyle(color: Colors.white, fontSize: 22,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(
                          'Estima el costo total de tu compra en USA incluyendo envío, impuestos y comisión.',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75), fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.calculate_rounded, color: _kAccent, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            mobile
                ? Column(children: [_inputsCard(context), const SizedBox(height: 24), _resultsCard(context), const SizedBox(height: 24), _cupoCard(context)])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _inputsCard(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 4, child: Column(children: [_resultsCard(context), const SizedBox(height: 20), _cupoCard(context)])),
                    ],
                  ),
            const SizedBox(height: 32),
            _warningsSection(context),
            const SizedBox(height: 32),
            _tipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _inputsCard(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos del producto', style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 16, color: _kText)),
          const SizedBox(height: 20),
          _field('Precio del producto (USD)', '\$', _priceCtrl, context),
          const SizedBox(height: 16),
          _field('Peso estimado (libras)', '⚖', _weightCtrl, context),
          const SizedBox(height: 16),
          _field('Número de paquetes de este envío', '📦', _packagesCtrl, context),
          const SizedBox(height: 20),
          // Cupo usado slider
          const Text('Paquetes ya usados este año', style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: _kText)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _packagesUsed.toDouble(),
                  min: 0, max: 4,
                  divisions: 4,
                  activeColor: _kAccent,
                  inactiveColor: _kBorder,
                  onChanged: (v) => setState(() => _packagesUsed = v.toInt()),
                ),
              ),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _kPrimary, borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('$_packagesUsed',
                    style: const TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w800))),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Compra asistida
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kBg, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Compra asistida', style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14, color: _kText)),
                      const SizedBox(height: 4),
                      Text('ConexaShip compra por ti (+5% comisión)',
                          style: TextStyle(color: _kMuted, fontSize: 12)),
                    ],
                  ),
                ),
                Switch(
                  value: _assistedPurchase,
                  onChanged: (v) => setState(() => _assistedPurchase = v),
                  activeColor: _kAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultsCard(BuildContext context) {
    if (_excedeValor) return _resultsCardOverLimit();
    return _resultsCard4x4();
  }

  // Tarjeta para productos dentro del régimen 4×4 (≤ US$400)
  Widget _resultsCard4x4() {
    return _Card(
      color: _kPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Desglose 4×4', style: TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text('Régimen 4×4 ✓',
                    style: TextStyle(color: _kAccent, fontWeight: FontWeight.w700, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _rRow('💵 Precio del producto', 'US\$${_price.toStringAsFixed(2)}'),
          const Divider(color: Colors.white24, height: 24),
          _rRow('✈️ Envío Servientrega (~${_weight.toStringAsFixed(1)} lb)', 'US\$${_shipping.toStringAsFixed(2)}'),
          _rRow('🏛️ Tarifa aduanera 4×4', 'US\$${_tariff4x4.toStringAsFixed(2)}'),
          _rRow('📋 Manejo y entrega', 'US\$${_handling.toStringAsFixed(2)}'),
          _rRow(
            _assistedPurchase ? '🛒 Compra asistida (5%)' : '🤝 Comisión ConexaShip',
            'US\$${_commission.toStringAsFixed(2)}',
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL ESTIMADO', style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              Text('US\$${_total4x4.toStringAsFixed(2)}', style: const TextStyle(
                  color: _kAccent, fontWeight: FontWeight.w800, fontSize: 28)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.white60, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(
                    'La tarifa aduanera 4×4 es fija (US\$20) vigente desde junio 2025. El envío varía según peso real.',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, height: 1.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta para productos que superan el límite 4×4 (> US$400)
  Widget _resultsCardOverLimit() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Banner superior
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFFEF2F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFDC2626), size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Supera el límite 4×4',
                          style: TextStyle(color: Color(0xFF991B1B),
                              fontWeight: FontWeight.w800, fontSize: 15)),
                      SizedBox(height: 4),
                      Text('Este producto requiere cotización personalizada',
                          style: TextStyle(color: Color(0xFFB91C1C),
                              fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Desglose parcial
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rRowDark('💵 Precio del producto', 'US\$${_price.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _rRowDark('✈️ Envío estimado', 'US\$${_shipping.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _rRowDark(
                  _assistedPurchase ? '🛒 Compra asistida (5%)' : '🤝 Comisión ConexaShip',
                  'US\$${_commission.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.account_balance_rounded,
                          color: Color(0xFF92400E), size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '🏛️ Impuestos aduaneros: por confirmar\nDependen del tipo de producto (arancel + IVA 15% + FODINFA 0.5%)',
                          style: TextStyle(color: Color(0xFF78350F),
                              fontSize: 12, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 28, color: Color(0xFFE5E7EB)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SUBTOTAL (sin impuestos)',
                        style: TextStyle(color: _kMuted,
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    Text('US\$${_totalSinImpuestos.toStringAsFixed(2)}',
                        style: const TextStyle(color: _kText,
                            fontWeight: FontWeight.w800, fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // ignore: undefined_prefixed_name
                    },
                    icon: const Text('💬', style: TextStyle(fontSize: 18)),
                    label: const Text('Solicitar cotización personalizada',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cupoCard(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cupo anual 4×4', style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16, color: _kText)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _cupoDisponible > 0 ? _kAccent.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  _cupoDisponible > 0 ? '$_cupoDisponible disponibles' : 'Cupo agotado',
                  style: TextStyle(
                      color: _cupoDisponible > 0 ? _kAccentDark : Colors.red,
                      fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(4, (i) {
              final used = i < _cupoUsado;
              final thisPkg = i >= _cupoUsado && i < _cupoUsado + _packages;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 40,
                  decoration: BoxDecoration(
                    color: used ? _kPrimary : thisPkg ? _kAccent : _kBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: thisPkg ? _kAccent : _kBorder),
                  ),
                  child: Center(
                    child: Icon(
                      used ? Icons.check_rounded : Icons.inventory_2_outlined,
                      color: used ? Colors.white : thisPkg ? Colors.white : _kMuted,
                      size: 18,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cupoLegend(_kPrimary, 'Usados ($_cupoUsado)'),
              _cupoLegend(_kAccent, 'Este envío ($_packages)'),
              _cupoLegend(_kBg, 'Disponibles ($_cupoDisponible)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cupoLegend(Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3),
              border: Border.all(color: _kBorder))),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: _kMuted, fontSize: 11)),
        ],
      );

  Widget _warningsSection(BuildContext context) {
    if (!_excedeCupo) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Advertencias', style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 16, color: _kText)),
        const SizedBox(height: 12),
        if (_excedeCupo)
          _warningBox(Icons.warning_rounded, const Color(0xFFFEF3C7), const Color(0xFF92400E),
              'Excedes tu cupo anual 4×4',
              'Este paquete superaría el límite de 4 paquetes por año. Consulta con ConexaShip sobre opciones alternativas.'),
      ],
    );
  }

  Widget _warningBox(IconData icon, Color bg, Color textColor, String title, String desc) =>
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _tipsSection() {
    final tips = [
      ('💡 Consolida envíos', 'Enviar varios artículos juntos reduce el costo por libra.'),
      ('📋 Declara correctamente', 'El valor declarado determina los impuestos. Sé honesto.'),
      ('⚖️ Pesa antes de comprar', 'Consulta el peso en la página del producto para estimar mejor.'),
      ('🛡️ Inspección premium', 'Para artículos de alto valor, considera la inspección premium (US\$8–10).'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Consejos de importación', style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 16, color: _kText)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width < 700 ? 1 : 2,
            crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 4.5,
          ),
          itemCount: tips.length,
          itemBuilder: (_, i) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tips[i].$1.split(' ').first, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(tips[i].$1.substring(3), style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13, color: _kText)),
                      const SizedBox(height: 2),
                      Flexible(child: Text(tips[i].$2, style: const TextStyle(
                          color: _kMuted, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(String label, String prefix, TextEditingController ctrl, BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: _kText)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 15, color: _kText),
            decoration: InputDecoration(
              prefixText: '$prefix  ',
              prefixStyle: const TextStyle(color: _kMuted),
              fillColor: Colors.white, filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kAccent, width: 2)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ],
      );

  Widget _rRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 13))),
            Text(value, style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      );

  Widget _rRowDark(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label,
              style: const TextStyle(color: _kMuted, fontSize: 13))),
          Text(value, style: const TextStyle(
              color: _kText, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      );
}

class _Card extends StatelessWidget {
  final Widget child;
  final Color? color;
  const _Card({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: color == null ? Border.all(color: _kBorder) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}
