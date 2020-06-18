//
//  ADSuyiSplashViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/16.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class ADSuyiSplashViewController: UIViewController, ADSuyiSDKSplashAdDelegate {

    
    var splash: ADSuyiSDKSplashAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        // 加载开屏
        loadSplash()
    }
    
    func loadSplash() {
        // 1、初始化开屏广告对象
        splash = ADSuyiSDKSplashAd.init()
        // 2、设置代理
        splash?.delegate = self
        // 3、设置广告位id
        splash?.posId = "d11c2ef29dcb7e6e62"
        // 4、设置广告请求超时时间
        splash?.tolerateTimeout = 4
        
        // 5、设置广告背景颜色，推荐设置为启动图的平铺颜色
        let bgImage = UIImage.init(named: "750x1334.png")
        let bgColor = UIColor.init(patternImage: bgImage!)
        splash?.backgroundColor = bgColor
        // 6、设置控制器，用于落地页弹出
        splash?.controller = self
        
        // 7、初始化底部视图
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
        // 7、加载全屏的开屏广告
        // splash?.loadAndShow(in: self.window! , withBottomView: nil)
        // 7、加载带有底部视图的开屏广告
        splash?.loadAndShow(in: UIApplication.shared.keyWindow!, withBottomView: bottomView)
        
    }
    
    func adsy_splashAdClosed(_ splashAd: ADSuyiSDKSplashAd) {
        print(#function)
        splash = nil
    }
    
    func adsy_splashAdFail(toPresentScreen splashAd: ADSuyiSDKSplashAd, failToPresentScreen error: ADSuyiAdapterErrorDefine) {
        print(#function)
        splash = nil
    }

}
