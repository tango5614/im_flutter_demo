import Flutter
import UIKit
import ImSDK

public class SwiftTimPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tim_plugin", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "tim_plugin_event", binaryMessenger: registrar.messenger())
    
        let instance = SwiftTimPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        channel.setMethodCallHandler(instance.handle(_:result:))
        eventChannel.setStreamHandler(instance)
    }

    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result(UIDevice.current.systemVersion)
        case "initSdk":
            initIM(call: call, result: result)
        case "login":
            login(call: call, result: result)
        case "sendMessage":
            sendMessage(call: call, result: result)
        case "addMessageListener":
            result(nil)
        default:
            result(FlutterError(code: "no method", message: "no method", details: nil))
        }
    }
    
    func initIM(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let config = TIMSdkConfig()
        if let params = call.arguments as? NSDictionary {
            config.sdkAppId = params["appId"] as! Int32
            config.accountType = params["accountType"] as! String
            if let disableLogPrint = params["disableLogPrint"] as? Bool {
                config.disableLogPrint = disableLogPrint
            }
            
            if let logLevel = params["logLevel"] as? Int {
                config.logLevel = TIMLogLevel.init(rawValue: logLevel)!
            }
            
            if let logPath = params["logPath"] as? String {
                config.logPath = logPath
            }
            TIMManager.sharedInstance()?.initSdk(config)
            result(nil)
         }
        result(FlutterError(code: "no argument", message: "no argument", details: nil))
    }
    func login(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let login_param = TIMLoginParam()
        guard let arg = call.arguments as? NSDictionary else {
            result(FlutterError(code: "no argument", message: "no argument", details: nil))
            return
        }
        let identifier = arg["identifier"] as! String
        let userSig = arg["userSig"] as! String
        let appidAt3rd = arg["appidAt3rd"] as! String
        login_param.identifier = identifier
        login_param.userSig = userSig
        login_param.appidAt3rd = appidAt3rd
        TIMManager.sharedInstance()?.login(login_param, succ: {
            result(nil)
        }, fail: { (code, err) in
            result(FlutterError(code: String(code), message: err, details: nil))
        })
    }
    func logout(result: @escaping FlutterResult) {
        TIMManager.sharedInstance()?.logout({
            result("sucess")
        }, fail: { (code, str) in
            result(str ?? "fail")
        })
    }
    func sendMessage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? NSDictionary {
            if let message = arg["message"] as? [NSDictionary] {
                
                guard let receiver = arg["receiver"] as? String else {
                    result(FlutterError(code: "no receiver", message: "no receiver", details: nil))
                    return
                }
                guard let messageType = arg["type"] as? Int else {
                    result(FlutterError(code: "no type", message: "no type", details: nil))
                    return
                }
                guard let conType = TIMConversationType(rawValue: messageType) else {
                    result(FlutterError(code: "conversation type error", message: "conversation type error", details: nil))
                    return
                }
                
                let conversation = TIMManager.sharedInstance()?.getConversation(conType, receiver: receiver)
                let msg = TIMMessage()
                for dic in message {
                    // 文本
                    if let type = dic["type"] as? Int, type == 0 {
                        let elem = TIMTextElem()
                        elem.text = (dic["text"] as? String) ?? ""
                        msg.add(elem)
                    }
                    
                    // 图片
                    if let type = dic["type"] as? Int, type == 1 {
                        let elem = TIMImageElem()
                        elem.path = (dic["path"] as? String) ?? ""
                        msg.add(elem)
                    }
                }
                
                conversation?.send(msg, succ: {
                    result(nil)
                }, fail: { (code, err) in
                    result(FlutterError(code: String(code), message: err, details: nil))
                })
            } else {
                result(FlutterError(code: "no message key", message: "no message key", details: nil))
            }
        } else {
            result(FlutterError(code: "no argument", message: "no argument", details: nil))
        }
    }
}

extension SwiftTimPlugin: FlutterStreamHandler {
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return FlutterError(code: "cancel", message: "cancel", details: nil)
    }
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let listener = IMPMessageListener()
        listener.arguments = arguments
        listener.events = events
        TIMManager.sharedInstance()?.add(listener)
        return nil
    }
}

class IMPMessageListener: NSObject, TIMMessageListener {
    var arguments: Any?
    var events: FlutterEventSink?
    func onNewMessage(_ msgs: [Any]!) {
        var dic: [String: Any] = ["event_name" : "event_name_new_message"]
        if let msgs = msgs as? [TIMMessage] {
            let msgDicArr = msgs.map { (msgItem) -> NSMutableDictionary in
                let dataDic: NSMutableDictionary = [
                    "isSelf": msgItem.isSelf(),
                    "identifier": msgItem.sender()
                ]
                let elems: NSMutableArray = []
                
                for index in 0...msgItem.elemCount() {
                    if let elem = msgItem.getElem(index) as? TIMTextElem {
                        let elemItem: NSDictionary = [
                            "type": 0,
                            "text": elem.text ?? ""
                        ]
                        elems.add(elemItem)
                    } else if let elem = msgItem.getElem(index) as? TIMImageElem {
                        let elemItem: NSDictionary = [
                            "type": 1,
                            "path": elem.path,
                            "compressionLevel": elem.level.rawValue
                        ]
                        elems.add(elemItem)
                    }
                }
                dataDic["msg"] = elems
                return dataDic
            }
            dic["data"] = [
                "msg": msgDicArr
            ]
            events?(dic)
//            var dic: NSDictionary = ["event_name" : "event_name_new_message"]
//            var msg: [NSDictionary] = []
//            for msgItem in msgs {
//                var msgJson = ["": ]
//                for index in 0...(msgItem.elemCount() - 1) {
//                    let msgElem = msgItem.getElem(index)
//                    // 文本
//                    if let elem = msgElem as? TIMTextElem {
//                        let elemItem: NSDictionary = [
//                            "type": 0,
//                            "text": elem.text ?? ""
//                        ]
//                        msg.append(elemItem)
//                    }
//                    // 图片
//                    if let elem = msgElem as? TIMImageElem {
//                        let elemItem: NSDictionary = [
//                            "type": 1,
//                            "text": elem.path
//                        ]
//                        msg.append(elemItem)
//                    }
//                }
//            }
//            dic.setValue(["msg": msgs], forKey: "data")
        }
    }
}
