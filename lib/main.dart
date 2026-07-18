import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/products_provider.dart';
import 'screens/services_home_screen.dart';
import 'screens/service_detail_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/verify_email_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/extra_screens.dart';

void main() {
  runApp(const ConexaShipApp());
}

class ConexaShipApp extends StatelessWidget {
  const ConexaShipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Conexa Ship',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0F4C81),
                primary: const Color(0xFF0F4C81),
                secondary: const Color(0xFF44D7B6),
                brightness: Brightness.light,
              ),
              textTheme: GoogleFonts.interTextTheme(),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF7FBFF),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0F4C81),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ServicesHomeScreen()),
    GoRoute(path: '/service-detail/:type', builder: (context, state) {
      final serviceType = state.pathParameters['type'] ?? 'point-to-point';
      return ServiceDetailScreen(serviceType: serviceType);
    }),
    GoRoute(path: '/booking', builder: (context, state) {
      final serviceType = state.uri.queryParameters['service'] ?? 'point-to-point';
      return BookingScreen(serviceType: serviceType);
    }),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final email = (state.extra as String?) ?? '';
        return VerifyEmailScreen(email: email);
      },
    ),
    GoRoute(path: '/checkout', builder: (context, state) => const CheckoutScreen()),
    GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
    // New screens
    GoRoute(path: '/calculator', builder: (context, state) => const CalculatorScreen()),
    GoRoute(path: '/offers', builder: (context, state) => const OffersScreen()),
    GoRoute(path: '/group-buy', builder: (context, state) => const GroupBuyScreen()),
    GoRoute(path: '/membership', builder: (context, state) => const MembershipScreen()),
    GoRoute(path: '/tracking', builder: (context, state) => const TrackingScreen()),
    GoRoute(path: '/how-it-works', builder: (context, state) => const HowItWorksScreen()),
  ],
);
