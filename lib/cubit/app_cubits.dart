import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:medbooker/screens/consultation-requests.dart';
import 'package:medbooker/screens/dashboard.dart';
import 'package:medbooker/screens/doctors.dart';
import 'package:medbooker/screens/health-records.dart';
import 'package:medbooker/screens/homepage.dart';
import 'package:medbooker/screens/patients.dart';
import 'package:medbooker/screens/upcoming-consultations.dart';

class PageCubit extends Cubit<Widget> {
  PageCubit() : super(const DashboardPage());

  void pageToDashboardPage() => emit(
        const DashboardPage(),
      );
  void pageToDoctorsPage() => emit(
        const DoctorsPage(),
      );
  void pageToConsultationRequestsPage() => emit(
        const ConsultationRequestsPage(),
      );
  void pageToUpcomingConsultationsPage() => emit(
        const UpcomingConsultationsPage(),
      );
  void pageToHealthRecordsPage() => emit(
        const HealthRecordsPage(),
      );
  void pageToPatientsPage() => emit(
        const PatientsPage(),
      );
}
