//
//  AppDelegate.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/5/27.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ADSuyiSDKSplashAdDelegate {
    
    var window: UIWindow?
    var splash: ADSuyiSDKSplashAd?
    
    
    func loadSplash() {
        if splash != nil {
            return
        }
        // 1、初始化开屏广告对象
        splash = ADSuyiSDKSplashAd.init()
        splash?.delegate = self
        splash?.tolerateTimeout = 4
        // 设置控制器，用于落地页弹出
        splash?.controller = self.window?.rootViewController
        // 2、设置广告位id
        splash?.posId = "73128265daffdd6a1d"
        
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
        
//        获取idfa权限 建议获取idfa，否则会影响收益
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                
            }
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        self.setThirtyPartySdk()
        // 加载开屏
        loadSplash()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // 热启动进入前台 加载广告
        self.loadSplash()
        //   进入前台 小说控制事件结束
        application.endReceivingRemoteControlEvents()
    }
    
//    MARK:小说SDK后台播放控制
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        switch event?.subtype {
        case .remoteControlPlay:
            ADSuyiSDKContainAd.replay()
            break
        case .remoteControlPause:
            ADSuyiSDKContainAd.pause()
            break
        case .remoteControlPreviousTrack:
            ADSuyiSDKContainAd.last()
            break
        case .remoteControlNextTrack:
            ADSuyiSDKContainAd.next()
            break
        case .remoteControlTogglePlayPause:
            ADSuyiSDKContainAd.smallWindowPause()
            break
        default:
            break
        }
    }
    
    func adsy_splashAdClosed(_ splashAd: ADSuyiSDKSplashAd) {
        print(#function)
        splash = nil
    }
    
    func adsy_splashAdFail(toPresentScreen splashAd: ADSuyiSDKSplashAd, failToPresentScreen error: ADSuyiAdapterErrorDefine) {
        print(#function)
        splash = nil
    }

    // MARK: private method
    func showAgreePrivacy() {
        let alertVc = UIAlertController.init(title: "温馨提示", message: "亲爱的用户，欢迎您信任并使用【】，我们依据相关法律制定了《用户协议》和《隐私协议》帮你你了解我们手机，使用，存储和共享个人信息情况，请你在点击之前仔细阅读并理解相关条款。\n1、在使用我们的产品和服务时，将会提供与具体功能有关的个法人信息（可能包括身份验证，位置信息，设备信息和操作日志等）\n2、我们会采用业界领先的安全技术来保护你的个人隐私，未经授权许可我们不会讲上述信息共享给任何第三方或用于未授权的其他用途。\n如你同意请点击同意按钮并继续。", preferredStyle: UIAlertController.Style.alert)
        
        let cancle = UIAlertAction.init(title: "不同意", style: UIAlertAction.Style.cancel) { [self] (action) in
            let alert = UIAlertController.init(title: "", message: "点击同意才能使用该App服务", preferredStyle: UIAlertController.Style.alert)
            let sure = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default) { [self] (action) in
                window?.rootViewController?.present(alertVc, animated:true, completion: nil)
            }
            alert.addAction(sure)
            window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        let agree = UIAlertAction.init(title: "同意并继续", style: UIAlertAction.Style.default) { (action) in
            // 记录是否第一次启动
            self.writeAppLoad()
            // 用户同意协议 初始化
            self.initADSuyiSDK()
        }
        
        alertVc.addAction(cancle)
        alertVc.addAction(agree)
        window?.rootViewController?.present(alertVc, animated: true, completion: nil)
        
    }
    
    func setThirtyPartySdk() {
        if isFirstLoad() {
            self.showAgreePrivacy()
        }else{
            self.initADSuyiSDK()
        }
    }
    
    func initADSuyiSDK() {
        ADSuyiSDK.setLogLevel(ADSuyiKitLogLevel(rawValue: 1 << 3)!)
        ADSuyiSDK.initWithAppId("3437764") { (error) in
//            if error != nil {
//                NSLog("SDK 初始化失败:%@",error?.localizedDescription ?? "")
//            }
        }
    }
    
    // MARK: helper
    
    func writeAppLoad() {
        let userDefault = UserDefaults.standard
        userDefault.set("yes", forKey: "isFirstLoad")
        userDefault.synchronize()
    }
    
    func isFirstLoad() -> Bool {
        let userDefault = UserDefaults.standard
        if (userDefault.object(forKey: "isFirstLoad") != nil)  {
            return false
        }
        return true
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

