import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';
import 'package:gouni_flutter/domain/provider/booking_provider.dart';
import 'package:gouni_flutter/domain/provider/user_provider.dart';
import 'package:provider/provider.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar reservas del backend al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    if (userProvider.user != null) {
      await bookingProvider.loadBookingsFromBackend(userProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookings,
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (bookingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar reservas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bookingProvider.error!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBookings,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final bookings = bookingProvider.bookings;

          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes reservas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cuando reserves un viaje, aparecerá aquí',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showBookingDetails(context, booking),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado con ruta
                        Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${booking.route.start} → ${booking.route.end}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildStatusChip(booking.status),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Información del viaje
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              booking.route.departureTime.format(context),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.people,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${booking.passengers} pasajero${booking.passengers > 1 ? 's' : ''}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Fecha de reserva y precio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reservado: ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'S/ ${(booking.route.price * booking.passengers).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),

                        // Lugar de encuentro (si existe)
                        if (booking.meetingPlace != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Encuentro: ${booking.meetingPlace}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmada':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'pendiente':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case 'cancelada':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context, BookingItem booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Título
                Text(
                  'Detalles de la reserva',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Información del viaje
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información del viaje',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          Icons.location_on,
                          'Origen',
                          booking.route.start,
                        ),
                        _buildDetailRow(
                          Icons.flag,
                          'Destino',
                          booking.route.end,
                        ),
                        _buildDetailRow(
                          Icons.access_time,
                          'Hora de salida',
                          booking.route.departureTime.format(context),
                        ),
                        _buildDetailRow(
                          Icons.people,
                          'Pasajeros',
                          '${booking.passengers}',
                        ),
                        _buildDetailRow(
                          Icons.attach_money,
                          'Precio total',
                          'S/ ${(booking.route.price * booking.passengers).toStringAsFixed(2)}',
                        ),
                        if (booking.meetingPlace != null)
                          _buildDetailRow(
                            Icons.location_on,
                            'Lugar de encuentro',
                            booking.meetingPlace!,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Información de la reserva
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información de la reserva',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          Icons.confirmation_number,
                          'ID de reserva',
                          booking.id,
                        ),
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Fecha de reserva',
                          '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Estado: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            _buildStatusChip(booking.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Aquí puedes agregar funcionalidad para contactar al conductor
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Funcionalidad de contacto próximamente',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Contactar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: booking.status.toLowerCase() == 'confirmada'
                            ? () {
                                _showCancelConfirmation(context, booking);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, BookingItem booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: const Text(
          '¿Estás seguro de que quieres cancelar esta reserva?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Actualizar estado de la reserva
              Provider.of<BookingProvider>(
                context,
                listen: false,
              ).updateBookingStatus(booking.id, 'Cancelada');

              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Cerrar bottom sheet

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reserva cancelada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
}
