// TODO: TemperatureIsolate
import 'dart:async';
import 'dart:isolate';
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
    const readings = <double>[
      36.4,
      36.6,
      36.8,
      37.0,
      37.1,
      37.3,
      37.8,
      38.2,
      37.6,
      37.0,
      36.7,
      36.2,
      35.9,
      36.1,
      36.5,
      36.9,
      37.4,
      38.0,
      37.2,
      36.6,
    ];

    var index = 0;
    final timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final value = readings[index];
      index = (index + 1) % readings.length;

      sendPort.send({
        'value': value,
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
