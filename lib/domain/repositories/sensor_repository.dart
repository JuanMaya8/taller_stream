// TODO: abstract SensorRepository
import '../entities/vital_sign.dart';

abstract class SensorRepository {
  Stream<VitalSign> get heartRateStream;
  Stream<VitalSign> get bloodPressureStream;
  Stream<VitalSign> get temperatureStream;

  Future<void> startMonitoring();
  Future<void> stopMonitoring();
  void dispose();
}