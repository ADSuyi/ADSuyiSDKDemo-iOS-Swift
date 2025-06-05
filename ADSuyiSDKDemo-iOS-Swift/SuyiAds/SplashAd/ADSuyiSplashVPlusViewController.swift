//
//  ADSuyiSplashVPlusViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by Erik on 2021/4/28.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit

class ADSuyiSplashVPlusViewController: UIViewController,ADSuyiSDKSplashAdDelegate {

    var splash: ADSuyiSDKSplashAd?
    let normalView = ADSuyiSkipView.init()
    let ringView = ADSuyiSkipRingView.init()
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
        // 设置代理
        splash?.delegate = self
        // 2、设置广告位id
        splash?.posId = "73128265daffdd6a1d"
        // 设置广告请求超时时间
        splash?.tolerateTimeout = 4
        
        
        // 3、设置广告背景颜色，推荐设置为启动图的平铺颜色
        let bgImage = UIImage.init(named: "750x1334.png")
        splash?.backgroundColor = UIColor.adsy_get(with: bgImage!, withNewSize: UIScreen.main.bounds.size)
    
        // 设置控制器，用于落地页弹出
        splash?.controller = self
        
        // 4、初始化底部视图
        var bottomViewHeight:CGFloat = SCREEN_HEIGHT * 0.15
        
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - bottomViewHeight, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = UIColor.white
        
        let logoImageView = UIImageView.init(image: UIImage.init(named: "ADMob_Logo.png"))
        logoImageView.frame = CGRect.init(x: (SCREEN_WIDTH - 135)/2, y: (bottomViewHeight - 46)/2, width: 135, height: 46)
        
        bottomView.addSubview(logoImageView)
        // 5、加载全屏的开屏广告
        // splash?.loadAndShow(in: self.window! , withBottomView: nil)
        // 5、加载带有底部视图的开屏广告
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
