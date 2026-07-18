import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

// ── Colores del sistema de diseño ────────────────────────────────────────────
const _kPrimary   = Color(0xFF0B3D6E);
const _kAccent    = Color(0xFF00C9A7);
const _kBg        = Color(0xFFF8FAFC);
const _kBorder    = Color(0xFFE5E7EB);
const _kText      = Color(0xFF111827);
const _kMuted     = Color(0xFF6B7280);
const _kError     = Color(0xFFDC2626);
const _kWarn      = Color(0xFFD97706);
const _kSuccess   = Color(0xFF059669);

// ── Reglas de contraseña ──────────────────────────────────────────────────────
class _PasswordRule {
  final String label;
  final bool Function(String) check;
  const _PasswordRule(this.label, this.check);
}

final _passwordRules = <_PasswordRule>[
  _PasswordRule('Mínimo 8 caracteres',         (p) => p.length >= 8),
  _PasswordRule('Al menos una mayúscula',       (p) => p.contains(RegExp(r'[A-Z]'))),
  _PasswordRule('Al menos una minúscula',       (p) => p.contains(RegExp(r'[a-z]'))),
  _PasswordRule('Al menos un número',           (p) => p.contains(RegExp(r'[0-9]'))),
  _PasswordRule('Al menos un símbolo (!@#\$…)', (p) => p.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]'))),
];

