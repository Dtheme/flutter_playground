import UIKit
import Flutter

let onNativeConfirm = "onNativeConfirm"
let onNativeCancel = "onNativeCancel"


@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "platform_channel", binaryMessenger: controller.binaryMessenger)
        let nativeCallFlutterChannel = FlutterMethodChannel(name: "iOS_NATIVE_CHANNEL", binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod("myFlutterFunction", arguments: "Hello from iOS")

        channel.setMethodCallHandler { (call, result) in
            if call.method == "openNativePage" {
                self.openNativePage()
                result(nil)
            }else if call.method == "showSystemAlert" {
                guard let arguments = call.arguments as? [String: Any],
                      let title = arguments["title"] as? String,
                      let message = arguments["message"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
                    return
                }
                
                // 在 iOS 方法中调用系统弹窗，并传递确定和取消按钮回调
                self.showSystemAlert(title: title, message: message, onConfirm: {
                    // 在确定按钮回调中，向 Flutter 返回结果
                    result(onNativeConfirm)
                }, onCancel: {
                    // 在取消按钮回调中，向 Flutter 返回结果
                    result(onNativeCancel)
                })
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
    }
    
    func openNativePage() {
        let vc = TestVC() // 这里替换成你的原生页面
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        vc.text = "这是传给原生页面的参数"
        window?.rootViewController?.present(navi, animated: true, completion: nil)
    }
    
    func showToolAlert(title:String, message:String)->Void{
        Tool.showSystemAlert(title:title, message:message)
    }
    
    func showSystemAlert(title: String, message: String, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
          // 调用确定按钮回调
          onConfirm()
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
          // 调用取消按钮回调
          onCancel()
        }
        alertController.addAction(cancelAction)
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
      }
}

