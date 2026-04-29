// TODO: SensorRepositoryImpl
import '../../core/errors/sensor_exception.dart';
import '../../domain/entities/vital_sign.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../controllers/vital_sign_controller.dart';
import '../isolates/blood_pressure_isolate.dart';
import '../isolates/heart_rate_isolate.dart';
import '../isolates/temperature_isolate.dart';

class SensorRepositoryImpl implements SensorRepository {
  final VitalSignController _vitalSignController;

  late final HeartRateIsolate _heartRateIsolate;
  late final BloodPressureIsolate _bloodPressureIsolate;
  late final TemperatureIsolate _temperatureIsolate;

  SensorRepositoryImpl({required VitalSignController vitalSignController})
      : _vitalSignController = vitalSignController {
    _heartRateIsolate = HeartRateIsolate(
      onData: _vitalSignController.add,
      onError: (e) => _vitalSignController.addError(
        SensorException(
          message: e.toString(),
          sensorType: 'heartRate',
          timestamp: DateTime.now(),
        ),
      ),
    );

    _bloodPressureIsolate = BloodPressureIsolate(
      onData: _vitalSignController.add,
      onError: (e) => _vitalSignController.addError(
        SensorException(
          message: e.toString(),
          sensorType: 'bloodPressure',
          timestamp: DateTime.now(),
        ),
      ),
    );

    _temperatureIsolate = TemperatureIsolate(
      onData: _vitalSignController.add,
      onError: (e) => _vitalSignController.addError(
        SensorException(
          message: e.toString(),
          sensorType: 'temperature',
          timestamp: DateTime.now(),
        ),
      ),
    );
  }

  @override
  Stream<VitalSign> get heartRateStream =>
      _vitalSignController.streamByType(SensorType.heartRate);

  @override
  Stream<VitalSign> get bloodPressureStream =>
      _vitalSignController.streamByType(SensorType.bloodPressure);

  @override
  Stream<VitalSign> get temperatureStream =>
      _vitalSignController.streamByType(SensorType.temperature);

  @override
  Future<void> startMonitoring() async {
    await Future.wait([
      _heartRateIsolate.start(),
      _bloodPressureIsolate.start(),
      _temperatureIsolate.start(),
    ]);
  }

  @override
  Future<void> stopMonitoring() async {
    _heartRateIsolate.stop();
    _bloodPressureIsolate.stop();
    _temperatureIsolate.stop();
  }

  @override
  void dispose() {
    stopMonitoring();
    _vitalSignController.dispose();
  }
}