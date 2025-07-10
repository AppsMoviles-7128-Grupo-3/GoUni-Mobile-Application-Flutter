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
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialDestination != null) {
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
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _routes = null;
      });
    } finally {
      setState(() {
        _loading = false;
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
            if (_routes != null)
              Expanded(
                child: _routes!.isEmpty
                    ? const Center(child: Text('No hay rutas disponibles.'))
                    : ListView.builder(
                        itemCount: _routes!.length,
                        itemBuilder: (context, index) {
                          final route = _routes![index];
                          return ListTile(
                            title: Text('${route.start} → ${route.end}'),
                            subtitle: Text(
                                'Salida: ${route.departureTime.format(context)} - S/${route.price}'),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/trip-detail',
                                arguments: {'route': route},
                              );
                            },
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