package com.youareok.tim_plugin

import android.util.Log
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.tencent.imsdk.*
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.Serializable


class TimPlugin private constructor(val registrar: Registrar) : MethodCallHandler, EventChannel.StreamHandler, TIMMessageListener {

    companion object {
        private const val METHOD_CHANNEL_NAME = "tim_plugin"
        private const val EVENT_CHANNEL_NAME = "tim_plugin_event"
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME)
            channel.setMethodCallHandler(TimPlugin(registrar))
        }
    }

    private var mEventChannel: EventChannel? = null
    private var mEventSink: EventChannel.EventSink? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d("TimPlugin", "onMethodCall call.method:" + call.method)
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
            accoutType = call.argument<String>("accountType") ?: "36862"
            enableLogPrint(!(call.argument<Boolean>("disableLogPrint") ?: false))
            logLevel = call.argument<Int>("logLevel") ?: TIMLogLevel.DEBUG
            logPath = call.argument("logPath")
        }
        TIMManager.getInstance().init(registrar.context(), config);
        result.success(null)
    }

    private fun login(call: MethodCall, result: MethodChannel.Result) {
        TIMManager.getInstance().login(call.argument("identifier"),
                call.argument("userSig"), object : TIMCallBack {
            override fun onError(p0: Int, p1: String?) {
                result.error(p0.toString(), p1, null)
            }

            override fun onSuccess() {
                result.success(null)
            }
        })
    }

    private fun logout(call: MethodCall, result: Result) {
        //登出
        TIMManager.getInstance().logout(object : TIMCallBack {
            override fun onError(code: Int, desc: String) {
                //错误码 code 和错误描述 desc，可用于定位请求失败原因
                //错误码 code 列表请参见错误码表
                result.error(code.toString(), desc, null)
            }

            override fun onSuccess() {
                //登出成功
                result.success(null)
            }
        })
    }

    private fun sendMessage(call: MethodCall, result: Result) {
        val type = call.argument<Int>("type")
        val message = call.argument<List<Map<String, Any>>>("message")
        val receiver = call.argument<String>("receiver")
        val conversation = when (type) {
            //C2C
            1 -> {
                TIMManager.getInstance().getConversation(TIMConversationType.C2C, receiver)
            }
            //GROUP
            2 -> {
                TIMManager.getInstance().getConversation(TIMConversationType.Group, receiver)
            }
            //SYSTEM
            3 -> {
                TIMManager.getInstance().getConversation(TIMConversationType.System, receiver)
            }
            else -> {
                null
            }
        }
        if (conversation == null) {
            result.error("1001", "no conversation create", null)
            return
        }
        val msg = TIMMessage()
        message?.forEach {
            val elem = when (it["type"]) {
                //image
                1 -> {
                    val imageElem = TIMImageElem()
                    imageElem.path = it["path"] as String
                    imageElem.level = it["level"] as Int
                    imageElem
                }
                //text
                0 -> {
                    val textMessage = TIMTextElem()
                    textMessage.text = it["text"] as String?
                    textMessage
                }
                else -> {
                    null
                }
            }
            elem?.let {
                msg.addElement(it)
            }
        }
        conversation.sendMessage(msg, object : TIMValueCallBack<TIMMessage> {
            override fun onSuccess(p0: TIMMessage?) {
                result.success(null)
            }

            override fun onError(p0: Int, p1: String?) {
                result.error(p0.toString(), p1, null)
            }
        })
    }

    private fun addMessageListener(call: MethodCall, result: Result) {
        initEventChannel()
        TIMManager.getInstance().removeMessageListener(this)
        TIMManager.getInstance().addMessageListener(this)
        result.success(null)
    }

    private fun initEventChannel() {
        if (mEventChannel == null) {
            mEventChannel = EventChannel(registrar.messenger(), EVENT_CHANNEL_NAME)
            mEventChannel!!.setStreamHandler(this)
        }
    }


    override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
        mEventSink = p1
    }

    override fun onCancel(p0: Any?) {
        mEventSink = null
    }

    override fun onNewMessages(p0: MutableList<TIMMessage>?): Boolean {
        p0?.let {


            mEventSink?.let {
                val list = mutableListOf<PTIMMessage>()
                p0.forEach {
                    val msg = mutableListOf<PTIMElement>()
                    for (i in 0 until it.elementCount) {
                        val e = it.getElement(i.toInt())
                        val mE = when {
                            e is TIMTextElem -> {
                                PTIMTextElement((e).text)
                            }
                            e is TIMImageElem -> {
                                val images = mutableListOf<PTIMImage>()
                                e.imageList.forEach {
                                    images.add(PTIMImage(it.type.value(),
                                            it.size.toInt(), it.height.toInt(), it.width.toInt(), it.url, it.uuid))
                                }
                                PTIMImageElement(images)
                            }
                            else -> {
                                null
                            }
                        }
                        mE?.let {
                            msg.add(mE)
                        }
                    }
                    list.add(PTIMMessage(it.sender, msg = msg, isSelf = it.isSelf))
                }
                val gson = Gson()
                val jsonObject = JsonObject()
                jsonObject.addProperty("event_name", "event_name_new_message")
                jsonObject.add("data", JsonObject().apply {
                    add("msg", gson.toJsonTree(list))
                })
                val json = gson.toJson(jsonObject)
                it.success(json)
                Log.d("onNewMessage", "reuslt:" + json)
            }
        }
        return true
    }


}

open class PTIMElement() : Serializable
class PTIMTextElement(val text: String, val type: Int = 0) : PTIMElement()
/**
 *  int type;
int size;
int height;
int width;
String url;
String uuid;
 */
class PTIMImageElement(val images: List<PTIMImage>, val type: Int = 1) : PTIMElement()

class PTIMImage(val type: Int, val size: Int, val height: Int, val width: Int,
                val url: String, val uuid: String) : Serializable

class PTIMMessage(val identifier: String, val msg: List<PTIMElement>, val isSelf: Boolean) : Serializable

/**
 * identifier、nickname、faceURL、customInfo
 */
class PTIMUserProfile(val identifier: String, val nickname: String, val faceURL: String, val customInfo: Map<String, ByteArray>) : Serializable