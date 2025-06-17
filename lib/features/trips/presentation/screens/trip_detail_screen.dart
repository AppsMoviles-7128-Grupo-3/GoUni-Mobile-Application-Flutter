import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';
import 'package:gouni_flutter/core/widgets/custom_button.dart';
import 'package:gouni_flutter/features/trips/presentation/screens/booking_confirmation_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final Map<String, dynamic> tripData;

  const TripDetailScreen({super.key, required this.tripData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del viaje')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDriverInfo(),
            _buildTripDetails(),
            _buildTripDescription(),
            _buildBookingButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/driver_placeholder.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tripData['driver'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        tripData['rating'].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.directions_car, size: 20),
                      const SizedBox(width: 5),
                      const Text('Placa:'),
                      const SizedBox(width: 5),
                      Text(
                        'A1B-234',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                // Implementar chat
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetails() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Punto de encuentro',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 34, top: 5, bottom: 15),
              child: Text('Av. La Marina 2810, San Miguel'),
            ),
            const Row(
              children: [
                Icon(Icons.flag, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'Destino',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 34, top: 5, bottom: 15),
              child: Text(tripData['destination'] as String),
            ),
            const Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 10),
                Text(
                  'Hora de salida',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 34, top: 5, bottom: 15),
              child: Text(tripData['time'] as String),
            ),
            const Row(
              children: [
                Icon(Icons.attach_money),
                SizedBox(width: 10),
                Text(
                  'Precio por asiento',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 34, top: 5),
              child: Text(
                tripData['price'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción del viaje',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Viaje directo desde San Miguel hasta el campus de la UPC. '
            'El conductor tiene buena reputación y puntualidad. '
            'El vehículo es un Toyota Corolla 2020 con aire acondicionado.',
          ),
          const SizedBox(height: 20),
          const Text(
            'Comentarios',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildComment(
            'Juan Pérez',
            'Excelente conductor, muy puntual y el auto muy cómodo.',
            5,
          ),
          _buildComment(
            'Ana Gómez',
            'Buen viaje, aunque hubo un poco de tráfico.',
            4,
          ),
        ],
      ),
    );
  }

  Widget _buildComment(String name, String comment, int rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('assets/images/user_placeholder.png'),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(rating.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(comment),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomButton(
        text: 'Reservar asiento',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingConfirmationScreen(tripData: tripData),
            ),
          );
        },
      ),
    );
  }
}