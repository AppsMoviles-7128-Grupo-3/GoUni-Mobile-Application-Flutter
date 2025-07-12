import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/constants/app_colors.dart';
import 'package:gouni_flutter/core/widgets/custom_button.dart';
import 'package:gouni_flutter/features/trips/presentation/screens/booking_confirmation_screen.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gouni_flutter/data/remote/api/car_api.dart';
import 'package:gouni_flutter/data/mapper/car_mapper.dart';
import 'package:gouni_flutter/domain/model/car.dart';
import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/api/user_api.dart';
import 'package:gouni_flutter/domain/model/user.dart';

class TripDetailScreen extends StatefulWidget {
  final domain.Route route;
  const TripDetailScreen({super.key, required this.route});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  Car? _car;
  bool _loadingCar = true;
  String? _driverName;
  bool _loadingDriver = true;

  @override
  void initState() {
    super.initState();
    _fetchCar();
    _fetchDriverName();
  }

  Future<void> _fetchCar() async {
    final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));
    final carApi = CarApi(dio);
    final carDto = await carApi.getCarById(widget.route.carId);
    setState(() {
      _car = carDto.toDomain();
      _loadingCar = false;
    });
  }

  Future<void> _fetchDriverName() async {
    final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));
    final userApi = UserApi(dio);
    try {
      final user = await userApi.getById(widget.route.userId);
      setState(() {
        _driverName = user.name;
        _loadingDriver = false;
      });
    } catch (e) {
      setState(() {
        _driverName = 'Desconocido';
        _loadingDriver = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del viaje')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDriverInfo(),
            _buildTripDetails(context),
            _buildMapSection(),
            _buildTripDescription(),
            _buildBookingButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    // Puedes obtener el nombre del conductor desde otro modelo si lo tienes
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
                    'Conductor: ${_loadingDriver ? "Cargando..." : (_driverName ?? "Desconocido")}',
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
                      const Text('4.8'), // Rating simulado
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
                        _loadingCar
                          ? 'Cargando...'
                          : (_car?.licensePlate ?? 'Sin placa'),
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

  Widget _buildTripDetails(BuildContext context) {
    // Mapa de traducción de días
    final Map<String, String> daysMap = {
      'MONDAY': 'Lunes',
      'TUESDAY': 'Martes',
      'WEDNESDAY': 'Miércoles',
      'THURSDAY': 'Jueves',
      'FRIDAY': 'Viernes',
      'SATURDAY': 'Sábado',
      'SUNDAY': 'Domingo',
    };

    // Traduce y formatea los días
    String daysEs = widget.route.days
        .map((d) => daysMap[d.toUpperCase()] ?? d)
        .map((d) => d[0].toUpperCase() + d.substring(1).toLowerCase())
        .join(', ');

    Widget detailRow(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            detailRow(Icons.location_on, 'Origen', widget.route.start),
            detailRow(Icons.flag, 'Destino', widget.route.end),
            detailRow(Icons.calendar_today, 'Días', daysEs),
            detailRow(Icons.access_time, 'Hora de salida', widget.route.departureTime.format(context)),
            detailRow(Icons.attach_money, 'Precio por asiento', 'S/ ${widget.route.price.toStringAsFixed(2)}'),
            detailRow(Icons.event_seat, 'Asientos disponibles', '${widget.route.availableSeats}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    // Coordenadas de ejemplo, reemplaza por las reales si las tienes en tu modelo
    final LatLng start = const LatLng(-12.0921, -77.0465); // San Miguel
    final LatLng end = const LatLng(-12.1057, -76.9634);   // Monterrico

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: start,
            zoom: 12,
          ),
          markers: {
            Marker(markerId: const MarkerId('start'), position: start, infoWindow: const InfoWindow(title: 'Partida')),
            Marker(markerId: const MarkerId('end'), position: end, infoWindow: const InfoWindow(title: 'Destino')),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              color: Colors.blue,
              width: 4,
              points: [start, end],
            ),
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
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
            'Viaje directo. El conductor tiene buena reputación y puntualidad.',
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
              builder: (context) => BookingConfirmationScreen(route: widget.route),
            ),
          );
        },
      ),
    );
  }
}