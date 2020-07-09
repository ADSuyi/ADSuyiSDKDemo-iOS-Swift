//
//  AdSuyiFullScreenVodViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/17.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiFullScreenVodViewController: UIViewController, ADSuyiSDKFullScreenVodAdDelegate {
    func adsy_fullScreenVodAdSucced(toLoad fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
    }
    
    func adsy_fullScreenVodAdReady(toPlay fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
        // 3、展示全屏视频广告
        self.fullScreenVod?.show()
    }
    
    func adsy_fullScreenVodAdSuccess(toLoadVideo fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
    }
    
    func adsy_fullScreenVodAdFailed(toLoad fullScreenVodAd: ADSuyiSDKFullScreenVodAd, error: ADSuyiAdapterErrorDefine) {
        print(#function)
        self.fullScreenVod = nil
    }
    
    func adsy_fullScreenVodAdDidPresent(_ fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
    }
    
    func adsy_fullScreenVodAdFail(toPresent fullScreenVodAd: ADSuyiSDKFullScreenVodAd, error: Error) {
        print(#function)
    }
    
    func adsy_fullScreenVodAdDidClick(_ fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
    }
    
    func adsy_fullScreenVodAdDidClose(_ fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
        self.fullScreenVod = nil
    }
    
    func adsy_fullScreenVodAdExposure(_ fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
    }
    
    func adsy_fullScreenVodAdPlayComplete(_ fullScreenVodAd: ADSuyiSDKFullScreenVodAd, didFailed error: Error?) {
        print(#function)
    }
    

    
    var fullScreenVod : ADSuyiSDKFullScreenVodAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        loadFullScreenVodAd()
    }
    
    func loadFullScreenVodAd() {
        // 1、初始化全屏视频
        self.fullScreenVod = ADSuyiSDKFullScreenVodAd.init()
        self.fullScreenVod?.delegate = self
        self.fullScreenVod?.controller = self
        self.fullScreenVod?.tolerateTimeout = 5
        self.fullScreenVod?.posId = "f3953777bc833957d8"
        // 2、加载全屏视频广告
        self.fullScreenVod?.loadData()
    }
    

}
