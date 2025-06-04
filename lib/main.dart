import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/Login.dart';
import 'package:flutter_firebase/Myposts.dart';
import 'package:flutter_firebase/addpost.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/home.dart';
import 'package:flutter_firebase/register.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: '/',
      routes: {
        '/login': (context) => Login(),
        // '/': (context) => Register(),
        '/home': (context) => HomepPage(),
        '/addpost': (context) => AddPost(),
        '/myposts': (context) => MyPosts(),
      },
      home: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.done ||
              snapshots.connectionState == ConnectionState.active) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authstate) {
                if (authstate.hasData) {
                  return HomepPage();
                } else {
                  return Login();
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
