//
//  AppDelegate.swift
//  VPN
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 layne. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        
        window?.makeKeyAndVisible()
        
        initConfig()
        return true
    }
    
    func initConfig() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        
        // 前景色
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.6))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setMaximumDismissTimeInterval(5)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        // 最小尺寸
        SVProgressHUD.setMinimumSize(CGSize(width: 70, height: 70))
        // 圆角
        SVProgressHUD.setCornerRadius(5)
        // 字体大小
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 15))
        // 动画类型
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setRingRadius(25)
        // 用户是否可以做其他操作
        SVProgressHUD.setDefaultMaskType(.none)
        // 提示图片大小
        SVProgressHUD.setImageViewSize(CGSize.init(width: 50, height: 50))
    }




}

