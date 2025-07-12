import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';
import 'package:gouni_flutter/core/widgets/custom_button.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:gouni_flutter/domain/provider/booking_provider.dart';
import 'package:gouni_flutter/domain/provider/user_provider.dart';
import 'package:provider/provider.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const BookingConfirmationScreen({super.key, required this.tripData});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  int _passengers = 1;
  bool _acceptConditions = false;
  final TextEditingController _meetingPlaceController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _meetingPlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.tripData['route'] as domain.Route;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar reserva'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del viaje
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles del viaje',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.location_on, 'Origen', route.start),
                    _buildDetailRow(Icons.flag, 'Destino', route.end),
                    _buildDetailRow(
                      Icons.access_time,
                      'Hora',
                      route.departureTime.format(context),
                    ),
                    _buildDetailRow(
                      Icons.attach_money,
                      'Precio por asiento',
                      'S/ ${route.price.toStringAsFixed(2)}',
                    ),
                    _buildDetailRow(
                      Icons.event_seat,
                      'Asientos disponibles',
                      '${route.availableSeats}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Número de pasajeros
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Número de pasajeros',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _passengers > 1
                              ? () => setState(() => _passengers--)
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$_passengers',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _passengers < route.availableSeats
                              ? () => setState(() => _passengers++)
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lugar de encuentro
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lugar de encuentro (opcional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _meetingPlaceController,
                      decoration: const InputDecoration(
                        hintText: 'Ej: Frente a la estación del metro',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Costo total
            Card(
              color: AppColors.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total a pagar:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'S/ ${(route.price * _passengers).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Términos y condiciones
            CheckboxListTile(
              value: _acceptConditions,
              onChanged: (value) =>
                  setState(() => _acceptConditions = value ?? false),
              title: const Text('Acepto los términos y condiciones'),
              subtitle: const Text(
                'Al reservar, acepto las políticas de cancelación y reembolso',
              ),
            ),
            const SizedBox(height: 24),

            // Botón de confirmación
            CustomButton(
              text: 'Confirmar reserva',
              onPressed: _acceptConditions && !_isLoading
                  ? _confirmBooking
                  : null,
              isLoading: _isLoading,
            ),
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
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmBooking() async {
    setState(() => _isLoading = true);

    try {
      final route = widget.tripData['route'] as domain.Route;
      final bookingProvider = Provider.of<BookingProvider>(
        context,
        listen: false,
      );

      // Crear la reserva
      final booking = BookingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        route: route,
        passengers: _passengers,
        bookingDate: DateTime.now(),
        status: 'Confirmada',
        meetingPlace: _meetingPlaceController.text.trim().isEmpty
            ? null
            : _meetingPlaceController.text.trim(),
      );

      // Agregar la reserva al provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Intentar crear la reserva en el backend
      if (userProvider.user != null) {
        await bookingProvider.createBookingInBackend(booking, userProvider.user!.id);
      } else {
        // Fallback: agregar solo localmente si no hay usuario
        bookingProvider.addBooking(booking);
      }

      // Simular delay de procesamiento
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Mostrar confirmación
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('¡Reserva confirmada!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 16),
                Text(
                  'Tu reserva para $_passengers pasajero(s) ha sido confirmada exitosamente.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total pagado: S/ ${(route.price * _passengers).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar diálogo
                  Navigator.pop(context); // Volver a detalles
                  Navigator.pop(context); // Volver a búsqueda

                  // Navegar a "Mis Reservas" en la pantalla principal
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );

                  // Cambiar a la pestaña de "Mis Reservas"
                  Future.delayed(const Duration(milliseconds: 300), () {
                    // Aquí podríamos emitir un evento para cambiar la pestaña
                    // Por simplicidad, mostramos un mensaje
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Puedes ver tu reserva en la pestaña "Mis Viajes"',
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  });
                },
                child: const Text('Ver mis reservas'),
              ),
            ],
          ),
        );
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
