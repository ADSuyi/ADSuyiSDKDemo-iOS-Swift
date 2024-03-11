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
        var bottomViewHeight:CGFloat = SCREEN_HEIGHT * 0.15
        
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - bottomViewHeight, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = UIColor.white
        
        let logoImageView = UIImageView.init(image: UIImage.init(named: "ADMob_Logo.png"))
        logoImageView.frame = CGRect.init(x: (SCREEN_WIDTH - 135)/2, y: (bottomViewHeight - 46)/2, width: 135, height: 46)
        
        bottomView.addSubview(logoImageView)
        // 5、设置开屏保底逻辑（可选）
        /**
         *功能说明：App在首次启动时，需要先请求获取广告位配置文件后，然后再去请求开屏广告，也就是首次加载开屏广告时需要两次串行网络请求，因此很容易因超时导致开屏广告展示失败。
         *解决方案：为避免开屏超时问题，开放此设置给开发者，开发者可以根据实际需求选择一家广告平台，通过API接口将必需参数传递给Suyi聚合SDK。（该设置只能指定一家广告平台，并且首次启动时只会请求该平台的广告，但App首次开屏广告将不受ADmobile后台控制，包括下载提示，广告位关闭。）
         *该设置仅会在首次加载开屏广告时，SDK会使用开发者传入的参数进行广告请求，同时获取后台配置文件的广告配置信息缓存到本地（首次请求广告平台广告和获取配置信息时并发进行），后续的开屏广告将按照缓存缓存的后台广告位配置顺序进行开屏广告请求。
         *支持穿山甲、优量汇、快手、百度
         */
        splash?.setBottomSplashWithSuyiPosid("73128265daffdd6a1d", platformListId: "37985", platform: "baidu", appId: "ccb60059", appKey: nil, platformPosid: "2058492", renderType: .express)
        // 6、加载全屏的开屏广告
        // splash?.loadAndShow(in: self.window! , withBottomView: nil)
        // 6、加载带有底部视图的开屏广告
        splash?.loadAndShow(in: self.window!, withBottomView: bottomView)
        
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = NavigationViewController(rootViewController: ViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        self.setThirtyPartySdk()
        
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
            //        获取idfa权限 建议获取idfa，否则会影响收益
            if #available(iOS 14.0, *) {
                ATTrackingManager.requestTrackingAuthorization { (status) in
                    
                }
            }
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
        ADSuyiSDK.setLogLevel(.debug)
        // ADSuyiSDK初始化, 需在主线程初始化
        ADSuyiSDK.initWithAppId("3437764") { (error) in
//            if error != nil {
//                NSLog("SDK 初始化失败:%@",error?.localizedDescription ?? "")
//            }
        }
        // 加载开屏
        loadSplash()
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

