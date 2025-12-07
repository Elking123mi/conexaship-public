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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange.shade700, Colors.orange.shade400, Colors.orange.shade200],
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
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 900,
        height: 600,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange.shade600, Colors.orange.shade800],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_shipping_rounded, size: 120, color: Colors.white),
                    const SizedBox(height: 24),
                    const Text(
                      'CONEXASHIP',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Shipping Management System',
                      style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
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
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_shipping_rounded, size: 70, color: Colors.orange.shade700),
            const SizedBox(height: 16),
            Text(
              'CONEXASHIP',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Shipping Management System',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
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
            'Sign In',
            style: TextStyle(
              fontSize: _isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: _isDesktop ? 32 : 24),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: _isDesktop ? 16 : 14),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'example@email.com',
              prefixIcon: Icon(Icons.email_outlined, size: _isDesktop ? 24 : 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!value.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          SizedBox(height: _isDesktop ? 20 : 16),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(fontSize: _isDesktop ? 16 : 14),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: '',
              prefixIcon: Icon(Icons.lock_outline, size: _isDesktop ? 24 : 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: _isDesktop ? 24 : 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your password';
              return null;
            },
          ),
          SizedBox(height: _isDesktop ? 24 : 20),

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
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Sign In',
                    style: TextStyle(fontSize: _isDesktop ? 18 : 16, fontWeight: FontWeight.bold),
                  ),
          ),
          SizedBox(height: _isDesktop ? 20 : 16),

          TextButton(
            onPressed: () => context.push('/register'),
            child: Text(
              'Don\'t have an account? Sign Up',
              style: TextStyle(color: Colors.orange.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
