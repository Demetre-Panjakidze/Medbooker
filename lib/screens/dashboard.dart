import 'package:flutter/material.dart';
import 'package:medbooker/cubit/app_cubits.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final cubit = PageCubit();

  @override
  Widget build(BuildContext context) {
    return Text(cubit.state.toString());
  }
}
