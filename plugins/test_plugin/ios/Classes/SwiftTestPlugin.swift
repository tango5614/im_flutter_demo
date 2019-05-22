import Flutter
import UIKit
import ImSDK

public class SwiftTestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "test_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftTestPlugin()
    channel.setMethodCallHandler(instance.handle(_:result:))
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result(UIDevice.version())
    case "initSdk":
        initIM(result: result)
    case "login":
        login(result: result)
    default:
        result(FlutterError(code: "no method", message: "no method", details: nil))
    }
  }
    func initIM(result: @escaping FlutterResult) {
        let config = TIMSdkConfig()
        config.sdkAppId = 1400213425
        config.accountType = "36862"
        config.disableLogPrint = false
        config.logLevel = .LOG_DEBUG
        TIMManager.sharedInstance()?.initSdk(config)
        result("initial finished")
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
}

