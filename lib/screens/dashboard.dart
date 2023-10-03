import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_userData!["photoURL"]),
                    ),
                    title: Text(
                      _userData!["displayName"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Dashboard'),
                onTap: () {},
              ),
              if (_userData!["role"] == 'member')
                ListTile(
                  title: const Text('Doctors'),
                  onTap: () {},
                ),
              if (_userData!["role"] == 'practitioner')
                ListTile(
                  title: const Text('Requests'),
                  onTap: () {},
                ),
              ListTile(
                title: const Text('Upcoming consultations'),
                onTap: () {},
              ),
              if (_userData!["role"] == 'member')
                ListTile(
                  title: const Text('Health records'),
                  onTap: () {},
                ),
              if (_userData!["role"] == 'practitioner')
                ListTile(
                  title: const Text('Population'),
                  onTap: () {},
                ),
            ],
          ),
        ),
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
        body: Center(
          child: Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  print(_userData);
                },
                child: const Text('Print user info'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Column(
        children: [
          CircularProgressIndicator(),
        ],
      );
    }
  }
}
