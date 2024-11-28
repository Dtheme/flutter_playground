//
//  Tool.swift
//  Runner
//
//  Created by dzw on 2023/12/15.
//

import UIKit

class Tool: NSObject {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(base: selected)
                }
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            return base
        }
    
    class func showSystemAlert(title:String, message:String) {
        // 创建 UIAlertController
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        // 添加确定按钮
        let okAction = UIAlertAction(
            title: "确定",
            style: .default,
            handler: { action in
                // 处理确定按钮点击事件
                print("确定按钮被点击了。")
            }
        )
        alertController.addAction(okAction)
        
        // 在视图控制器中显示弹窗
        Tool.topViewController()?.present(alertController, animated: true)
    }
}
