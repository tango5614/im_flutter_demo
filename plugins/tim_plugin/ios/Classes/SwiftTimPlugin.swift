import Flutter
import UIKit
import ImSDK

public class SwiftTimPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tim_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftTimPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    channel.setMethodCallHandler(instance.handle(_:result:))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result(UIDevice.current.systemVersion)
    case "initSdk":
        initIM(call: call, result: result)
    case "login":
        login(result: result)
    case "sendMessage":
        sendMessage(call: call, result: result)
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
    func login(result: @escaping FlutterResult) {
        let login_param = TIMLoginParam()
        login_param.identifier = "t_2"
        login_param.userSig = "eJxlj8FOhDAURfd8BWGrMW2hDpi4KHUMI5pIZmDBpiHTQjvjQC1VBOO-G1EjiW97zs29791xXdfb3W8vqv2*e2kts6MWnnvlesA7-4NaK84qy3zD-0HxppURrKqtMDOEGGMEwNJRXLRW1erHsAwtYM*PbG74TgcAIOgHCC8V1czwYZ3TTXYjRylpHB-KYU3gKcFhFcGByGFlziJak2LrH8lu0vypJ5smx7eP5ZjRcqWEDA9xQTuZpFMaIZwmWTy1zXMRXGpzl2fXi0qrTuL3nTBAoR8sB70K06uunQUEIIbIB1-nOR-OJ8GXW6c_"
        login_param.appidAt3rd = "1400213425"
        TIMManager.sharedInstance()?.login(login_param, succ: {
            result("succ")
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
                let msg = TIMMessage()
                for dic in message {
                    // 文本
                    if let type = dic["type"] as? Int, type == 0 {
                        let elem = TIMTextElem()
                        elem.text = dic["text"] as! String
                        msg.add(elem)
                    }
                    
                    // 图片
                    if let type = dic["type"] as? Int, type == 1 {
                        let elem = TIMImageElem()
                        elem.path = dic["path"] as! String
                        msg.add(elem)
                    }
                }
                let receiver = arg["receiver"] as! [String]
                TIMManager.sharedInstance()?.send(msg, toUsers: receiver, succ: {
                    result(nil)
                }, fail: { (code, message, detail) in
                    result(FlutterError(code: String(code), message: message, details: nil))
                })
            }
        }
    }
}
