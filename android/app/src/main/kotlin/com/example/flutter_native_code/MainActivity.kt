package com.example.flutter_native_code

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.example.flutter_native_code/method_channel"

    private var methodChannel: MethodChannel? = null

    private lateinit var sensorManager: SensorManager

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    private fun setupChannels(context: Context, messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        methodChannel!!.setMethodCallHandler { call, result ->
            if (call.method == "isSensorAvailable") {
                result.success(sensorManager.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun teardownChannels() {}

    override fun onDestroy() {
        teardownChannels()

        super.onDestroy()
    }
}
