// TODO: TemperatureWidget
import 'package:flutter/material.dart';
import '../../domain/entities/vital_sign.dart';
import '../../domain/usecases/monitor_vitals_use_case.dart';
import 'vital_card.dart';

class TemperatureWidget extends StatelessWidget {
  final MonitorVitalsUseCase useCase;

  const TemperatureWidget({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VitalSign>(
      stream: useCase.watchTemperature(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorCard(message: snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const LoadingCard(label: 'Temperature');
        }

        final vital = snapshot.data!;
        return VitalCard(
          label: 'Temperature',
          value: vital.value.toStringAsFixed(1),
          unit: vital.unit,
          isNormal: vital.isNormal,
          icon: Icons.thermostat,
          timestamp: vital.timestamp,
        );
      },
    );
  }
}
