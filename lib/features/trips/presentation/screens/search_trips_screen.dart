import 'package:flutter/material.dart';
import 'package:gouni_flutter/data/remote/api/route_api.dart';
import 'package:gouni_flutter/data/repository/route_repository_impl.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:dio/dio.dart';

class SearchTripsScreen extends StatefulWidget {
  const SearchTripsScreen({super.key, this.initialDestination});
  final String? initialDestination;

  @override
  State<SearchTripsScreen> createState() => _SearchTripsScreenState();
}

class _SearchTripsScreenState extends State<SearchTripsScreen> {
  List<domain.Route>? _routes;
  List<domain.Route>? _filteredRoutes;
  bool _loading = false;
  String? _error;

  String? _selectedDay;
  TimeOfDay? _selectedTime;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _daysOfWeek = [
    'LUNES',
    'MARTES',
    'MIERCOLES',
    'JUEVES',
    'VIERNES',
    'SABADO',
    'DOMINGO',
  ];

  final Map<String, String> _daysMap = {
    'LUNES': 'MONDAY',
    'MARTES': 'TUESDAY',
    'MIERCOLES': 'WEDNESDAY',
    'JUEVES': 'THURSDAY',
    'VIERNES': 'FRIDAY',
    'SABADO': 'SATURDAY',
    'DOMINGO': 'SUNDAY',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialDestination != null) {
      // Si quieres usar el destino inicial para filtrar, puedes hacerlo aquí
    }
  }

  Future<void> _fetchRoutes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));
      final api = RouteApi(dio);
      final repo = RouteRepositoryImpl(api);
      final routes = await repo.getAllRoutes();
      setState(() {
        _routes = routes;
        _applyFilters();
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _routes = null;
        _filteredRoutes = null;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    if (_routes == null) return;
    List<domain.Route> filtered = _routes!;
    if (_selectedDay != null) {
      // Si usas el mapa, filtra así:
      final backendDay = _daysMap[_selectedDay!] ?? _selectedDay!;
      filtered = filtered
          .where((route) => route.days.contains(backendDay))
          .toList();
    }
    if (_selectedTime != null) {
      filtered = filtered.where((route) {
        final dep = route.departureTime;
        return dep.hour == _selectedTime!.hour;
      }).toList();
    }
    if (_searchText.isNotEmpty) {
      filtered = filtered
          .where(
            (route) =>
                route.start.toLowerCase().contains(_searchText.toLowerCase()) ||
                route.end.toLowerCase().contains(_searchText.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      _filteredRoutes = filtered;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar viajes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por origen o destino',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchText = value;
                _applyFilters();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDay,
                    hint: const Text('Día'),
                    items: _daysMap.keys.map((dayEs) {
                      return DropdownMenuItem(
                        value: dayEs,
                        child: Text(
                          dayEs[0] + dayEs.substring(1).toLowerCase(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDay = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Hora',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedTime != null
                                ? _selectedTime!.format(context)
                                : 'Seleccionar hora',
                          ),
                          const Icon(Icons.access_time),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _fetchRoutes,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Buscar viajes'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_filteredRoutes != null)
              Expanded(
                child: _filteredRoutes!.isEmpty
                    ? const Center(child: Text('No hay rutas disponibles.'))
                    : ListView.builder(
                        itemCount: _filteredRoutes!.length,
                        itemBuilder: (context, index) {
                          final route = _filteredRoutes![index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/trip-detail',
                                  arguments: route,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Ruta principal
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${route.start} → ${route.end}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Información adicional
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Salida: ${route.departureTime.format(context)}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          Icons.event_seat,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${route.availableSeats} asientos',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Precio y botón de reserva
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'S/ ${route.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/trip-detail',
                                              arguments: route,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.book_online,
                                            size: 16,
                                          ),
                                          label: const Text('Reservar'),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
