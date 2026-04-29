# Medical IoT - Vital Signs Monitor

Proyecto Flutter para un taller sobre `StreamController`, `StreamBuilder`, streams broadcast e isolates en Dart.

La aplicación simula un monitor médico IoT en tiempo real. Tres sensores virtuales se ejecutan en hilos separados usando Dart Isolates y envían datos continuos al hilo principal. La UI escucha esos datos mediante streams y actualiza tarjetas de signos vitales sin bloquear la interfaz.

## Caso de Estudio

El caso elegido es un dashboard médico de signos vitales porque permite demostrar de forma natural varios conceptos importantes de programación reactiva en Flutter:

- Datos continuos en tiempo real.
- Múltiples listeners sobre el mismo flujo usando `StreamController.broadcast()`.
- Separación entre generación de datos, reglas de negocio y UI.
- Uso de isolates para simular sensores independientes sin afectar el hilo principal.
- Manejo de errores recuperables, por ejemplo un sensor desconectado.
- Composición de streams con RxDart para generar alertas.

## Funcionalidades

- Simulación interna de sensor de frecuencia cardiaca.
- Simulación interna de sensor de presión arterial.
- Simulación interna de sensor de temperatura corporal.
- Comunicación entre isolates y el hilo principal usando `SendPort` y `ReceivePort`.
- Streams broadcast para permitir varios oyentes simultáneos.
- Filtrado de streams por tipo de sensor.
- Tarjetas reactivas con `StreamBuilder`.
- Banner de alertas cuando un signo vital está fuera del rango normal.
- Arquitectura limpia separada por capas.
- Inyección de dependencias manual desde `main.dart`, sin Provider, Bloc ni Riverpod.

## Vista Actual

Actualmente el dashboard muestra:

- Estado general `Live`.
- Banner de alerta cuando llega una lectura anormal.
- Tarjeta de `Heart Rate`.
- Tarjeta de `Blood Pressure`.
- Tarjeta de `Temperature`.

Los tres sensores se ejecutan internamente y los tres tienen representación visual en el dashboard.


## Tecnologías

- Flutter
- Dart
- Dart Isolates
- `StreamController`
- `StreamBuilder`
- RxDart
- Material 3

Dependencia principal agregada:

```yaml
rxdart: ^0.28.0
```

## Arquitectura

El proyecto sigue una estructura inspirada en Clean Architecture y principios SOLID.

```text
lib/
├── main.dart
├── core/
│   └── errors/
│       └── sensor_exception.dart
├── domain/
│   ├── entities/
│   │   ├── alert.dart
│   │   └── vital_sign.dart
│   ├── repositories/
│   │   └── sensor_repository.dart
│   └── usecases/
│       └── monitor_vitals_use_case.dart
├── data/
│   ├── controllers/
│   │   ├── alert_controller.dart
│   │   └── vital_sign_controller.dart
│   ├── isolates/
│   │   ├── blood_pressure_isolate.dart
│   │   ├── heart_rate_isolate.dart
│   │   └── temperature_isolate.dart
│   └── repositories/
│       └── sensor_repository_impl.dart
└── presentation/
    ├── screens/
    │   └── dashboard_screen.dart
    └── widgets/
        ├── alert_banner_widget.dart
        ├── blood_pressure_widget.dart
        ├── heart_rate_widget.dart
        ├── temperature_widget.dart
        └── vital_card.dart
```

## Flujo de Datos

El flujo principal del proyecto es:

```text
Isolate del sensor
  -> SendPort.send(Map)
    -> ReceivePort en el isolate principal
      -> VitalSignController.add(VitalSign)
        -> StreamController<VitalSign>.broadcast()
          -> SensorRepository filtra por tipo
            -> MonitorVitalsUseCase.watch*()
              -> StreamBuilder
                -> UI actualizada
```

Para las alertas:

```text
heartRateStream
bloodPressureStream
temperatureStream
  -> se filtran valores anormales
    -> se transforman en Alert
      -> se combinan con mergeWith de RxDart
        -> AlertBannerWidget
```

## Sensores Simulados

| Sensor | Archivo | Intervalo | Rango simulado | Unidad |
|---|---|---:|---:|---|
| Frecuencia cardiaca | `heart_rate_isolate.dart` | 2 segundos | 55 - 115 | bpm |
| Presión arterial | `blood_pressure_isolate.dart` | 3 segundos | 60 - 140 | mmHg |
| Temperatura | `temperature_isolate.dart` | 4 segundos | 35.0 - 39.5 | °C |

