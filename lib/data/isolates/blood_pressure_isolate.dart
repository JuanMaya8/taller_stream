// TODO: BloodPressureIsolate
import 'dart:async';
import 'dart:isolate';
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
        onData(
          VitalSign(
            type: SensorType.bloodPressure,
            value: message['value'] as double,
            unit: 'mmHg',
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
      118,
      122,
      116,
      110,
      104,
      96,
      88,
      74,
      68,
      72,
      84,
      93,
      105,
      117,
      126,
      134,
      128,
      119,
      112,
      100,
    ];

    var index = 0;
    final timer = Timer.periodic(const Duration(seconds: 3), (_) {
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
