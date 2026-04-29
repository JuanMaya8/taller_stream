// TODO: BloodPressureIsolate
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import '../../domain/entities/vital_sign.dart';

class BloodPressureIsolate {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  final void Function(VitalSign) onData;
  final void Function(Object) onError;

  BloodPressureIsolate({required this.onData, required this.onError});

  Future<void> start() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      _isolateEntryPoint,
      _receivePort!.sendPort,
      onError: _receivePort!.sendPort,
      debugName: 'BloodPressureIsolate',
    );

    _receivePort!.listen((message) {
      if (message is Map<String, dynamic>) {
        onData(VitalSign(
          type: SensorType.bloodPressure,
          value: message['value'] as double,
          unit: 'mmHg',
          timestamp: DateTime.parse(message['timestamp'] as String),
        ));
      } else if (message is List) {
        onError(message[0] as Object);
      }
    });
  }

  static void _isolateEntryPoint(SendPort sendPort) async {
    final random = Random();
    final timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final value = 60.0 + random.nextDouble() * 80;

      sendPort.send({
        'value': double.parse(value.toStringAsFixed(1)),
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