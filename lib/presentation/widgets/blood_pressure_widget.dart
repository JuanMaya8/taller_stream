// TODO: BloodPressureWidget
import 'package:flutter/material.dart';
import '../../domain/entities/vital_sign.dart';
import '../../domain/usecases/monitor_vitals_use_case.dart';
import 'vital_card.dart';

class BloodPressureWidget extends StatelessWidget {
  final MonitorVitalsUseCase useCase;

  const BloodPressureWidget({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VitalSign>(
      stream: useCase.watchBloodPressure(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorCard(message: snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const LoadingCard(label: 'Blood Pressure');
        }

        final vital = snapshot.data!;
        return VitalCard(
          label: 'Blood Pressure',
          value: vital.value.toStringAsFixed(0),
          unit: vital.unit,
          isNormal: vital.isNormal,
          icon: Icons.water_drop,
          timestamp: vital.timestamp,
        );
      },
    );
  }
}
