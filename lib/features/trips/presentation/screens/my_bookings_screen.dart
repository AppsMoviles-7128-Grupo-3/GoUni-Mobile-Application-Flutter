import 'package:flutter/material.dart';

// Modelo simple de reserva
class Booking {
  final String title;
  final DateTime date;
  final String status;

  Booking({
    required this.title,
    required this.date,
    required this.status,
  });
}

class MyBookingScreen extends StatelessWidget {
  // Lista simulada de reservas (puedes reemplazarla por datos reales)
  final List<Booking> bookings;

  const MyBookingScreen({
    super.key,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Reservas')),
      body: bookings.isEmpty
          ? const Center(child: Text('No tienes reservas registradas.'))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(booking.title),
                    subtitle: Text(
                      'Fecha: ${booking.date.day}/${booking.date.month}/${booking.date.year}\nEstado: ${booking.status}',
                    ),
                    onTap: () {
                      // Aquí puedes navegar a una pantalla de detalle si lo deseas
                    },
                  ),
                );
              },
            ),
    );
  }
}