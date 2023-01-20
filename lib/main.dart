import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/login/auth.dart';
import 'package:to_do_app/model/local_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(LocalDatabaseAdapter());
  await Hive.openBox<LocalDatabase>('to_do_list');
  debugPrint("Box opened");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthPage(),
    );
  }
}
