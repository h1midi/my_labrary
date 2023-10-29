import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_library/add_book.dart';
import 'package:my_library/library.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/add_book': (context) => const AddBook(),
      },
      home: const Library(),
    );
  }
}