int _passwordStrength(String p) =>
    _passwordRules.where((r) => r.check(p)).length;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController  = TextEditingController();
  final _emailController     = TextEditingController();
  final _phoneController     = TextEditingController();
  final _passwordController  = TextEditingController();
  final _confirmController   = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool _acceptTerms     = false;
  String _password      = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: _kBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1040 : 520),
            child: Card(
              elevation: 12,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: isDesktop
                    ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(flex: 5, child: _buildSideBanner()),
                        const SizedBox(width: 32),
                        Expanded(flex: 5, child: _buildForm(authProvider)),
                      ])
                    : _buildForm(authProvider),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Banner lateral ──────────────────────────────────────────────────────────
  Widget _buildSideBanner() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF08274A), _kPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ConexaShip', style: TextStyle(
              color: _kAccent, fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 20),
          const Text('Crea tu cuenta', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30)),
          const SizedBox(height: 12),
          Text('Accede a precios exclusivos, rastreo en tiempo real y el régimen 4×4 sin complicaciones.',
              style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14, height: 1.6)),
          const SizedBox(height: 32),
          ...[
            ('🔒', 'Cuenta segura con verificación de email'),
            ('📦', 'Casillero personal en Miami'),
            ('💰', 'Tarifa 4×4 fija – sin sorpresas'),
            ('📱', 'Rastreo en tiempo real'),
          ].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(children: [
              Text(item.$1, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text(item.$2, style: const TextStyle(
                  color: Colors.white, fontSize: 13))),
            ]),
          )),
        ],
      ),
    );
  }

  // ── Formulario principal ────────────────────────────────────────────────────
  Widget _buildForm(AuthProvider authProvider) {
    final strength = _passwordStrength(_password);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título
          const Text('Crear cuenta', style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w800, color: _kPrimary)),
          const SizedBox(height: 6),
          const Text('Completa los datos y confirma tu email para activar tu cuenta.',
              style: TextStyle(color: _kMuted, fontSize: 13, height: 1.5)),
          const SizedBox(height: 28),

          // Nombre + Apellido
          Row(children: [
            Expanded(child: _field('Nombre', Icons.person_rounded, _firstNameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null)),
            const SizedBox(width: 14),
            Expanded(child: _field('Apellido', Icons.person_outline_rounded, _lastNameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null)),
          ]),
          const SizedBox(height: 16),

          // Email
          _field('Correo electrónico', Icons.email_rounded, _emailController,
              keyboard: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
                final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$', caseSensitive: false);
                if (!emailRegex.hasMatch(v.trim())) return 'Formato de correo inválido';
                return null;
              }),
          const SizedBox(height: 16),

          // Teléfono
          _field('Teléfono (opcional)', Icons.phone_rounded, _phoneController,
              keyboard: TextInputType.phone),
          const SizedBox(height: 16),

          // Contraseña
          _passwordField(),
          const SizedBox(height: 10),

          // Medidor de fortaleza
          if (_password.isNotEmpty) ...[
            _strengthBar(strength),
            const SizedBox(height: 10),
            _rulesChecklist(),
            const SizedBox(height: 16),
          ],

          // Confirmar contraseña
          _field('Confirmar contraseña', Icons.lock_outline_rounded, _confirmController,
              obscure: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: _kMuted),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                if (v != _passwordController.text) return 'Las contraseñas no coinciden';
                return null;
              }),
          const SizedBox(height: 20),

          // Términos y condiciones
          GestureDetector(
            onTap: () => setState(() => _acceptTerms = !_acceptTerms),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _acceptTerms,
                  activeColor: _kAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: _kMuted, fontSize: 12, height: 1.5),
                        children: [
                          TextSpan(text: 'Acepto los '),
                          TextSpan(text: 'Términos de Servicio',
                              style: TextStyle(color: _kAccent, fontWeight: FontWeight.w600)),
                          TextSpan(text: ' y la '),
                          TextSpan(text: 'Política de Privacidad',
                              style: TextStyle(color: _kAccent, fontWeight: FontWeight.w600)),
                          TextSpan(text: ' de ConexaShip.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Error global
          if (authProvider.error != null)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(children: [
                const Icon(Icons.error_outline_rounded, color: _kError, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(authProvider.error!,
                    style: const TextStyle(color: _kError, fontSize: 13))),
              ]),
            ),

          // Botón crear cuenta
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: (authProvider.isLoading || !_acceptTerms || strength < 5)
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await authProvider.register(
                          firstName: _firstNameController.text.trim(),
                          lastName:  _lastNameController.text.trim(),
                          email:     _emailController.text.trim(),
                          password:  _passwordController.text,
                          phone:     _phoneController.text.trim().isEmpty
                              ? null : _phoneController.text.trim(),
                        );
                        if (success && mounted) {
                          context.push('/verify-email',
                              extra: _emailController.text.trim());
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _kBorder,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: authProvider.isLoading
                  ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : const Text('Crear cuenta y verificar email',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 20),

          // Ya tienes cuenta
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('¿Ya tienes cuenta? ', style: TextStyle(color: _kMuted, fontSize: 13)),
            GestureDetector(
              onTap: () => context.go('/login'),
              child: const Text('Inicia sesión',
                  style: TextStyle(color: _kAccent, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ]),
        ],
      ),
    );
  }

  // ── Widget: campo de texto genérico ─────────────────────────────────────────
  Widget _field(
    String label,
    IconData icon,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: _kText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _kMuted, fontSize: 13),
        prefixIcon: Icon(icon, color: _kMuted, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kAccent, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kError)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kError, width: 2)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
    );
  }

  // ── Widget: campo de contraseña con listener ─────────────────────────────────
  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontSize: 14, color: _kText),
      onChanged: (v) => setState(() => _password = v),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: const TextStyle(color: _kMuted, fontSize: 13),
        prefixIcon: const Icon(Icons.lock_rounded, color: _kMuted, size: 20),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: _kMuted),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kAccent, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kError)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kError, width: 2)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Ingresa una contraseña';
        if (_passwordStrength(v) < 5) return 'La contraseña no cumple todos los requisitos';
        return null;
      },
    );
  }

  // ── Widget: barra de fortaleza ───────────────────────────────────────────────
  Widget _strengthBar(int strength) {
    final colors  = [_kError, _kError, _kWarn, _kWarn, _kSuccess, _kSuccess];
    final labels  = ['', 'Muy débil', 'Débil', 'Regular', 'Buena', 'Fuerte'];
    final color   = colors[strength];
    final label   = labels[strength];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: List.generate(5, (i) => Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
            decoration: BoxDecoration(
              color: i < strength ? color : _kBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ))),
        const SizedBox(height: 5),
        Text('Seguridad: $label',
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ── Widget: checklist de reglas ──────────────────────────────────────────────
  Widget _rulesChecklist() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _passwordRules.map((rule) {
          final ok = rule.check(_password);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(children: [
              Icon(ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  size: 15, color: ok ? _kSuccess : _kMuted),
              const SizedBox(width: 8),
              Text(rule.label,
                  style: TextStyle(
                      fontSize: 12,
                      color: ok ? _kSuccess : _kMuted,
                      fontWeight: ok ? FontWeight.w600 : FontWeight.normal)),
            ]),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}
