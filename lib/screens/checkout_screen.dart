import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:conexaship_core/conexaship_core.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vendorCodeController = TextEditingController();
  
  String? _validatedVendorCode;
  Vendor? _vendor;
  bool _isValidatingCode = false;
  double _vendorDiscount = 0.0;

  @override
  void dispose() {
    _vendorCodeController.dispose();
    super.dispose();
  }

  Future<void> _validateVendorCode() async {
    final code = _vendorCodeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isValidatingCode = true);

    try {
      // TODO: Implementar GET /api/v1/vendors/validate/{code}
      /*
      final response = await apiService.validateVendorCode(code);
      if (response.valid) {
        setState(() {
          _validatedVendorCode = code;
          _vendor = response.vendor;
          _vendorDiscount = response.discountForCustomer ?? 5.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Valid vendor code! You get ${_vendorDiscount}% off'),
            backgroundColor: Colors.green,
          ),
        );
      }
      */
      
      // Mock para desarrollo
      setState(() {
        _validatedVendorCode = code;
        _vendorDiscount = 5.0;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Vendor code validated! You get 5% off'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Invalid vendor code'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isValidatingCode = false);
    }
  }

  void _clearVendorCode() {
    setState(() {
      _vendorCodeController.clear();
      _validatedVendorCode = null;
      _vendor = null;
      _vendorDiscount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final subtotal = cartProvider.subtotal;
    final discount = subtotal * (_vendorDiscount / 100);
    final subtotalAfterDiscount = subtotal - discount;
    final tax = subtotalAfterDiscount * 0.13; // 13% IVA
    final shipping = 10.0;
    final total = subtotalAfterDiscount + tax + shipping;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildPriceRow('Subtotal', subtotal),
                      if (_validatedVendorCode != null) ...[
                        const Divider(),
                        _buildPriceRow(
                          'Vendor Discount (${_vendorDiscount.toStringAsFixed(0)}%)',
                          -discount,
                          color: Colors.green,
                        ),
                      ],
                      const Divider(),
                      _buildPriceRow('Tax (13%)', tax),
                      _buildPriceRow('Shipping', shipping),
                      const Divider(thickness: 2),
                      _buildPriceRow('Total', total, isBold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Vendor Code Section
              const Text(
                'Have a Vendor Code?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                color: _validatedVendorCode != null 
                    ? Colors.green.shade50 
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_validatedVendorCode == null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _vendorCodeController,
                                decoration: const InputDecoration(
                                  labelText: 'Vendor Code',
                                  hintText: 'VEND-XXXX-2024',
                                  prefixIcon: Icon(Icons.local_offer),
                                  border: OutlineInputBorder(),
                                ),
                                textCapitalization: TextCapitalization.characters,
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _isValidatingCode ? null : _validateVendorCode,
                              child: _isValidatingCode
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Apply'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '💡 Enter a vendor referral code to get a discount!',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Vendor Code Applied',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _validatedVendorCode!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  if (_vendor != null)
                                    Text(
                                      'Referred by: ${_vendor!.fullName}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _clearVendorCode,
                              tooltip: 'Remove code',
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Shipping Information
              const Text(
                'Shipping Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'City',
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Zip Code',
                                prefixIcon: Icon(Icons.pin_drop),
                              ),
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Crear orden con vendor_code si existe
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Order Placed!'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Your order has been placed successfully.'),
                              if (_validatedVendorCode != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  '✅ Vendor code applied: $_validatedVendorCode',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.pop(); // Close dialog
                                context.go('/'); // Go home
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Place Order - \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
