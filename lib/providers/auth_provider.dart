import 'package:flutter/foundation.dart';
import 'package:conexaship_core/conexaship_core.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  Customer? _currentCustomer;
  bool _isLoading = false;
  String? _error;

  Customer? get currentCustomer => _currentCustomer;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentCustomer != null;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLogged = await _authService.isLoggedIn();
    if (isLogged) {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _currentCustomer = Customer.fromJson(userData);
        notifyListeners();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _authService.login(email, password);
      final user = data['user'] as Map<String, dynamic>;
      
      // Validar que tenga acceso a conexaship
      final allowedApps = List<String>.from(user['allowed_apps'] ?? []);
      if (!allowedApps.contains('conexaship')) {
        await _authService.logout();
        _error = 'No tienes acceso a Conexaship. Apps permitidas: ${allowedApps.join(", ")}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      _currentCustomer = Customer.fromJson(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      // Mostrar el error real para debugging
      final errorMsg = e.toString();
      if (errorMsg.contains('SocketException') || errorMsg.contains('Connection')) {
        _error = 'No se puede conectar al servidor. Verifica tu conexión.';
      } else if (errorMsg.contains('TimeoutException')) {
        _error = 'El servidor no responde. Intenta de nuevo.';
      } else {
        _error = 'Error: $errorMsg';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Error inesperado: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _userService.registerUser(
        username: email,
        email: email,
        password: password,
        name: '$firstName $lastName',
        roles: ['client'],
        allowedApps: ['conexaship'],
      );
      
      // Hacer login automáticamente después del registro
      await _authService.login(email, password);
      _currentCustomer = Customer.fromJson(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al registrar: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentCustomer = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
