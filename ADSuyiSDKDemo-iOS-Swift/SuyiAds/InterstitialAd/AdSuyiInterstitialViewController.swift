//
//  AdSuyiInterstitialViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/17.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiInterstitialViewController: UIViewController, ADSuyiSDKIntertitialAdDelegate {
    func adsy_interstitialAdCloseLandingPage(_ interstitialAd: ADSuyiSDKIntertitialAd) {
        
    }
    
    func adsy_interstitialAdSucced(toLoad interstitialAd: ADSuyiSDKIntertitialAd) {
        print(#function)
        let extInfo = interstitialAd.adsy_extInfo()
        print("ecpm=", extInfo?.ecpm ?? "")
        print("ecpmType=", extInfo?.ecpmType.rawValue ?? 0)
        // 3、展示插屏广告
        isReady = true
        self.view.makeToast("插屏广告准备完成")
    }
    
    func adsy_interstitialAdFailed(toLoad interstitialAd: ADSuyiSDKIntertitialAd, error: ADSuyiAdapterErrorDefine) {
        print(#function)
        self.interstitialAd = nil
    }
    
    func adsy_interstitialAdDidPresent(_ interstitialAd: ADSuyiSDKIntertitialAd) {
        print(#function)
    }
    
    func adsy_interstitialAdFailed(toPresent interstitialAd: ADSuyiSDKIntertitialAd, error: Error) {
        print(#function)
    }
    
    func adsy_interstitialAdDidClick(_ interstitialAd: ADSuyiSDKIntertitialAd) {
        print(#function)
    }
    
    func adsy_interstitialAdDidClose(_ interstitialAd: ADSuyiSDKIntertitialAd) {
        print(#function)
        self.interstitialAd = nil
    }
    
    func adsy_interstitialAdExposure(_ interstitialAd: ADSuyiSDKIntertitialAd) {
        print(#function)
    }
    
    var interstitialAd : ADSuyiSDKIntertitialAd?
    var isReady:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        let loadBtn = UIButton.init()
        loadBtn.layer.cornerRadius = 10;
        loadBtn.clipsToBounds = true;
        loadBtn.backgroundColor = UIColor.white
        loadBtn.setTitle("加载插屏广告", for: .normal)
        loadBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(loadBtn)
        loadBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2-60, width: UIScreen.main.bounds.size.width-60, height: 55)
        loadBtn.addTarget(self, action: #selector(loadInterstitialAd), for: .touchUpInside)
        
        let showBtn = UIButton.init()
        showBtn.layer.cornerRadius = 10
        showBtn.clipsToBounds = true
        showBtn.backgroundColor = UIColor.white
        showBtn.setTitle("展示插屏广告", for: .normal)
        showBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(showBtn)
        showBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2+20, width: UIScreen.main.bounds.size.width-60, height: 55)
        showBtn.addTarget(self, action: #selector(showInterstitialAd), for: .touchUpInside)
    }
    
    @objc func loadInterstitialAd() {
        // 1、初始化插屏广告对象
        self.interstitialAd = ADSuyiSDKIntertitialAd.init()
        self.interstitialAd?.delegate = self
        self.interstitialAd?.controller = self
        self.interstitialAd?.tolerateTimeout = 4
        self.interstitialAd?.posId = "9535af29514e548fe0"
        if SetConfigManager.shared().fullAdAdScenceId != "" {
            self.interstitialAd?.scenesId = SetConfigManager.shared().fullAdAdScenceId
        }
        // 2、加载插屏广告
        self.interstitialAd?.loadData()
    }
    
    @objc func showInterstitialAd() {
        if isReady  {
            self.interstitialAd?.show()
        }else {
            self.view.makeToast("插屏广告未准备完成")
        }
    }
    

}
