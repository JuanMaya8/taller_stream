// TODO: HeartRateIsolate
import 'dart:async';
import 'dart:isolate';
import '../../domain/entities/vital_sign.dart';

class HeartRateIsolate {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  final void Function(VitalSign) onData;
  final void Function(Object) onError;

  HeartRateIsolate({required this.onData, required this.onError});

  Future<void> start() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      _isolateEntryPoint,
      _receivePort!.sendPort,
      onError: _receivePort!.sendPort,
      debugName: 'HeartRateIsolate',
    );

    _receivePort!.listen((message) {
      if (message is Map<String, dynamic>) {
        onData(
          VitalSign(
            type: SensorType.heartRate,
            value: message['value'] as double,
            unit: 'bpm',
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
      72,
      76,
      81,
      88,
      94,
      101,
      98,
      86,
      79,
      64,
      58,
      62,
      69,
      75,
      83,
      91,
      106,
      99,
      87,
      73,
    ];

    var index = 0;
    final timer = Timer.periodic(const Duration(seconds: 2), (_) {
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
