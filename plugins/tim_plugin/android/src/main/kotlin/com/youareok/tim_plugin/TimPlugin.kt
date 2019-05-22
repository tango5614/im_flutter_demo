package com.youareok.tim_plugin

import android.util.Log
import com.tencent.imsdk.TIMLogLevel
import com.tencent.imsdk.TIMManager
import com.tencent.imsdk.TIMSdkConfig
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.Serializable

class TimPlugin private constructor(val registrar: Registrar) : MethodCallHandler {

    companion object {

        private const val METHOD_CHANNEL_NAME = "tim_plugin"
        private const val EVENT_CHANNEL_NAME = "tim_plugin_event"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME)
            channel.setMethodCallHandler(TimPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d("TimPlugin","onMethodCall call.method:"+call.method)
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initSdk" -> {
                initSdk(call, result)
            }
            "login" -> {
                login(call, result)
            }
            "logout" -> {
                logout(call, result)
            }

            "sendMessage" -> {
                sendMessage(call, result)
            }

            "addMessageListener" -> {
                addMessageListener(call, result)
            }

            "createGroup" -> {
                result.notImplemented()
            }

            else -> {
                result.notImplemented()
            }
        }
    }


    private fun initSdk(call: MethodCall, result: Result) {
        val appId = call.argument<Int>("appId")
        if (appId == null) {
            result.error("1001", "not input appId for TIM sdk", null)
            return
        }
        val config = TIMSdkConfig(appId)
        config.apply {
            accoutType = call.argument<String>("accountType")?:"36862"
            enableLogPrint(!(call.argument<Boolean>("disableLogPrint")?:false))
            logLevel = call.argument<Int>("logLevel")?:TIMLogLevel.DEBUG
            logPath = call.argument("logPath")
        }
        TIMManager.getInstance().init(registrar.context(), config);
        result.success(null)
    }

    private fun login(call: MethodCall, result: MethodChannel.Result) {
//        TIMManager.getInstance().login(call.argument("indentifier",
    }

    private fun logout(call: MethodCall, result: Result) {

    }

    private fun sendMessage(call: MethodCall, result: Result) {

    }

    private fun addMessageListener(call: MethodCall, result: Result) {

    }

}
