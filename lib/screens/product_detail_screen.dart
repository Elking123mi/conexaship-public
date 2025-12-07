import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import 'package:conexaship_core/conexaship_core.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_US');
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _AmazonStyleHeader()),
      body: FutureBuilder<Product?>(
        future: productsProvider.getProduct(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Product not found'));
          }
          final product = snapshot.data!;

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 64 : 0,
                  vertical: isDesktop ? 32 : 0,
                ),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 32 : 16),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProductImage(product: product, isDesktop: true),
                              const SizedBox(width: 40),
                              Expanded(
                                child: _ProductInfo(
                                  product: product,
                                  currencyFormatter: currencyFormatter,
                                  cartProvider: cartProvider,
                                  isDesktop: true,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProductImage(product: product, isDesktop: false),
                              const SizedBox(height: 24),
                              _ProductInfo(
                                product: product,
                                currencyFormatter: currencyFormatter,
                                cartProvider: cartProvider,
                                isDesktop: false,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Product?>(
        future: productsProvider.getProduct(productId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final product = snapshot.data!;
          final inCart = cartProvider.containsProduct(product.id!);
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (inCart)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.push('/cart'),
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('View Cart'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  if (inCart) const SizedBox(width: 12),
                  Expanded(
                    flex: inCart ? 1 : 2,
                    child: ElevatedButton.icon(
                      onPressed: product.inStock
                          ? () {
                              cartProvider.addProduct(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product added to cart'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(inCart ? 'Add More' : 'Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

class _ProductImage extends StatelessWidget {
  final Product product;
  final bool isDesktop;
  const _ProductImage({required this.product, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isDesktop ? 420 : 320,
      width: isDesktop ? 420 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: product.images != null && product.images!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(product.images!.first, fit: BoxFit.contain),
            )
          : const Center(child: Icon(Icons.image, size: 100, color: Colors.grey)),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;
  final NumberFormat currencyFormatter;
  final CartProvider cartProvider;
  final bool isDesktop;
  const _ProductInfo({
    required this.product,
    required this.currencyFormatter,
    required this.cartProvider,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: isDesktop ? 32 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 12),
        if (product.rating != null)
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < product.rating!.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: isDesktop ? 28 : 20,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '${product.rating!.toStringAsFixed(1)} (${product.reviewCount ?? 0} reviews)',
                style: TextStyle(color: Colors.grey[700], fontSize: isDesktop ? 18 : 14),
              ),
            ],
          ),
        const SizedBox(height: 18),
        if (product.isOnSale)
          Text(
            currencyFormatter.format(product.compareAtPrice),
            style: TextStyle(
              fontSize: isDesktop ? 22 : 16,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[600],
            ),
          ),
        Text(
          currencyFormatter.format(product.price),
          style: TextStyle(
            fontSize: isDesktop ? 38 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          product.inStock ? 'In stock (${product.stock} available)' : 'Out of stock',
          style: TextStyle(
            color: product.inStock ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: isDesktop ? 18 : 15,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Description',
          style: TextStyle(
            fontSize: isDesktop ? 22 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: TextStyle(fontSize: isDesktop ? 18 : 15, height: 1.5, color: Colors.grey[800]),
        ),
        const SizedBox(height: 32),
        // Add to cart button (duplicated for desktop, for better UX)
        if (isDesktop)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: product.inStock
                      ? () {
                          cartProvider.addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product added to cart'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
