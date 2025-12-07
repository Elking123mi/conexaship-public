import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conexaship_core/conexaship_core.dart';

/// Dashboard principal para vendedores
class VendorDashboardScreen extends StatefulWidget {
  final Vendor vendor;

  const VendorDashboardScreen({super.key, required this.vendor});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  VendorStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implementar GET /api/v1/vendors/me/stats
      /*
      final stats = await _apiService.getVendorStats();
      setState(() => _stats = stats);
      */
    } catch (e) {
      _showError('Error loading stats: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _copyVendorCode() {
    Clipboard.setData(ClipboardData(text: widget.vendor.vendorCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vendor code copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareVendorCode() {
    // TODO: Implementar compartir con share_plus package
    final message = 'Use my code ${widget.vendor.vendorCode} when shopping at ConexaShip!';
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied! Share it with your friends')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Logout y volver a login
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  _buildHeaderCard(vendor),
                  const SizedBox(height: 16),

                  // Vendor Code Card
                  _buildVendorCodeCard(vendor),
                  const SizedBox(height: 16),

                  // Stats Cards
                  _buildStatsGrid(vendor),
                  const SizedBox(height: 16),

                  // Commission Level Progress
                  _buildLevelProgress(vendor),
                  const SizedBox(height: 16),

                  // Quick Actions
                  _buildQuickActions(),
                  const SizedBox(height: 16),

                  // Recent Sales
                  _buildRecentSales(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard(Vendor vendor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                vendor.fullName[0].toUpperCase(),
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.fullName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vendor.email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        vendor.levelEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(int.parse(vendor.levelColor.substring(1), radix: 16) + 0xFF000000),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          vendor.commissionLevel.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${vendor.commissionRate.toStringAsFixed(0)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCodeCard(Vendor vendor) {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Unique Vendor Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      vendor.vendorCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyVendorCode,
                    tooltip: 'Copy code',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareVendorCode,
                    icon: const Icon(Icons.share),
                    label: const Text('Share Code'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(Vendor vendor) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Sales',
          vendor.totalSales.toString(),
          Icons.shopping_cart,
          Colors.blue,
        ),
        _buildStatCard(
          'Revenue Generated',
          '\$${vendor.totalRevenue.toStringAsFixed(2)}',
          Icons.attach_money,
          Colors.green,
        ),
        _buildStatCard(
          'Total Commission',
          '\$${vendor.totalCommission.toStringAsFixed(2)}',
          Icons.account_balance_wallet,
          Colors.orange,
        ),
        _buildStatCard(
          'This Month',
          '\$${(_stats?.commissionThisMonth ?? 0).toStringAsFixed(2)}',
          Icons.calendar_today,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelProgress(Vendor vendor) {
    if (vendor.nextLevel == null) {
      return Card(
        color: Colors.amber.shade50,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.emoji_events, size: 40, color: Colors.amber),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Congratulations! 🎉',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You\'ve reached the highest level (Platinum)',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final salesToNext = vendor.salesToNextLevel;
    final progress = salesToNext > 0 ? (vendor.totalSales / (vendor.totalSales + salesToNext)) : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Level Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 12),
            Text(
              'Next: ${vendor.nextLevel}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '$salesToNext more sales to level up!',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navegar a historial de ventas
                },
                icon: const Icon(Icons.history),
                label: const Text('My Sales'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navegar a productos
                },
                icon: const Icon(Icons.inventory),
                label: const Text('Products'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Sales',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // TODO: Cargar y mostrar ventas recientes
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                'No recent sales',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
