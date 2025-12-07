import 'package:flutter/foundation.dart';
import 'package:conexaship_core/conexaship_core.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategory;

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;

  ProductsProvider() {
    loadProducts();
  }

  Future<void> loadProducts({String? category}) async {
    _isLoading = true;
    _error = null;
    _selectedCategory = category;
    notifyListeners();

    try {
      _products = await _apiService.getProducts(category: category);

      // Mock data if API is not available
      if (_products.isEmpty) {
        _products = _getMockProducts();
      }

      _featuredProducts = _products.where((p) => p.isOnSale).take(10).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Use mock data on error
      _products = _getMockProducts();
      _featuredProducts = _products.where((p) => p.isOnSale).take(10).toList();
      _error = null; // Don't show error, just use mock data
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> getProduct(int id) async {
    try {
      // First try to find in loaded products
      final product = _products.firstWhere(
        (p) => p.id == id,
        orElse: () => Product(name: '', description: '', price: 0, stock: 0),
      );

      if (product.name.isNotEmpty) {
        return product;
      }

      // If not found, try to fetch from API
      return await _apiService.getProduct(id);
    } catch (e) {
      // Return mock product on error
      return _getMockProducts().firstWhere(
        (p) => p.id == id,
        orElse: () => Product(
          id: id,
          name: 'Producto $id',
          description: 'Descripción del producto',
          price: 99.99,
          stock: 10,
          images: ['https://via.placeholder.com/400'],
        ),
      );
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    try {
      return await _apiService.searchProducts(query);
    } catch (e) {
      // Search in loaded products
      return _products
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Mock data for development
  List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        name: 'Laptop HP Pavilion',
        description:
            'Laptop potente para trabajo y entretenimiento. Intel Core i5, 8GB RAM, 256GB SSD.',
        price: 12999.00,
        compareAtPrice: 15999.00,
        stock: 15,
        category: 'Electrónica',
        images: ['https://via.placeholder.com/400x400?text=Laptop'],
        rating: 4.5,
        reviewCount: 128,
      ),
      Product(
        id: 2,
        name: 'iPhone 15 Pro',
        description: 'El último iPhone con chip A17 Pro y cámara increíble.',
        price: 24999.00,
        stock: 25,
        category: 'Celulares',
        images: ['https://via.placeholder.com/400x400?text=iPhone'],
        rating: 4.8,
        reviewCount: 256,
      ),
      Product(
        id: 3,
        name: 'Audífonos Sony WH-1000XM5',
        description: 'Cancelación de ruido líder en la industria.',
        price: 6999.00,
        compareAtPrice: 7999.00,
        stock: 30,
        category: 'Audio',
        images: ['https://via.placeholder.com/400x400?text=Audifonos'],
        rating: 4.7,
        reviewCount: 89,
      ),
      Product(
        id: 4,
        name: 'Smart TV Samsung 55"',
        description: 'TV 4K UHD con tecnología QLED y Smart Hub.',
        price: 14999.00,
        compareAtPrice: 18999.00,
        stock: 12,
        category: 'Electrónica',
        images: ['https://via.placeholder.com/400x400?text=TV'],
        rating: 4.6,
        reviewCount: 167,
      ),
      Product(
        id: 5,
        name: 'PlayStation 5',
        description: 'Consola de nueva generación con SSD ultra rápido.',
        price: 10999.00,
        stock: 8,
        category: 'Videojuegos',
        images: ['https://via.placeholder.com/400x400?text=PS5'],
        rating: 4.9,
        reviewCount: 312,
      ),
    ];
  }
}
