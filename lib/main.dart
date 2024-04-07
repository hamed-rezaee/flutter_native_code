import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: HomePage(),
          ),
        ),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const MethodChannel _methodChannel =
      MethodChannel('com.example.flutter_native_code/method_channel');
  static const EventChannel _eventChannel =
      EventChannel('com.example.flutter_native_code/pressure_channel');

  String _sensorAvailable = 'Sensor not available';
  double _pressure = 0;

  StreamSubscription? _streamSubscription;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Sensor Available: $_sensorAvailable'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSensorAvailable,
                child: const Text('Get sensor availability'),
              ),
              const SizedBox(height: 32),
              Text('Sensor Pressure: $_pressure (hPa)'),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _getSensorPressure,
                    child: const Text('Get sensor pressure'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _stopSensorPressure,
                    child: const Text('Stop sensor pressure'),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  Future<void> _isSensorAvailable() async {
    try {
      final bool result =
          await _methodChannel.invokeMethod('isSensorAvailable');

      setState(() => _sensorAvailable = result.toString());
    } on Exception catch (e) {
      dev.log('Failed to get sensor availability.', error: e);

      setState(
        () => _sensorAvailable = 'failed to get sensor availability.',
      );
    }
  }

  void _getSensorPressure() async {
    _streamSubscription = _eventChannel
        .receiveBroadcastStream()
        .listen((event) => setState(() => _pressure = event));
  }

  void _stopSensorPressure() {
    _streamSubscription?.cancel();

    setState(() => _pressure = 0);
  }
}
