package com.example.flutter_native_code

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.example.flutter_native_code/method_channel"
    private val EVENT_CHANNEL_NAME = "com.example.flutter_native_code/pressure_channel"

    private var methodChannel: MethodChannel? = null
    private lateinit var sensorManager: SensorManager

    private var eventChannel: EventChannel? = null
    private var eventStreamHandler: StreamHandler? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        setupMethodChannels(this, flutterEngine.dartExecutor.binaryMessenger)
        setupEventChannels(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    private fun setupMethodChannels(context: Context, messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "isSensorAvailable") {
                result.success(sensorManager.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setupEventChannels(context: Context, messenger: BinaryMessenger) {
        eventChannel = EventChannel(messenger, EVENT_CHANNEL_NAME)
        eventStreamHandler = StreamHandler(Sensor.TYPE_PRESSURE, sensorManager)

        eventChannel?.setStreamHandler(eventStreamHandler)
    }

    private fun teardownChannels() {
        methodChannel?.setMethodCallHandler(null)
        eventChannel?.setStreamHandler(null)
    }

    override fun onDestroy() {
        teardownChannels()

        super.onDestroy()
    }
}
