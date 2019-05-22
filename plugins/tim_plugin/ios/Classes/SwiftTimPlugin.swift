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
            result(())
         }
        result(FlutterError(code: "no argument", message: "no argument", details: nil))
    }
    func login(result: @escaping FlutterResult) {
        let login_param = TIMLoginParam()
        login_param.identifier = "t_4"
        login_param.userSig = "eJxlz1FPgzAQwPF3PgXpq0bbo8Vp4oPZZCNhcwTRuJcGaTc7BxToHMz43Y2osYn3*vtfLvfuuK6L7qPkLMvzal8abnotkXvlIoxO-1BrJXhmuNeIfyg7rRrJs7WRzYCEMQYY240SsjRqrX4Kw6mFrXjlw4XvbYoxEI8CsxO1GXB*m47DeFJkYpokXTLrIagjlpWL1It26WEVqJM7fTM7zqF-JhqCKg43j9tl7T-p44PP-CLf1Yuun46D6rxakSXdlgJe9iGBSdxG4bV10qhC-r4zojDyLi8sfZNNq6pyCAATRsDDX4OcD*cTEA9cNA__"
        login_param.appidAt3rd = "1400213425"
        TIMManager.sharedInstance()?.login(login_param, succ: {
            result("succ")
        }, fail: { (code, err) in
            result("err")
        })
    }
    func logout(result: @escaping FlutterResult) {
        TIMManager.sharedInstance()?.logout({
            result("sucess")
        }, fail: { (code, str) in
            result(str ?? "fail")
        })
    }
}
