import 'package:hive/hive.dart';
import 'package:to_do_app/model/local_database.dart';

class Boxes {
  static Box<LocalDatabase> getData() => Hive.box<LocalDatabase>('to_do_list');
}
