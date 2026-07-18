import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de detalle de servicios con información completa, ofertas y galería
class ServiceDetailScreen extends StatelessWidget {
  final String serviceType;

  const ServiceDetailScreen({
    Key? key,
    required this.serviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceInfo = _getServiceInfo(serviceType);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen de fondo
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                serviceInfo['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    serviceInfo['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1E3A5F),
                        child: Icon(
                          _getServiceIcon(serviceType),
                          size: 100,
                          color: const Color(0xFF44D7B6),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: const Color(0xFF1E3A5F),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Descripción principal
                Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceInfo['description']!,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Características principales
                      const Text(
                        'Features Included:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        serviceInfo['features'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF44D7B6),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  serviceInfo['features'][index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
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

                // Ofertas especiales
                if (serviceInfo['offers'].isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              color: Color(0xFF44D7B6),
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Special Offers',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(
                          serviceInfo['offers'].length,
                          (index) => _buildOfferCard(
                            serviceInfo['offers'][index],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Precios
                Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Color(0xFF44D7B6),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Pricing',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPricingCard(serviceInfo),
                    ],
                  ),
                ),

                // Vehículos disponibles
                if (serviceInfo['vehicles'].isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              color: Color(0xFF44D7B6),
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Available Vehicles',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(
                          serviceInfo['vehicles'].length,
                          (index) => _buildVehicleCard(
                            serviceInfo['vehicles'][index],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Botón de reserva
                Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/booking?service=$serviceType');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF44D7B6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Book This Service Now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          // Abrir chat o llamada
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Have Questions? Call Us'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, String> offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF44D7B6).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF44D7B6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              offer['discount']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF44D7B6),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer['description']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(Map<String, dynamic> serviceInfo) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF2C5F8D)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceInfo['priceLabel']!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            serviceInfo['price']!,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF44D7B6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            serviceInfo['priceDescription']!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A5F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_car,
              size: 40,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle['capacity']} passengers',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 16,
                      color: index < 5
                          ? const Color(0xFF44D7B6)
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String type) {
    switch (type) {
      case 'point-to-point':
        return Icons.location_on;
      case 'hourly':
        return Icons.access_time;
      case 'airport':
        return Icons.flight;
      case 'weddings':
        return Icons.favorite;
      case 'proms':
        return Icons.celebration;
      case 'tours':
        return Icons.tour;
      default:
        return Icons.local_taxi;
    }
  }

  Map<String, dynamic> _getServiceInfo(String type) {
    switch (type) {
      case 'point-to-point':
        return {
          'title': 'Point to Point Service',
          'image': 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800',
          'description':
              'Get direct, hassle-free transportation from your pickup location to your destination. Perfect for business meetings, doctor appointments, or any occasion where you need reliable point-to-point service.',
          'features': [
            'Door-to-door service with no stops',
            'Professional chauffeurs in business attire',
            'Real-time GPS tracking',
            'Meet & greet service available',
            'Flexible scheduling 24/7',
            'Luxury vehicle options',
            'Complimentary water and WiFi',
          ],
          'offers': [
            {
              'discount': '15%',
              'title': 'First Ride Discount',
              'description': 'New customers get 15% off their first booking',
            },
            {
              'discount': '20%',
              'title': 'Round Trip Savings',
              'description': 'Book round trip and save 20% on return journey',
            },
          ],
          'priceLabel': 'Starting from',
          'price': '\$65',
          'priceDescription':
              'Base price includes first 30 minutes. Additional charges apply for distance and wait time. Final price shown before booking.',
          'vehicles': [
            {'name': 'Luxury Sedan', 'capacity': '3'},
            {'name': 'Premium SUV', 'capacity': '6'},
            {'name': 'Executive Van', 'capacity': '10'},
          ],
        };

      case 'hourly':
        return {
          'title': 'Hourly Chauffeur Service',
          'image': 'https://images.unsplash.com/photo-1464219789935-c2d9d9aba644?w=800',
          'description':
              'Book a dedicated chauffeur for multiple stops or extended periods. Ideal for business days, shopping trips, or tourist excursions where you need flexible transportation.',
          'features': [
            'Minimum 3 hours booking',
            'Multiple stops included',
            'Vehicle waits at each location',
            'Flexible itinerary changes',
            'Experienced local drivers',
            'Premium vehicle selection',
            'Complimentary refreshments',
          ],
          'offers': [
            {
              'discount': '10%',
              'title': 'Full Day Special',
              'description': 'Book 8+ hours and get 10% off total price',
            },
            {
              'discount': '25%',
              'title': 'Weekly Package',
              'description': 'Subscribe to weekly service and save 25%',
            },
          ],
          'priceLabel': 'Hourly rate',
          'price': '\$75/hr',
          'priceDescription':
              'Minimum 3 hours required. Includes fuel, tolls, and parking. Overtime charged at same hourly rate.',
          'vehicles': [
            {'name': 'Business Sedan', 'capacity': '3'},
            {'name': 'Luxury SUV', 'capacity': '6'},
            {'name': 'Sprinter Van', 'capacity': '12'},
          ],
        };

      case 'airport':
        return {
          'title': 'Airport Transfer Service',
          'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800',
          'description':
              'Stress-free airport transportation with flight monitoring, meet & greet service, and luggage assistance. We track your flight to ensure timely pickup even if your flight is delayed.',
          'features': [
            'Flight tracking included',
            'Meet & greet at arrivals',
            'Luggage assistance',
            '60 minutes free wait time',
            'All tolls and fees included',
            'Child seats available',
            'Early morning pickups available',
          ],
          'offers': [
            {
              'discount': '10%',
              'title': 'Round Trip Airport',
              'description': 'Book both ways and save 10%',
            },
            {
              'discount': '30%',
              'title': 'Group Discount',
              'description': '4+ passengers get 30% off van service',
            },
          ],
          'priceLabel': 'Flat rate from',
          'price': '\$85',
          'priceDescription':
              'Fixed price to/from airport. No surge pricing or hidden fees. Price varies by distance from airport.',
          'vehicles': [
            {'name': 'Premium Sedan', 'capacity': '3'},
            {'name': 'SUV', 'capacity': '6'},
            {'name': 'Executive Van', 'capacity': '10'},
          ],
        };

      case 'weddings':
        return {
          'title': 'Wedding Transportation',
          'image': 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
          'description':
              'Make your special day unforgettable with our luxury wedding transportation. From elegant getaway cars to full bridal party shuttles, we ensure everyone arrives in style and on time.',
          'features': [
            'Red carpet service',
            'Champagne service included',
            'Decorated vehicles available',
            'Professional wedding chauffeurs',
            'Flexible timing for photos',
            'Guest shuttle service',
            'Wedding planner coordination',
          ],
          'offers': [
            {
              'discount': '15%',
              'title': 'Wedding Package',
              'description': 'Book 3+ vehicles and save 15%',
            },
            {
              'discount': 'FREE',
              'title': 'Rehearsal Ride',
              'description': 'Free rehearsal dinner transport with package',
            },
          ],
          'priceLabel': 'Packages from',
          'price': '\$450',
          'priceDescription':
              'Customized wedding packages available. Includes decorated vehicle, champagne, and up to 8 hours of service.',
          'vehicles': [
            {'name': 'Luxury Sedan', 'capacity': '3'},
            {'name': 'Stretch Limousine', 'capacity': '8'},
            {'name': 'Party Bus', 'capacity': '20'},
          ],
        };

      case 'proms':
        return {
          'title': 'Prom & Special Events',
          'image': 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=800',
          'description':
              'Arrive at your prom or special event in style and safety. Our experienced chauffeurs ensure a memorable night with professional service parents can trust.',
          'features': [
            'Safe, professional drivers',
            'Parent tracking available',
            'Group packages available',
            'Red carpet entry',
            'Photo opportunities',
            'No alcohol policy enforced',
            'On-time guarantee',
          ],
          'offers': [
            {
              'discount': '20%',
              'title': 'Early Bird Special',
              'description': 'Book 2 months early and save 20%',
            },
            {
              'discount': '25%',
              'title': 'Group Rate',
              'description': 'Groups of 6+ get 25% discount',
            },
          ],
          'priceLabel': 'Packages from',
          'price': '\$350',
          'priceDescription':
              'All-inclusive prom packages. Includes pre-event, event, and post-event transportation with professional chauffeur.',
          'vehicles': [
            {'name': 'Luxury SUV', 'capacity': '6'},
            {'name': 'Stretch Limo', 'capacity': '10'},
            {'name': 'Party Bus', 'capacity': '20'},
          ],
        };

      case 'tours':
        return {
          'title': 'City Tours & Sightseeing',
          'image': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=800',
          'description':
              'Explore the city in luxury with a knowledgeable chauffeur who knows every corner. Customized tours or popular sightseeing routes available.',
          'features': [
            'Expert local guides',
            'Customizable itineraries',
            'Popular landmarks included',
            'Photo stop opportunities',
            'Commentary in multiple languages',
            'Food tour options',
            'Historical site access',
          ],
          'offers': [
            {
              'discount': '15%',
              'title': 'Half Day Tour',
              'description': '4-hour city tour at discounted rate',
            },
            {
              'discount': '30%',
              'title': 'Multi-Day Package',
              'description': 'Book 3+ days and save 30%',
            },
          ],
          'priceLabel': 'Tour packages from',
          'price': '\$200',
          'priceDescription':
              'Includes 4-hour guided tour, all entrance fees, and refreshments. Custom tours priced individually.',
          'vehicles': [
            {'name': 'Luxury Sedan', 'capacity': '3'},
            {'name': 'Premium SUV', 'capacity': '6'},
            {'name': 'Tour Van', 'capacity': '12'},
          ],
        };

      default:
        return {
          'title': 'Our Service',
          'image': '',
          'description': 'Premium transportation service.',
          'features': [],
          'offers': [],
          'priceLabel': 'Contact for pricing',
          'price': 'Custom',
          'priceDescription': 'Contact us for a custom quote.',
          'vehicles': [],
        };
    }
  }
}
