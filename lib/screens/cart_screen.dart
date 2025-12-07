import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_US');
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _AmazonStyleHeader()),
      body: cartProvider.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Add products to start shopping', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Browse Products'),
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 64 : 0,
                  vertical: isDesktop ? 32 : 0,
                ),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 32 : 12),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartProvider.items.length,
                            itemBuilder: (context, index) {
                              final item = cartProvider.items[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: isDesktop ? 100 : 70,
                                        height: isDesktop ? 100 : 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child:
                                            item.product.images != null &&
                                                item.product.images!.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.network(
                                                  item.product.images!.first,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const Icon(Icons.image, size: 40),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.product.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: isDesktop ? 20 : 16,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              currencyFormatter.format(item.product.price),
                                              style: TextStyle(
                                                color: Colors.orange.shade700,
                                                fontWeight: FontWeight.bold,
                                                fontSize: isDesktop ? 18 : 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove_circle_outline),
                                                onPressed: () => cartProvider.decrementQuantity(
                                                  item.product.id!,
                                                ),
                                              ),
                                              Text(
                                                '${item.quantity}',
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 18 : 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add_circle_outline),
                                                onPressed: () => cartProvider.incrementQuantity(
                                                  item.product.id!,
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextButton.icon(
                                            onPressed: () =>
                                                cartProvider.removeProduct(item.product.id!),
                                            icon: const Icon(Icons.delete_outline, size: 18),
                                            label: const Text('Remove'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10),
                            ],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                _SummaryRow(
                                  'Subtotal:',
                                  currencyFormatter.format(cartProvider.subtotal),
                                ),
                                _SummaryRow('Tax:', currencyFormatter.format(cartProvider.tax)),
                                _SummaryRow(
                                  'Shipping:',
                                  currencyFormatter.format(cartProvider.shipping),
                                ),
                                const Divider(),
                                _SummaryRow(
                                  'Total:',
                                  currencyFormatter.format(cartProvider.total),
                                  isTotal: true,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => context.push('/checkout'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      backgroundColor: Colors.orange.shade700,
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    child: const Text(
                                      'Proceed to Checkout',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _AmazonStyleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange.shade700,
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => context.go('/'),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag, color: Colors.white, size: 32),
                  const SizedBox(width: 8),
                  Text(
                    'ConexaShip',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () => context.push('/cart'),
              tooltip: 'Cart',
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.orange.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }
}
