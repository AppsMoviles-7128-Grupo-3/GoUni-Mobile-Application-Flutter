import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:gouni_flutter/domain/model/student_reservation.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:gouni_flutter/data/repository/reservation_repository_impl.dart';
import 'package:gouni_flutter/data/remote/api/reservation_api.dart';
import 'package:gouni_flutter/data/remote/api/route_api.dart';
import 'package:gouni_flutter/data/repository/route_repository_impl.dart';
import 'package:gouni_flutter/domain/provider/user_provider.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<StudentReservation> _reservations = [];
  Map<int, domain.Route> _routes = {};
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/'));
      final reservationApi = ReservationApi(dio);
      final reservationRepository = ReservationRepositoryImpl(reservationApi);

      // Obtener reservas del usuario
      final result = await reservationRepository.getReservationsByPassenger(int.parse(user.id));
      
      if (result.isSuccess) {
        final reservations = result.data!;
        
        // Obtener detalles de las rutas
        final routeApi = RouteApi(dio);
        final routeRepository = RouteRepositoryImpl(routeApi);
        final Map<int, domain.Route> routes = {};
        
        for (final reservation in reservations) {
          try {
            final route = await routeRepository.getRouteById(reservation.routeId.toString()).first;
            if (route != null) {
              routes[reservation.routeId] = route;
            }
          } catch (e) {
            print('Error loading route ${reservation.routeId}: $e');
          }
        }

        setState(() {
          _reservations = reservations;
          _routes = routes;
        });
      } else {
        setState(() {
          _error = result.error;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar reservas: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReservations,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_seat,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes reservas aún',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explora viajes disponibles y realiza tu primera reserva',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReservations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reservations.length,
        itemBuilder: (context, index) {
          final reservation = _reservations[index];
          final route = _routes[reservation.routeId];
          
          return _buildReservationCard(reservation, route);
        },
      ),
    );
  }

  Widget _buildReservationCard(StudentReservation reservation, domain.Route? route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reserva #${reservation.id ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(reservation.status.name),
              ],
            ),
            const SizedBox(height: 12),
            if (route != null) ...[
              _buildDetailRow(Icons.location_on, 'Origen', route.start),
              _buildDetailRow(Icons.flag, 'Destino', route.end),
              _buildDetailRow(Icons.access_time, 'Hora', route.departureTime.format(context)),
              _buildDetailRow(Icons.attach_money, 'Precio', 'S/ ${route.price.toStringAsFixed(2)}'),
              _buildDetailRow(Icons.calendar_today, 'Días', route.days.join(', ')),
            ] else
              const Text(
                'Información del viaje no disponible',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'PENDING':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case 'CONFIRMED':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'CANCELLED':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pendiente';
      case 'CONFIRMED':
        return 'Confirmado';
      case 'CANCELLED':
        return 'Cancelado';
      default:
        return status;
    }
  }
}
