// TODO: VitalSign entity
enum SensorType { heartRate, bloodPressure, temperature }

class VitalSign {
  final SensorType type;
  final double value;
  final String unit;
  final DateTime timestamp;

  const VitalSign({
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  bool get isNormal {
    switch (type) {
      case SensorType.heartRate:
        return value >= 60 && value <= 100;
      case SensorType.bloodPressure:
        return value >= 70 && value <= 120;
      case SensorType.temperature:
        return value >= 36.1 && value <= 37.2;
    }
  }

  @override
  String toString() =>
      'VitalSign(${type.name}: $value $unit @ $timestamp)';
}