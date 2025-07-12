import 'package:flutter/material.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:gouni_flutter/data/remote/api/reservation_api.dart';
import 'package:gouni_flutter/data/repository/reservation_repository_impl.dart';
import 'package:gouni_flutter/domain/model/student_reservation.dart';
import 'package:dio/dio.dart';

class BookingItem {
  final String id;
  final domain.Route route;
  final int passengers;
  final DateTime bookingDate;
  final String status;
  final String? meetingPlace;

  BookingItem({
    required this.id,
    required this.route,
    required this.passengers,
    required this.bookingDate,
    required this.status,
    this.meetingPlace,
  });
}

class BookingProvider extends ChangeNotifier {
  List<BookingItem> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<BookingItem> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Método para cargar reservas del backend
  Future<void> loadBookingsFromBackend(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));
      final reservationApi = ReservationApi(dio);
      final repository = ReservationRepositoryImpl(reservationApi);

      // Obtener reservas del backend
      await for (final reservations in repository.getReservationsByPassenger(
        userId,
      )) {
        _bookings = await _convertToBookingItems(reservations);
        _isLoading = false;
        notifyListeners();
        break; // Solo tomamos el primer resultado
      }
    } catch (e) {
      _error = 'Error al cargar reservas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para convertir StudentReservation a BookingItem
  Future<List<BookingItem>> _convertToBookingItems(
    List<StudentReservation> reservations,
  ) async {
    // Nota: Aquí necesitarías obtener la información completa de la ruta
    // usando el routeId de cada reservación
    return reservations
        .map(
          (reservation) => BookingItem(
            id: reservation.id,
            route: _createDummyRoute(
              reservation,
            ), // Temporal hasta obtener la ruta real
            passengers: 1, // Esto debería venir de la reservación
            bookingDate: DateTime.now(), // Esto debería venir de la reservación
            status: reservation.status.name,
            meetingPlace: reservation.meetingPlace,
          ),
        )
        .toList();
  }

  // Método temporal para crear una ruta dummy
  domain.Route _createDummyRoute(StudentReservation reservation) {
    return domain.Route(
      id: int.parse(reservation.routeId),
      userId: 1, // Temporal
      carId: 1,
      start: "Origen", // Necesitarías obtener esto del backend
      end: "Destino",
      days: ['MONDAY'],
      departureTime: const TimeOfDay(hour: 8, minute: 0),
      arrivalTime: const TimeOfDay(hour: 9, minute: 0),
      availableSeats: 4,
      price: 10.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Método para crear una nueva reserva en el backend
  Future<void> createBookingInBackend(
    BookingItem booking,
    String userId,
  ) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/'));
      final reservationApi = ReservationApi(dio);
      final repository = ReservationRepositoryImpl(reservationApi);

      // Crear reservación en el backend
      final reservation = StudentReservation(
        id: booking.id,
        routeId: booking.route.id.toString(),
        studentName: "Estudiante", // Esto debería venir del usuario actual
        age: 20,
        meetingPlace: booking.meetingPlace ?? "",
        universityId: "UNI001",
      );

      await repository.createReservation(reservation);

      // Agregar localmente después de crear en backend
      _bookings.add(booking);
      notifyListeners();
    } catch (e) {
      _error = 'Error al crear reserva: $e';
      notifyListeners();
      rethrow;
    }
  }

  void addBooking(BookingItem booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void removeBooking(String bookingId) {
    _bookings.removeWhere((booking) => booking.id == bookingId);
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookings.indexWhere((booking) => booking.id == bookingId);
    if (index != -1) {
      final booking = _bookings[index];
      _bookings[index] = BookingItem(
        id: booking.id,
        route: booking.route,
        passengers: booking.passengers,
        bookingDate: booking.bookingDate,
        status: newStatus,
        meetingPlace: booking.meetingPlace,
      );
      notifyListeners();
    }
  }

  List<BookingItem> getBookingsByUserId(String userId) {
    return _bookings
        .where((booking) => booking.route.userId.toString() == userId)
        .toList();
  }

  void clearBookings() {
    _bookings.clear();
    notifyListeners();
  }
}
