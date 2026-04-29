// TODO: AlertBannerWidget
import 'package:flutter/material.dart';
import '../../domain/entities/alert.dart';
import '../../domain/usecases/monitor_vitals_use_case.dart';

class AlertBannerWidget extends StatelessWidget {
  final MonitorVitalsUseCase useCase;

  const AlertBannerWidget({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Alert>(
      stream: useCase.watchAlerts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final alert = snapshot.data!;
        final isCritical = alert.severity == AlertSeverity.critical;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCritical
                ? Colors.red.shade50
                : Colors.orange.shade50,
            border: Border.all(
              color: isCritical ? Colors.red : Colors.orange,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isCritical ? Icons.error : Icons.warning_amber,
                color: isCritical ? Colors.red : Colors.orange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCritical ? 'CRITICAL' : 'WARNING',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isCritical ? Colors.red : Colors.orange,
                      ),
                    ),
                    Text(
                      alert.message,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
