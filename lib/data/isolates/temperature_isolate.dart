// TODO: TemperatureIsolate
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import '../../domain/entities/vital_sign.dart';

class TemperatureIsolate {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  final void Function(VitalSign) onData;
  final void Function(Object) onError;

  TemperatureIsolate({required this.onData, required this.onError});

  Future<void> start() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      _isolateEntryPoint,
      _receivePort!.sendPort,
      onError: _receivePort!.sendPort,
      debugName: 'TemperatureIsolate',
    );

    _receivePort!.listen((message) {
      if (message is Map<String, dynamic>) {
        onData(
          VitalSign(
            type: SensorType.temperature,
            value: message['value'] as double,
            unit: '\u00B0C',
            timestamp: DateTime.parse(message['timestamp'] as String),
          ),
        );
      } else if (message is List) {
        onError(message[0] as Object);
      }
    });
  }

  static void _isolateEntryPoint(SendPort sendPort) async {
    final random = Random();
    final timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final value = 35.0 + random.nextDouble() * 4.5;

      sendPort.send({
        'value': double.parse(value.toStringAsFixed(2)),
        'timestamp': DateTime.now().toIso8601String(),
      });
    });

    await Future.delayed(const Duration(days: 1));
    timer.cancel();
  }

  void stop() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _isolate = null;
    _receivePort = null;
  }
}
