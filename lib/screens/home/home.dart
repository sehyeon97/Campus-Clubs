import 'package:campus_clubs/data/upload_json_to_db.dart';
import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/firestore.dart';
import 'package:campus_clubs/providers/users_available_clubs.dart';
import 'package:campus_clubs/providers/users_joined_clubs.dart';
import 'package:campus_clubs/screens/home/tabs/available_clubs_tab.dart';
import 'package:campus_clubs/screens/home/tabs/users_clubs_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  int _selectedTab = 0;

  final tabs = const [
    AvailableClubs(),
    UsersClubs(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        _setUserJoinedClubs();
      case AppLifecycleState.resumed:
        _doSomething();
      case AppLifecycleState.inactive:
        _updateFireStore();
      case AppLifecycleState.hidden:
        _updateFireStore();
      case AppLifecycleState.paused:
        _updateFireStore();
    }
  }

  void _doSomething() async {
    await UploadJsonToFS.upload();
  }

  void _setUserJoinedClubs() async {
    final List<Club> joinedClubs = await Firestore.loadJoinedClubs(userID);
    ref.read(userJoinedClubsProvider.notifier).set(joinedClubs);
  }

  void _updateFireStore() async {
    final availableClubs = ref.watch(userAvailableProvider);
    final originalAvailableClubs = await Firestore.loadAvailableClubs(userID);

    if (availableClubs.length != originalAvailableClubs.length) {
      await Firestore.updateAvailableAndJoinedClubs(
          availableClubs, ref.watch(userJoinedClubsProvider), userID);
    }
  }

  void _onBarItemTap(int tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Available Clubs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "My Clubs",
          ),
        ],
        currentIndex: _selectedTab,
        onTap: (value) {
          _onBarItemTap(value);
        },
      ),
      body: tabs[_selectedTab],
    );
  }
}
