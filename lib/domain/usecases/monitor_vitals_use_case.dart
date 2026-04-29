// TODO: MonitorVitalsUseCase

import '../entities/alert.dart';
import '../entities/vital_sign.dart';
import '../repositories/sensor_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class MonitorVitalsUseCase {
  Stream<VitalSign> watchHeartRate();
  Stream<VitalSign> watchBloodPressure();
  Stream<VitalSign> watchTemperature();
  Stream<Alert> watchAlerts();
  Future<void> start();
  Future<void> stop();
}

class MonitorVitalsUseCaseImpl implements MonitorVitalsUseCase {
  final SensorRepository _repository;

  MonitorVitalsUseCaseImpl({required SensorRepository repository})
      : _repository = repository;

  @override
  Stream<VitalSign> watchHeartRate() => _repository.heartRateStream;

  @override
  Stream<VitalSign> watchBloodPressure() =>
      _repository.bloodPressureStream;

  @override
  Stream<VitalSign> watchTemperature() =>
      _repository.temperatureStream;

  @override
  Stream<Alert> watchAlerts() {
    // Combina los 3 streams y emite alertas cuando un valor es anormal
    final streams = [
      _repository.heartRateStream,
      _repository.bloodPressureStream,
      _repository.temperatureStream,
    ];

    return streams
        .map((stream) => stream.where((v) => !v.isNormal).map(
              (v) => Alert(
                message:
                    '${v.type.name} out of range: ${v.value.toStringAsFixed(1)} ${v.unit}',
                severity: _resolveSeverity(v),
                source: v,
                timestamp: DateTime.now(),
              ),
            ))
        .reduce((a, b) => a.mergeWith([b]));
  }

  AlertSeverity _resolveSeverity(VitalSign v) {
    switch (v.type) {
      case SensorType.heartRate:
        return (v.value < 50 || v.value > 130)
            ? AlertSeverity.critical
            : AlertSeverity.warning;
      case SensorType.bloodPressure:
        return (v.value < 60 || v.value > 140)
            ? AlertSeverity.critical
            : AlertSeverity.warning;
      case SensorType.temperature:
        return (v.value < 35.0 || v.value > 39.0)
            ? AlertSeverity.critical
            : AlertSeverity.warning;
    }
  }

  @override
  Future<void> start() => _repository.startMonitoring();

  @override
  Future<void> stop() => _repository.stopMonitoring();
}