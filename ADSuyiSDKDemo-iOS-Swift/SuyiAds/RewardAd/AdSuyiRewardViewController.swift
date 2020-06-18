//
//  AdSuyiRewardViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/16.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiRewardViewController: UIViewController, ADSuyiSDKRewardvodAdDelegate {
    func adsy_rewardvodAdLoadSuccess(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdReady(toPlay rewardvodAd: ADSuyiSDKRewardvodAd) {
        if self.rewardAd?.rewardvodAdIsReady() ?? false {
            self.rewardAd?.show()
        }
    }
    
    func adsy_rewardvodAdVideoLoadSuccess(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdWillVisible(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdDidVisible(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdDidClose(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        rewardAd = nil
    }
    
    func adsy_rewardvodAdDidClick(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdDidPlayFinish(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdDidRewardEffective(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdFail(toLoad rewardvodAd: ADSuyiSDKRewardvodAd, errorModel: ADSuyiAdapterErrorDefine) {
        rewardAd = nil
    }
    
    func adsy_rewardvodAdPlaying(_ rewardvodAd: ADSuyiSDKRewardvodAd, errorModel: ADSuyiAdapterErrorDefine) {
        
    }
    

    var rewardAd : ADSuyiSDKRewardvodAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        loadRewardAd()
    }
    
    
    func loadRewardAd() {
        // 1、初始化激励视频广告对象
        self.rewardAd = ADSuyiSDKRewardvodAd.init()
        self.rewardAd?.controller = self
        self.rewardAd?.delegate = self
        self.rewardAd?.tolerateTimeout = 5
        self.rewardAd?.posId = "e9e0f8d1fe21873695"
        // 2、加载激励视频广告
        self.rewardAd?.load()
    }

}
