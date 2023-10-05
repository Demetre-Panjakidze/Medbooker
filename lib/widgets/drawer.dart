import 'package:flutter/material.dart';
import 'package:medbooker/cubit/app_cubits.dart';
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
  final cubit = PageCubit();

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
              if (cubit.state != DashboardPage()) {
                cubit.pageToDashboardPage();
              }
              Navigator.of(context).pop();
              print(cubit.state);
            },
          ),
          if (widget.userInfo["role"] == 'member')
            ListTile(
              title: const Text('Doctors'),
              onTap: () {
                if (cubit.state != DoctorsPage()) {
                  cubit.pageToDoctorsPage();
                }
                Navigator.of(context).pop();
                print(cubit.state);
              },
            ),
          if (widget.userInfo["role"] == 'practitioner')
            ListTile(
              title: const Text('Requests'),
              onTap: () {
                if (cubit.state != ConsultationRequestsPage()) {
                  cubit.pageToConsultationRequestsPage();
                }
                Navigator.of(context).pop();
                print(cubit.state);
              },
            ),
          ListTile(
            title: const Text('Upcoming consultations'),
            onTap: () {
              if (cubit.state != UpcomingConsultationsPage()) {
                cubit.pageToUpcomingConsultationsPage();
              }
              Navigator.of(context).pop();
              print(cubit.state);
            },
          ),
          if (widget.userInfo["role"] == 'member')
            ListTile(
              title: const Text('Health records'),
              onTap: () {
                if (cubit.state != HealthRecordsPage()) {
                  cubit.pageToHealthRecordsPage();
                }
                Navigator.of(context).pop();
                print(cubit.state);
              },
            ),
          if (widget.userInfo["role"] == 'practitioner')
            ListTile(
              title: const Text('Population'),
              onTap: () {
                if (cubit.state != PatientsPage()) {
                  cubit.pageToPatientsPage();
                }
                Navigator.of(context).pop();
                print(cubit.state);
              },
            ),
        ],
      ),
    );
  }
}
