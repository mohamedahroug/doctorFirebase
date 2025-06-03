import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/Login.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/home.dart';
import 'package:flutter_firebase/register.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // <-- مهم جدًا
//   runApp(MainApp());
// }
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) =>  Login(),
        '/': (context) =>  Register(),
        '/home': (context) =>  Home(),
        },
      // home: Register(),
    );
  }
}
