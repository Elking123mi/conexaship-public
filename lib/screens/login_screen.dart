import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isDesktop => MediaQuery.of(context).size.width > 800;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F4C81), Color(0xFF19598A), Color(0xFF44D7B6)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(_isDesktop ? 48 : 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _isDesktop
                  ? _buildDesktopLayout(authProvider)
                  : _buildMobileLayout(authProvider),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(AuthProvider authProvider) {
    return Card(
      elevation: 18,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SizedBox(
        width: 980,
        height: 620,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(44),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F4C81), Color(0xFF19598A), Color(0xFF44D7B6)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flash_on_rounded, size: 72, color: Colors.white),
                    const SizedBox(height: 24),
                    const Text(
                      'Bienvenido a ConexaShip',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Compra productos, gestiona tu cuenta y recibe descuentos inteligentes con nuestro asistente IA.',
                      style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('• Accede rápido a tu historial de compras', style: TextStyle(color: Colors.white)),
                          SizedBox(height: 10),
                          Text('• Descubre cupones automáticos', style: TextStyle(color: Colors.white)),
                          SizedBox(height: 10),
                          Text('• Navega con un diseño ágil y moderno', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
                child: _buildLoginForm(authProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(AuthProvider authProvider) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flash_on_rounded, size: 64, color: Color(0xFF44D7B6)),
            const SizedBox(height: 16),
            const Text(
              'Inicia sesión en ConexaShip',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F4C81)),
            ),
            const SizedBox(height: 10),
            Text(
              'Tu tienda inteligente con ofertas, envío rápido y asistente IA para cupones.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6),
            ),
            const SizedBox(height: 28),
            _buildLoginForm(authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Iniciar sesión',
            style: TextStyle(
              fontSize: _isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade900,
            ),
          ),
          SizedBox(height: _isDesktop ? 28 : 20),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: _isDesktop ? 16 : 14),
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'ejemplo@mail.com',
              prefixIcon: Icon(Icons.email_outlined, size: _isDesktop ? 24 : 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Ingrese su correo electrónico';
              if (!value.contains('@')) return 'Ingrese un correo válido';
              return null;
            },
          ),
          SizedBox(height: _isDesktop ? 18 : 14),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(fontSize: _isDesktop ? 16 : 14),
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock_outline, size: _isDesktop ? 24 : 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: Colors.grey.shade100,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: _isDesktop ? 24 : 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Ingrese su contraseña';
              return null;
            },
          ),
          SizedBox(height: _isDesktop ? 16 : 14),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),

          if (authProvider.error != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authProvider.error!,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await authProvider.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (success && mounted) context.go('/');
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: _isDesktop ? 18 : 16),
              backgroundColor: const Color(0xFF44D7B6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Continuar',
                    style: TextStyle(fontSize: _isDesktop ? 18 : 16, fontWeight: FontWeight.bold),
                  ),
          ),
          SizedBox(height: _isDesktop ? 18 : 16),

          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('o'),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.smart_toy, color: Color(0xFF44D7B6)),
            label: const Text('Usar asistente IA'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF44D7B6)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          SizedBox(height: _isDesktop ? 18 : 14),
          TextButton(
            onPressed: () => context.push('/register'),
            child: const Text(
              '¿No tienes cuenta? Regístrate',
              style: TextStyle(color: Color(0xFF44D7B6)),
            ),
          ),
        ],
      ),
    );
  }
}
