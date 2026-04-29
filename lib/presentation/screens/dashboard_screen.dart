// TODO: DashboardScreen
import 'package:flutter/material.dart';
import '../../domain/usecases/monitor_vitals_use_case.dart';
import '../widgets/alert_banner_widget.dart';
import '../widgets/blood_pressure_widget.dart';
import '../widgets/heart_rate_widget.dart';
import '../widgets/temperature_widget.dart';

class DashboardScreen extends StatefulWidget {
  final MonitorVitalsUseCase useCase;

  const DashboardScreen({super.key, required this.useCase});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    widget.useCase.start();
  }

  @override
  void dispose() {
    widget.useCase.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Vital Signs Monitor'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Live',
                  style: TextStyle(fontSize: 13, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AlertBannerWidget(useCase: widget.useCase),
          const SizedBox(height: 8),
          HeartRateWidget(useCase: widget.useCase),
          const SizedBox(height: 12),
          BloodPressureWidget(useCase: widget.useCase),
          const SizedBox(height: 12),
          TemperatureWidget(useCase: widget.useCase),
        ],
      ),
    );
  }
}
