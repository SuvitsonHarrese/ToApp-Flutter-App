
import 'package:hive/hive.dart';
part 'local_database.g.dart';
@HiveType(typeId: 0)
class LocalDatabase {
  @HiveField(0)
  String uuid;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String date;

  @HiveField(4)
  String time;

  @HiveField(5)
  bool notify;

  @HiveField(6)
  bool? done;

  LocalDatabase({
    required this.uuid,
    required this.title,
    required this.description,
    required this.date,
    required this.notify,
    required this.time,
    required this.done

  });
}
