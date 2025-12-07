import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Pedidos')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.receipt_long, size: 100),
              const SizedBox(height: 24),
              Text('Sin Pedidos', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              const Text('Aún no has realizado ningún pedido', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Comenzar a Comprar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
