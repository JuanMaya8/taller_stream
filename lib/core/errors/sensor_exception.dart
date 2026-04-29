// TODO: SensorException
class SensorException implements Exception {
  final String message;
  final String sensorType;
  final DateTime timestamp;

  const SensorException({
    required this.message,
    required this.sensorType,
    required this.timestamp,
  });

  @override
  String toString() =>
      'SensorException [$sensorType] at $timestamp: $message';
}