Cada sensor genera datos con `Timer.periodic` dentro de su propio isolate.

## Rangos Normales

Los rangos normales están definidos en la entidad `VitalSign`, dentro del getter `isNormal`.

| Sensor | Rango normal |
|---|---|
| Frecuencia cardiaca | 60 - 100 bpm |
| Presión arterial | 70 - 120 mmHg |
| Temperatura | 36.1 - 37.2 °C |

Cuando una lectura queda fuera de estos rangos, el caso de uso genera una alerta.

## Puntos Clave del Código

### `VitalSignController`

Usa un `StreamController<VitalSign>.broadcast()` para que varios widgets puedan escuchar el mismo flujo de datos.

También expone `streamByType(SensorType type)` para que cada widget reciba únicamente el signo vital que necesita.

### `SensorRepositoryImpl`

Conecta los isolates con el controlador de signos vitales.

Cuando inicia el monitoreo, lanza los tres sensores con `Future.wait`:

```dart
await Future.wait([
  _heartRateIsolate.start(),
  _bloodPressureIsolate.start(),
  _temperatureIsolate.start(),
]);
```

### `MonitorVitalsUseCase`

Expone los métodos que consume la UI:

```dart
Stream<VitalSign> watchHeartRate();
Stream<VitalSign> watchBloodPressure();
Stream<VitalSign> watchTemperature();
Stream<Alert> watchAlerts();
Future<void> start();
Future<void> stop();
```

Además combina los streams de signos vitales para producir alertas usando RxDart.

### `DashboardScreen`

Es un `StatefulWidget` porque controla el ciclo de vida del monitoreo:

- En `initState()` llama `useCase.start()`.
- En `dispose()` llama `useCase.stop()`.

Esto evita que los isolates sigan corriendo cuando la pantalla se destruye.

## Requisitos

Antes de correr el proyecto necesitas tener instalado:

- Flutter SDK compatible con Dart `^3.11.0`.
- Android Studio o Visual Studio Code con extensiones de Flutter/Dart.
- Un emulador Android, simulador iOS o dispositivo físico.
- Git, si vas a clonar el repositorio.

Verifica tu instalación con:

```bash
flutter doctor
```

## Instalación

Desde la carpeta del proyecto:

```bash
flutter pub get
```

Esto descarga las dependencias declaradas en `pubspec.yaml`, incluyendo RxDart.

## Cómo Ejecutar

Lista los dispositivos disponibles:

```bash
flutter devices
```

Ejecuta la app:

```bash
flutter run
```

Si tienes varios dispositivos conectados, usa:

```bash
flutter run -d <device-id>
```

Ejemplo:

```bash
flutter run -d emulator-5554
```

## Comandos Útiles

Analizar el código:

```bash
flutter analyze
```

Ejecutar pruebas:

```bash
flutter test
```

Limpiar artefactos generados:

```bash
flutter clean
flutter pub get
```

## Qué Debes Tener en Cuenta

- Los sensores son simulados; no se usa hardware médico real.
- Los datos se generan de forma aleatoria para provocar estados normales y alertas.
- Los isolates no pueden compartir memoria directamente con el hilo principal.
- La comunicación entre isolates se hace con mensajes serializables mediante `SendPort`.
- El `StreamController` principal es broadcast porque más de un widget puede escuchar el mismo flujo.
- Los widgets no administran estado global; solo escuchan streams.
- La lógica de negocio no está en la UI, sino en el caso de uso y las entidades.
- El repositorio se encarga de conectar la fuente de datos con el dominio.
- Se debe detener el monitoreo al salir de la pantalla para liberar isolates y puertos.

## Mejoras Pendientes

- Agregar historial por sensor usando un buffer `List<VitalSign>` acumulado con `scan()` de RxDart.
- Agregar un indicador online/offline por sensor.
- Mostrar gráficas históricas para visualizar tendencias.
- Simular errores de desconexión de sensores para demostrar recuperación.

## Objetivo del Taller

El objetivo no es construir un producto médico real, sino entender cómo manejar flujos de datos en Flutter con una arquitectura clara:

- Isolates producen datos.
- Controllers publican streams.
- Repository abstrae la fuente.
- UseCase orquesta reglas.
- Widgets escuchan y renderizan.

Este proyecto demuestra cómo usar streams de forma ordenada en una app Flutter con datos continuos y múltiples consumidores.
