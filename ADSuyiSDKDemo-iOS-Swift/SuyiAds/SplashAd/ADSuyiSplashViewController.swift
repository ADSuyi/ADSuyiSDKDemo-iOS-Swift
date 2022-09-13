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
    
    let normalView = ADSuyiSkipView.init()
    let ringView = ADSuyiSkipRingView.init()
    var isReady:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        let loadBtn = UIButton.init()
        loadBtn.layer.cornerRadius = 10;
        loadBtn.clipsToBounds = true;
        loadBtn.backgroundColor = UIColor.white
        loadBtn.setTitle("加载开屏广告", for: .normal)
        loadBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(loadBtn)
        loadBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2-60, width: UIScreen.main.bounds.size.width-60, height: 55)
        loadBtn.addTarget(self, action: #selector(loadSplash), for: .touchUpInside)
        
        let showBtn = UIButton.init()
        showBtn.layer.cornerRadius = 10
        showBtn.clipsToBounds = true
        showBtn.backgroundColor = UIColor.white
        showBtn.setTitle("展示开屏广告", for: .normal)
        showBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(showBtn)
        showBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2+20, width: UIScreen.main.bounds.size.width-60, height: 55)
        showBtn.addTarget(self, action: #selector(showSplash), for: .touchUpInside)
    }
    
    @objc func showSplash() {
        if isReady  {
            splash?.show(in: UIApplication.shared.keyWindow!)

        }else {
            self.view.makeToast("开屏广告未准备完成")
        }
    }
    
    @objc func loadSplash() {
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
        var bottomViewHeight:CGFloat = 0
        if isIPhoneXSeries() {
            bottomViewHeight = SCREEN_HEIGHT * 0.15
        } else {
            bottomViewHeight = SCREEN_HEIGHT - (SCREEN_WIDTH * 960 / 640)
        }
        
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - bottomViewHeight, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = UIColor.white
        
        let logoImageView = UIImageView.init(image: UIImage.init(named: "ADMob_Logo.png"))
        logoImageView.frame = CGRect.init(x: (SCREEN_WIDTH - 135)/2, y: (bottomViewHeight - 46)/2, width: 135, height: 46)
        
        bottomView.addSubview(logoImageView)
        // 5、加载全屏的开屏广告
        // splash?.loadAndShow(in: self.window! , withBottomView: nil)
        // 5、加载带有底部视图的开屏广告
        if  SetConfigManager.shared().isCustomSkipView{
            // 示例1 自定义跳过按钮
            splash?.skipView = normalView
            // 示例2 圆弧跳过
//            splash?.skipView = ringView;
        }
        splash?.load(in: UIApplication.shared.keyWindow!, withBottomView: bottomView)
        
    }
    func adsy_splashAdSuccess(toLoad splashAd: ADSuyiSDKSplashAd) {
        print(#function)
        isReady = true
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
