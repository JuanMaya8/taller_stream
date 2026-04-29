// TODO: VitalSignController (broadcast)
import 'dart:async';
import '../../core/errors/sensor_exception.dart';
import '../../domain/entities/vital_sign.dart';

class VitalSignController {
  // broadcast = múltiples widgets pueden escuchar simultáneamente
  final StreamController<VitalSign> _controller =
      StreamController<VitalSign>.broadcast();

  Stream<VitalSign> get stream => _controller.stream;

  // Filtra por tipo de sensor para que cada widget reciba solo lo suyo
  Stream<VitalSign> streamByType(SensorType type) =>
      _controller.stream.where((v) => v.type == type);

  void add(VitalSign vitalSign) {
    if (_controller.isClosed) return;
    _controller.add(vitalSign);
  }

  void addError(SensorException exception) {
    if (_controller.isClosed) return;
    _controller.addError(exception);
  }

  void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}