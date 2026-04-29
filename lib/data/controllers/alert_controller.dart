// TODO: AlertController (broadcast)
import 'dart:async';
import '../../domain/entities/alert.dart';

class AlertController {
  final StreamController<Alert> _controller =
      StreamController<Alert>.broadcast();

  Stream<Alert> get stream => _controller.stream;

  Stream<Alert> streamBySeverity(AlertSeverity severity) =>
      _controller.stream.where((a) => a.severity == severity);

  void add(Alert alert) {
    if (_controller.isClosed) return;
    _controller.add(alert);
  }

  void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}