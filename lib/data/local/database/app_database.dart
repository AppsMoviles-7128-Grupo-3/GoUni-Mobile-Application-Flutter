import 'package:floor/floor.dart';
import 'package:gouni_flutter/data/local/dao/reservation_dao.dart';
import 'package:gouni_flutter/data/local/dao/route_dao.dart';
import 'package:gouni_flutter/data/local/dao/user_dao.dart';
import 'package:gouni_flutter/data/local/entity/reservation_entity.dart';
import 'package:gouni_flutter/data/local/entity/route_entity.dart';
import 'package:gouni_flutter/data/local/entity/user_entity.dart';



//part 'app_database.g.dart'; // se genera automáticamente

@Database(
  version: 5,
  entities: [UserEntity, RouteEntity, ReservationEntity],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  RouteDao get routeDao;
  ReservationDao get reservationDao;
}