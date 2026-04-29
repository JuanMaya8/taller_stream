// TODO: HeartRateIsolate
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import '../../domain/entities/vital_sign.dart';

class HeartRateIsolate {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  // El callback que se ejecuta en el hilo principal cuando llega un dato
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
        // Mensaje válido del sensor
        onData(VitalSign(
          type: SensorType.heartRate,
          value: message['value'] as double,
          unit: 'bpm',
          timestamp: DateTime.parse(message['timestamp'] as String),
        ));
      } else if (message is List) {
        // Formato de error que envía Isolate.spawn onError: [errorMsg, stackTrace]
        onError(message[0] as Object);
      }
    });
  }

  // Este método corre en el hilo separado — no puede acceder a nada del hilo principal
  static void _isolateEntryPoint(SendPort sendPort) async {
    final random = Random();
    final timer = Timer.periodic(const Duration(seconds: 2), (_) {
      // Simula lectura de sensor con valores ocasionalmente anormales
      final value = 55.0 + random.nextDouble() * 60;

      sendPort.send({
        'value': double.parse(value.toStringAsFixed(1)),
        'timestamp': DateTime.now().toIso8601String(),
      });
    });

    // Mantiene el isolate vivo
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