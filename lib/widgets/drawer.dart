import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
    required this.userInfo,
  });

  final Map<String, dynamic> userInfo;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.userInfo["photoURL"]),
              ),
              title: Text(
                widget.userInfo["displayName"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {},
          ),
          if (widget.userInfo["role"] == 'member')
            ListTile(
              title: const Text('Doctors'),
              onTap: () {},
            ),
          if (widget.userInfo["role"] == 'practitioner')
            ListTile(
              title: const Text('Requests'),
              onTap: () {},
            ),
          ListTile(
            title: const Text('Upcoming consultations'),
            onTap: () {},
          ),
          if (widget.userInfo["role"] == 'member')
            ListTile(
              title: const Text('Health records'),
              onTap: () {},
            ),
          if (widget.userInfo["role"] == 'practitioner')
            ListTile(
              title: const Text('Population'),
              onTap: () {},
            ),
        ],
      ),
    );
  }
}