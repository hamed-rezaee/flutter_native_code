import 'dart:developer' as dev;
import 'dart:math';

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

  String sensorAvailable = 'Sensor not available';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Sensor Available: $sensorAvailable'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSensorAvailable,
                child: const Text('Get sensor availability'),
              )
            ],
          ),
        ),
      );

  Future<void> _isSensorAvailable() async {
    try {
      final bool result =
          await _methodChannel.invokeMethod('isSensorAvailable');

      setState(() => sensorAvailable = result.toString());
    } on Exception catch (e) {
      dev.log('Failed to get sensor availability.', error: e);

      setState(
        () => sensorAvailable = 'failed to get sensor availability.',
      );
    }
  }
}
