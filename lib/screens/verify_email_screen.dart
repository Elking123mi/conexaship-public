import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:conexaship_core/conexaship_core.dart';

const _kPrimary  = Color(0xFF0B3D6E);
const _kAccent   = Color(0xFF00C9A7);
const _kBg       = Color(0xFFF8FAFC);
const _kBorder   = Color(0xFFE5E7EB);
const _kText     = Color(0xFF111827);
const _kMuted    = Color(0xFF6B7280);
const _kError    = Color(0xFFDC2626);
const _kSuccess  = Color(0xFF059669);

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  // 6 controllers — uno por dígito
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  bool _loading  = false;
  bool _verified = false;
  String? _error;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _resendCountdown = 60;
    _canResend = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) _canResend = true;
      });
      return _resendCountdown > 0;
    });
  }

  String get _code => _ctrls.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    // Auto-verificar cuando los 6 dígitos estén completos
    if (_code.length == 6) _verify();
    setState(() {});
  }

  Future<void> _verify() async {
    if (_code.length != 6) return;
    setState(() { _loading = true; _error = null; });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'code': _code}),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() { _loading = false; _verified = true; });
      } else {
        setState(() {
          _loading = false;
          _error = data['message'] ?? 'Código incorrecto';
          // Limpiar campos si el código es incorrecto
          for (final c in _ctrls) c.clear();
          _nodes[0].requestFocus();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Error de conexión. Intenta de nuevo.';
      });
    }
  }

  Future<void> _resend() async {
    if (!_canResend) return;
    setState(() { _error = null; _loading = true; });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/auth/send-verification-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (!mounted) return;
      setState(() { _loading = false; });

      if (response.statusCode == 200 && data['success'] == true) {
        _startCountdown();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Código reenviado — revisa tu bandeja'),
            backgroundColor: _kSuccess,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        setState(() { _error = data['message'] ?? 'Error al reenviar código'; });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Error de conexión al reenviar código';
      });
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Código reenviado — revisa tu bandeja'),
          backgroundColor: _kSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _verified ? _buildSuccess() : _buildVerifyCard(),
          ),
        ),
      ),
    );
  }

  // ── Tarjeta de verificación ──────────────────────────────────────────────────
  Widget _buildVerifyCard() {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 24, offset: const Offset(0, 8))],
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: _kAccent.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_unread_rounded, color: _kAccent, size: 36),
          ),
          const SizedBox(height: 20),
          const Text('Verifica tu correo', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: _kPrimary)),
          const SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: _kMuted, fontSize: 13, height: 1.6),
              children: [
                const TextSpan(text: 'Enviamos un código de 6 dígitos a\n'),
                TextSpan(
                  text: widget.email,
                  style: const TextStyle(
                      color: _kPrimary, fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: '\nIngresa el código para activar tu cuenta.'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Campos OTP
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              final filled = _ctrls[i].text.isNotEmpty;
              return Container(
                width: 46, height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: filled ? _kAccent.withOpacity(0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: filled ? _kAccent : _kBorder,
                    width: filled ? 2 : 1,
                  ),
                ),
                child: TextField(
                  controller: _ctrls[i],
                  focusNode: _nodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800, color: _kPrimary),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (v) => _onDigitChanged(i, v),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Error
          if (_error != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(children: [
                const Icon(Icons.error_outline_rounded, color: _kError, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(_error!,
                    style: const TextStyle(color: _kError, fontSize: 12))),
              ]),
            ),

          const SizedBox(height: 24),

          // Botón verificar
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (_loading || _code.length < 6) ? null : _verify,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _kBorder,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _loading
                  ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : const Text('Verificar código',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 20),

          // Reenviar
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('¿No recibiste el código? ', style: TextStyle(color: _kMuted, fontSize: 13)),
            GestureDetector(
              onTap: _canResend ? _resend : null,
              child: Text(
                _canResend ? 'Reenviar' : 'Reenviar en ${_resendCountdown}s',
                style: TextStyle(
                  color: _canResend ? _kAccent : _kMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          // Info sobre el email de Supabase
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFF0369A1), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'También recibirás un link de confirmación en tu correo. Puedes usar el código O hacer clic en el link — cualquiera activa tu cuenta.',
                    style: TextStyle(color: Color(0xFF0369A1), fontSize: 11, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Pantalla de éxito ────────────────────────────────────────────────────────
  Widget _buildSuccess() {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded, color: _kSuccess, size: 44),
          ),
          const SizedBox(height: 20),
          const Text('¡Cuenta verificada!', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: _kPrimary)),
          const SizedBox(height: 10),
          Text(
            'Tu cuenta en ConexaShip ha sido activada. Ya puedes iniciar sesión.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _kMuted, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Iniciar sesión', style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }
}
