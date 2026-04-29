// TODO: Alert entity
import 'vital_sign.dart';

enum AlertSeverity { warning, critical }

class Alert {
  final String message;
  final AlertSeverity severity;
  final VitalSign source;
  final DateTime timestamp;

  const Alert({
    required this.message,
    required this.severity,
    required this.source,
    required this.timestamp,
  });

  @override
  String toString() =>
      'Alert [${severity.name.toUpperCase()}]: $message';
}