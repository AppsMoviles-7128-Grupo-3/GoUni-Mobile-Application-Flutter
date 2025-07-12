import 'package:flutter/material.dart';
import 'package:gouni_flutter/domain/provider/booking_provider.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:provider/provider.dart';

class BookingTestHelper {
  static void addSampleBookings(BookingProvider bookingProvider) {
    final sampleRoutes = [
      domain.Route(
        id: 1,
        userId: 1,
        carId: 1,
        start: 'San Miguel',
        end: 'UPC Villa',
        days: ['MONDAY', 'WEDNESDAY', 'FRIDAY'],
        departureTime: const TimeOfDay(hour: 7, minute: 30),
        arrivalTime: const TimeOfDay(hour: 8, minute: 15),
        availableSeats: 3,
        price: 12.50,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      domain.Route(
        id: 2,
        userId: 2,
        carId: 2,
        start: 'Monterrico',
        end: 'UPC San Miguel',
        days: ['TUESDAY', 'THURSDAY'],
        departureTime: const TimeOfDay(hour: 8, minute: 0),
        arrivalTime: const TimeOfDay(hour: 8, minute: 45),
        availableSeats: 2,
        price: 15.00,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      domain.Route(
        id: 3,
        userId: 3,
        carId: 3,
        start: 'La Molina',
        end: 'USIL',
        days: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
        departureTime: const TimeOfDay(hour: 7, minute: 0),
        arrivalTime: const TimeOfDay(hour: 7, minute: 30),
        availableSeats: 4,
        price: 8.00,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final sampleBookings = [
      BookingItem(
        id: '1',
        route: sampleRoutes[0],
        passengers: 1,
        bookingDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Confirmada',
        meetingPlace: 'Frente al Metro San Miguel',
      ),
      BookingItem(
        id: '2',
        route: sampleRoutes[1],
        passengers: 2,
        bookingDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Confirmada',
        meetingPlace: 'Estación del Metropolitano',
      ),
      BookingItem(
        id: '3',
        route: sampleRoutes[2],
        passengers: 1,
        bookingDate: DateTime.now().subtract(const Duration(hours: 3)),
        status: 'Pendiente',
      ),
    ];

    for (final booking in sampleBookings) {
      bookingProvider.addBooking(booking);
    }
  }
}

class BookingTestScreen extends StatelessWidget {
  const BookingTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Reservas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Utiliza este botón para agregar reservas de prueba',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final bookingProvider = Provider.of<BookingProvider>(
                  context,
                  listen: false,
                );
                BookingTestHelper.addSampleBookings(bookingProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reservas de prueba agregadas exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Agregar Reservas de Prueba'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final bookingProvider = Provider.of<BookingProvider>(
                  context,
                  listen: false,
                );
                bookingProvider.clearBookings();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todas las reservas han sido eliminadas'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Limpiar Reservas'),
            ),
          ],
        ),
      ),
    );
  }
}
