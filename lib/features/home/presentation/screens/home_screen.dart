import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';
import 'package:gouni_flutter/features/trips/presentation/screens/search_trips_screen.dart';
import 'package:gouni_flutter/features/home/presentation/screens/profile_screen.dart';
import 'package:gouni_flutter/features/trips/presentation/screens/my_bookings_screen_new.dart';
import 'package:gouni_flutter/domain/provider/booking_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContentScreen(),
    const SearchTripsScreen(),
    const MyBookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Buscar',
              ),
              BottomNavigationBarItem(
                icon: _buildBookingIcon(bookingProvider.bookings.length),
                label: 'Mis viajes',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingIcon(int bookingCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.directions_car),
        if (bookingCount > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '$bookingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              '¡Hola, Estudiante!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Encuentra tu próximo viaje compartido',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildQuickStats(context),
            const SizedBox(height: 30),
            _buildSearchCard(context),
            const SizedBox(height: 30),
            const Text(
              'Destinos más visitados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildPopularDestinations(context),
            const SizedBox(height: 30),
            const Text(
              '¿Por qué usar GoUni?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildFeaturesGrid(),
            const SizedBox(height: 20),
            // Botón temporal para pruebas
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/booking-test');
              },
              icon: const Icon(Icons.bug_report),
              label: const Text('Pruebas de Reservas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final bookingCount = bookingProvider.bookings.length;
        final confirmedBookings = bookingProvider.bookings
            .where((b) => b.status == 'Confirmada')
            .length;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.book_online,
                  label: 'Reservas',
                  value: '$bookingCount',
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.check_circle,
                  label: 'Confirmadas',
                  value: '$confirmedBookings',
                  color: Colors.green,
                ),
                _buildStatItem(
                  icon: Icons.savings,
                  label: 'Ahorrado',
                  value: 'S/ ${_calculateSavings(bookingProvider.bookings)}',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String _calculateSavings(List<BookingItem> bookings) {
    // Simulamos un ahorro del 30% comparado con taxi
    final totalSpent = bookings.fold<double>(
      0,
      (sum, booking) => sum + (booking.route.price * booking.passengers),
    );
    final estimatedSavings = totalSpent * 0.3;
    return estimatedSavings.toStringAsFixed(0);
  }

  Widget _buildSearchCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchTripsScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 30),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buscar viaje',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Encuentra compañeros de viaje',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularDestinations(BuildContext context) {
    final destinations = [
      {'name': 'San Miguel - UPC', 'rating': 4.5},
      {'name': 'Monterrico - UPC', 'rating': 4.3},
      {'name': 'USIL - La Molina', 'rating': 4.2},
    ];

    return Column(
      children: destinations.map((dest) {
        return ListTile(
          leading: const Icon(Icons.location_on, color: AppColors.primary),
          title: Text(dest['name'] as String),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              Text(dest['rating'].toString()),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchTripsScreen(
                  initialDestination: dest['name'] as String,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildFeaturesGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _buildFeatureItem(Icons.security, 'Seguridad garantizada'),
        _buildFeatureItem(Icons.people, 'Comunidad estudiantil'),
        _buildFeatureItem(Icons.eco, 'Eco-friendly'),
        _buildFeatureItem(Icons.savings, 'Ahorro económico'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
