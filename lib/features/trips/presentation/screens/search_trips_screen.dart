import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/widgets/custom_button.dart';
import 'package:gouni_flutter/features/trips/presentation/screens/trip_detail_screen.dart';

class SearchTripsScreen extends StatefulWidget {
  final String? initialDestination;

  const SearchTripsScreen({super.key, this.initialDestination});

  @override
  State<SearchTripsScreen> createState() => _SearchTripsScreenState();
}

class _SearchTripsScreenState extends State<SearchTripsScreen> {
  final _destinationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialDestination != null) {
      _destinationController.text = widget.initialDestination!;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar viaje'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildFiltersBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: '¿A dónde deseas ir?',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Seleccionar fecha',
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hora',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
              const SizedBox(height: 30),
              CustomButton(
                text: 'Buscar viajes',
                onPressed: () {
                  // Implementar búsqueda
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailScreen(tripData: {
                        'driver': _destinationController.text,
                        'destination': _destinationController.text,
                        'time': _selectedTime != null ? _selectedTime!.format(context) : '',
                        'price': '',
                        'rating': 0.0,
                        'seats': 0,
                      }),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Viajes disponibles recientemente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildRecentTripsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Filtrar viajes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tipo de vehículo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 10,
            children: [
              FilterChip(
                label: const Text('Sedán'),
                selected: false,
                onSelected: (bool value) {},
              ),
              FilterChip(
                label: const Text('SUV'),
                selected: false,
                onSelected: (bool value) {},
              ),
              FilterChip(
                label: const Text('Hatchback'),
                selected: false,
                onSelected: (bool value) {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Precio máximo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Slider(
            value: 15,
            min: 5,
            max: 30,
            divisions: 5,
            label: 'S/15',
            onChanged: (double value) {},
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Aplicar filtros',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTripsList() {
    final trips = [
      {
        'driver': 'Carlos Muñoz',
        'destination': 'San Miguel - UPC',
        'time': '15:30',
        'price': 'S/12',
        'rating': 4.5,
        'seats': 3,
      },
      {
        'driver': 'María López',
        'destination': 'Monterrico - UPC',
        'time': '16:45',
        'price': 'S/10',
        'rating': 4.8,
        'seats': 2,
      },
      {
        'driver': 'Luis Torres',
        'destination': 'USIL - La Molina',
        'time': '14:15',
        'price': 'S/15',
        'rating': 4.2,
        'seats': 1,
      },
    ];

    return Column(
      children: trips.map((trip) {
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/driver_placeholder.png'),
            ),
            title: Text(trip['driver'] as String),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip['destination'] as String),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 5),
                    Text(trip['time'] as String),
                    const SizedBox(width: 15),
                    const Icon(Icons.attach_money, size: 16),
                    const SizedBox(width: 5),
                    Text(trip['price'] as String),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(trip['rating'].toString()),
                  ],
                ),
                const SizedBox(height: 5),
                Text('${trip['seats']} asientos'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailScreen(tripData: trip),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}