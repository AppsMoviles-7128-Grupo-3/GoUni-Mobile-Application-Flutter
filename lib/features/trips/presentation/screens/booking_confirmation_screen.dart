import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/widgets/custom_button.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:gouni_flutter/domain/model/student_reservation.dart';
import 'package:gouni_flutter/data/repository/reservation_repository_impl.dart';
import 'package:gouni_flutter/data/remote/api/reservation_api.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:gouni_flutter/domain/provider/user_provider.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final domain.Route route;
  
  const BookingConfirmationScreen({super.key, required this.route});
  
  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  int _passengers = 1;
  bool _acceptConditions = false;
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar reserva')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripSummary(),
            const SizedBox(height: 20),
            _buildPassengerSelector(),
            const SizedBox(height: 20),
            _buildTermsAndConditions(),
            const SizedBox(height: 30),
            _buildConfirmButton(user),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTripSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del viaje',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.location_on, 'Origen', widget.route.start),
            _buildDetailRow(Icons.flag, 'Destino', widget.route.end),
            _buildDetailRow(Icons.access_time, 'Hora', widget.route.departureTime.format(context)),
            _buildDetailRow(Icons.attach_money, 'Precio por asiento', 'S/ ${widget.route.price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  
  Widget _buildPassengerSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Número de pasajeros',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _passengers > 1 ? () => setState(() => _passengers--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$_passengers',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _passengers < widget.route.availableSeats 
                    ? () => setState(() => _passengers++) 
                    : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            Text(
              'Total: S/ ${(widget.route.price * _passengers).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _acceptConditions,
          onChanged: (value) => setState(() => _acceptConditions = value ?? false),
        ),
        const Expanded(
          child: Text(
            'Acepto los términos y condiciones del servicio',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
  
  Widget _buildConfirmButton(user) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: _isLoading ? 'Procesando...' : 'Confirmar reserva',
        onPressed: _acceptConditions && !_isLoading && user != null 
          ? () => _confirmBooking(user.id) 
          : null,
      ),
    );
  }
  
  Future<void> _confirmBooking(String userId) async {
    setState(() => _isLoading = true);
    
    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));
      final reservationApi = ReservationApi(dio);
      final repository = ReservationRepositoryImpl(reservationApi);
      
      // Crear una reserva por cada pasajero
      for (int i = 0; i < _passengers; i++) {
        final reservation = StudentReservation(
          routeId: widget.route.id,
          driverId: widget.route.userId,
          passengerId: int.parse(userId),
        );
        
        final result = await repository.createReservation(reservation);
        
        if (result.isFailure) {
          throw Exception(result.error);
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Reserva confirmada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Volver a la pantalla anterior
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al confirmar reserva: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}