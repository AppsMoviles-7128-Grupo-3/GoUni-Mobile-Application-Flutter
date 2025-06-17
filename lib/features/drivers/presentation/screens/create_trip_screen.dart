import 'package:flutter/material.dart';
import 'package:gouni_flutter/core/widgets/custom_button.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double _price = 10;
  int _availableSeats = 3;
  bool _isRecurring = false;

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
      appBar: AppBar(title: const Text('Publicar viaje')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Completa los detalles de tu viaje',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _originController,
                  decoration: InputDecoration(
                    labelText: 'Origen',
                    hintText: 'Dirección de partida',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el origen del viaje';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Destino',
                    hintText: 'Universidad o destino final',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el destino del viaje';
                    }
                    return null;
                  },
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
                const SizedBox(height: 20),
                const Text(
                  'Precio por asiento (S/)',
                  style: TextStyle(fontSize: 16),
                ),
                Slider(
                  value: _price,
                  min: 5,
                  max: 30,
                  divisions: 5,
                  label: _price.toStringAsFixed(0),
                  onChanged: (value) => setState(() => _price = value),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Asientos disponibles',
                  style: TextStyle(fontSize: 16),
                ),
                Slider(
                  value: _availableSeats.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: _availableSeats.toString(),
                  onChanged: (value) => setState(() => _availableSeats = value.toInt()),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Viaje recurrente'),
                  subtitle: const Text('Publicar este viaje regularmente'),
                  value: _isRecurring,
                  onChanged: (value) => setState(() => _isRecurring = value),
                ),
                if (_isRecurring) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Días de la semana:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilterChip(
                        label: const Text('L'),
                        selected: false,
                        onSelected: (bool value) {},
                      ),
                      FilterChip(
                        label: const Text('M'),
                        selected: false,
                        onSelected: (bool value) {},
                      ),
                      FilterChip(
                        label: const Text('M'),
                        selected: false,
                        onSelected: (bool value) {},
                      ),
                      FilterChip(
                        label: const Text('J'),
                        selected: false,
                        onSelected: (bool value) {},
                      ),
                      FilterChip(
                        label: const Text('V'),
                        selected: false,
                        onSelected: (bool value) {},
                      ),
                      FilterChip(
                        label: const Text('S'),
                        selected: false,
                        onSelected: (bool value) {},
                      ),
                      FilterChip(
                        label: const Text('D'),
                        selected: false,
                        onSelected: (bool value) {},
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Publicar viaje',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Implementar lógica de publicación
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Viaje publicado'),
                          content: const Text(
                              'Tu viaje ha sido publicado con éxito. Los estudiantes podrán verlo y reservar asientos.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}