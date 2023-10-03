import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;
User? _user = _firebase.currentUser;

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation center',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Doctors'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Requests'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Upcoming consultations'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Health records'),
              onTap: () {},
            ),
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
              // _firebase.signOut();
              print(_user);
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
