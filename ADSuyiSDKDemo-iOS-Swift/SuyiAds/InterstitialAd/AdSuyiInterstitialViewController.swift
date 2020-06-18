//
//  AdSuyiInterstitialViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/17.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiInterstitialViewController: UIViewController, ADSuyiSDKIntertitialAdDelegate {
    func adsy_interstitialAdSucced(toLoad interstitialAd: ADSuyiSDKIntertitialAd) {
        print(#function)
        // 3、展示应用内通知广告
        self.interstitialAd?.loadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        loadInterstitialAd()
    }
    
    func loadInterstitialAd() {
        // 1、初始化插屏广告对象
        self.interstitialAd = ADSuyiSDKIntertitialAd.init()
        self.interstitialAd?.delegate = self
        self.interstitialAd?.controller = self
        self.interstitialAd?.tolerateTimeout = 4
        self.interstitialAd?.posId = "1fbfbb9778d168e5a7"
        // 2、加载插屏广告
        self.interstitialAd?.loadData()
    }
    

}
