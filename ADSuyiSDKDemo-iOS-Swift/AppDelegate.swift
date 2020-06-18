//
//  AppDelegate.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/5/27.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ADSuyiSDKSplashAdDelegate {
    
    var window: UIWindow?
    var splash: ADSuyiSDKSplashAd?
    
    
    func loadSplash() {
        // 1、初始化开屏广告对象
        splash = ADSuyiSDKSplashAd.init()
        splash?.delegate = self
        splash?.tolerateTimeout = 4
        // 设置控制器，用于落地页弹出
        splash?.controller = self.window?.rootViewController
        // 2、设置广告位id
        splash?.posId = "d11c2ef29dcb7e6e62"
        
        // 3、设置广告背景颜色，推荐设置为启动图的平铺颜色
        let bgImage = UIImage.init(named: "750x1334.png")
        splash?.backgroundColor = UIColor.adsy_get(with: bgImage!, withNewSize: UIScreen.main.bounds.size)
        
        // 4、初始化底部视图
        var bottomViewHeight:CGFloat = 0
        if isIPhoneXSeries() {
            bottomViewHeight = SCREEN_WIDTH * 0.25
        } else {
            bottomViewHeight = SCREEN_WIDTH - (SCREEN_WIDTH * 960 / 640)
        }
        
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - bottomViewHeight, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = UIColor.white
        
        let logoImageView = UIImageView.init(image: UIImage.init(named: "ADMob_Logo.png"))
        logoImageView.frame = CGRect.init(x: (SCREEN_WIDTH - 135)/2, y: (bottomViewHeight - 46)/2, width: 135, height: 46)
        
        bottomView.addSubview(logoImageView)
        // 5、加载全屏的开屏广告
        // splash?.loadAndShow(in: self.window! , withBottomView: nil)
        // 5、加载带有底部视图的开屏广告
        splash?.loadAndShow(in: self.window!, withBottomView: bottomView)
        
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        ADSuyiSDK.setLogLevel(ADSuyiKitLogLevel(rawValue: 1 << 3)!)
        ADSuyiSDK.initWithAppId("3993370") { (error) in
            if error != nil {
                NSLog("SDK 初始化失败:%@",error?.localizedDescription ?? "")
            }
        }
        // 加载开屏
        loadSplash()
        
        return true
    }
    
    func adsy_splashAdClosed(_ splashAd: ADSuyiSDKSplashAd) {
        print(#function)
        splash = nil
    }
    
    func adsy_splashAdFail(toPresentScreen splashAd: ADSuyiSDKSplashAd, failToPresentScreen error: ADSuyiAdapterErrorDefine) {
        print(#function)
        splash = nil
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

