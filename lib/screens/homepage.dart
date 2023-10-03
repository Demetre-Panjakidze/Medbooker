import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:medbooker/screens/dashboard.dart';
import 'package:medbooker/widgets/drawer.dart';

final FirebaseAuth _firebase = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  User? _user;
  DocumentReference? _userDocRef;
  Map<String, dynamic>? _userData;
  Widget screen = const DashboardPage();

  @override
  void initState() {
    super.initState();
    _user = _firebase.currentUser;
    _userDocRef = _firestore.collection('users').doc(_user!.uid);

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      if (_userDocRef != null) {
        final DocumentSnapshot userSnapshot = await _userDocRef!.get();
        _userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {});
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userDocRef != null && _user != null && _userData != null) {
      return Scaffold(
        drawer: DrawerWidget(userInfo: _userData!),
        appBar: AppBar(
          title: const Text('Medbooker'),
          actions: <Widget>[
            OutlinedButton(
              child: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () async {
                await Future.delayed(
                  const Duration(
                    milliseconds: 300,
                  ),
                );
                _firebase.signOut();
              },
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: screen,
      );
    } else {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 75.0,
              width: 75.0,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }
  }
}
