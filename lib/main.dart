import 'package:flutter/material.dart';
import 'data/controllers/alert_controller.dart';
import 'data/controllers/vital_sign_controller.dart';
import 'data/repositories/sensor_repository_impl.dart';
import 'domain/usecases/monitor_vitals_use_case.dart';
import 'presentation/screens/dashboard_screen.dart';

void main() {
  // Ensamble de dependencias — sin inyector externo, manual y claro para el taller
  final vitalSignController = VitalSignController();
  final alertController = AlertController();

  final repository = SensorRepositoryImpl(
    vitalSignController: vitalSignController,
  );

  final useCase = MonitorVitalsUseCaseImpl(repository: repository);

  runApp(MyApp(useCase: useCase));
}

class MyApp extends StatelessWidget {
  final MonitorVitalsUseCase useCase;

  const MyApp({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital Signs Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: DashboardScreen(useCase: useCase),
    );
  }
}