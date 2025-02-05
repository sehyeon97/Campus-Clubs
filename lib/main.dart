import 'package:campus_clubs/screens/login/login.dart';
import 'package:campus_clubs/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

final String userID = FirebaseAuth.instance.currentUser!.uid;

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: StreamBuilder(
          // if this user has been authenticated via login previously,
          // then go straight to Home screen instead of showing login screen
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // run this to update the db to match json
              // UploadJsonToFS.upload();
              return const SplashScreen();
            }

            return const Login();
          },
        ),
        theme: ThemeData.dark(),
      ),
    );
  }
}
