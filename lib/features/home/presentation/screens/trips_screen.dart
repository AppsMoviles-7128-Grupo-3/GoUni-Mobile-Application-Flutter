import 'package:flutter/material.dart';

class Trip {
  final String destination;
  final DateTime date;
  final String status;

  Trip({required this.destination, required this.date, required this.status});
}

class TripsScreen extends StatelessWidget {
  final List<Trip> trips;

  const TripsScreen({super.key, required this.trips});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Viajes')),
      body: trips.isEmpty
          ? const Center(child: Text('No tienes viajes registrados.'))
          : ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text(trip.destination),
                    subtitle: Text(
                      'Fecha: ${trip.date.day}/${trip.date.month}/${trip.date.year}\nEstado: ${trip.status}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}