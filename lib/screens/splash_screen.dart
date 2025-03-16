import 'dart:async';

import 'package:campus_clubs/providers/firestore.dart';
import 'package:campus_clubs/providers/users_available_clubs.dart';
import 'package:campus_clubs/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _onPageLoad();
    startTime();
  }

  // Do not change Duration, otherwise _pageLoad() will not fetch properly
  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  void route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void _onPageLoad() async {
    ref
        .read(userAvailableProvider.notifier)
        .set(await Firestore.loadAvailableClubs());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: insert a fitting picture here
            // Container(
            //   child: Image.asset("images/logo.png"),
            // ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              "Live Your Purpose",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 1,
            )
          ],
        ),
      ),
    );
  }
}
