class ApiConfig {
  // ✅ Backend en Railway (Cloud 24/7)
  // ✨ Funciona para Web, Android, iOS, Windows, Mac, Linux
  // 🌐 No necesita que tu PC esté prendida
  static const String baseUrl = 'https://conexaship-backend-production.up.railway.app';
  static const String authLoginUrl = '$baseUrl/api/v1/auth/login';
  static const String authRefreshUrl = '$baseUrl/api/v1/auth/refresh';
  static const String authLogoutUrl = '$baseUrl/api/v1/auth/logout';
  static const String authMeUrl = '$baseUrl/api/v1/auth/me';
  static const String usersUrl = '$baseUrl/api/v1/users';
  static const String tripsUrl = '$baseUrl/api/v1/trips';
  static const String paymentsUrl = '$baseUrl/api/v1/payments';
  
  static const Duration timeout = Duration(seconds: 30);
  
  // 📝 Docs: https://conexaship-backend-production.up.railway.app/docs
  // 🗄️ Database: Supabase (Cloud)
}
