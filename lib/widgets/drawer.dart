import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medbooker/cubit/page_identifier_cubit.dart';
import 'package:medbooker/screens/consultation-requests.dart';
import 'package:medbooker/screens/dashboard.dart';
import 'package:medbooker/screens/doctors.dart';
import 'package:medbooker/screens/health-records.dart';
import 'package:medbooker/screens/patients.dart';
import 'package:medbooker/screens/upcoming-consultations.dart';

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
            onTap: () {
              Navigator.pop(context);
              BlocProvider.of<PageIdentifierCubit>(context)
                  .pageNameChange(page: 'Dashboard');
            },
          ),
          if (widget.userInfo["role"] == 'member')
            ListTile(
              title: const Text('Doctors'),
              onTap: () {
                BlocProvider.of<PageIdentifierCubit>(context).pageNameChange(
                  page: 'Doctors',
                );
              },
            ),
          if (widget.userInfo["role"] == 'practitioner')
            ListTile(
              title: const Text('Requests'),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<PageIdentifierCubit>(context)
                    .pageNameChange(page: 'Requests');
              },
            ),
          ListTile(
            title: const Text('Upcoming consultations'),
            onTap: () {
              Navigator.pop(context);
              BlocProvider.of<PageIdentifierCubit>(context)
                  .pageNameChange(page: 'Upcoming consultations');
            },
          ),
          if (widget.userInfo["role"] == 'member')
            ListTile(
              title: const Text('Health records'),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<PageIdentifierCubit>(context)
                    .pageNameChange(page: 'Health records');
              },
            ),
          if (widget.userInfo["role"] == 'practitioner')
            ListTile(
              title: const Text('Population'),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<PageIdentifierCubit>(context)
                    .pageNameChange(page: 'Population');
              },
            ),
        ],
      ),
    );
  }
}
