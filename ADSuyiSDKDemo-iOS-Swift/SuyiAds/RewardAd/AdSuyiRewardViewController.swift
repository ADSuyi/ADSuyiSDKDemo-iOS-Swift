//
//  AdSuyiRewardViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/16.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiRewardViewController: UIViewController, ADSuyiSDKRewardvodAdDelegate {
    func adsy_rewardvodAdServerDidSucceed(_ rewardvodAd: ADSuyiSDKRewardvodAd, info: [AnyHashable : Any]) {
        
    }
    
    func adsy_rewardvodAdCloseLandingPage(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdServerDidSucceed(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdServerDidFailed(_ rewardvodAd: ADSuyiSDKRewardvodAd, errorModel: ADSuyiAdapterErrorDefine) {
        
    }
    
    func adsy_rewardvodAdLoadSuccess(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        let extInfo = rewardvodAd.adsy_extInfo()
        print("ecpm=", extInfo?.ecpm ?? "")
        print("ecpmType=", extInfo?.ecpmType.rawValue ?? 0)
    }
    
    func adsy_rewardvodAdReady(toPlay rewardvodAd: ADSuyiSDKRewardvodAd) {
        // 3、展示激励视频广告
        if self.rewardAd!.rewardvodAdIsReady(){
            isReady = true
            // 建议在这个时机进行展示 也可根据需求在合适的时机进行展示
            // [self.rewardvodAd showRewardvodAd];
        }
        self.view.makeToast("激励视频准备完成")
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
    var isReady : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        let loadBtn = UIButton.init()
        loadBtn.layer.cornerRadius = 10;
        loadBtn.clipsToBounds = true;
        loadBtn.backgroundColor = UIColor.white
        loadBtn.setTitle("加载激励视频", for: .normal)
        loadBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(loadBtn)
        loadBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2-60, width: UIScreen.main.bounds.size.width-60, height: 55)
        loadBtn.addTarget(self, action: #selector(loadRewardAd), for: .touchUpInside)
        
        let showBtn = UIButton.init()
        showBtn.layer.cornerRadius = 10
        showBtn.clipsToBounds = true
        showBtn.backgroundColor = UIColor.white
        showBtn.setTitle("展示激励视频", for: .normal)
        showBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(showBtn)
        showBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2+20, width: UIScreen.main.bounds.size.width-60, height: 55)
        showBtn.addTarget(self, action: #selector(showRewardAd), for: .touchUpInside)
        
        
    }
    
    
    @objc func loadRewardAd() {
        // 1、初始化激励视频广告对象
        self.rewardAd = ADSuyiSDKRewardvodAd.init()
        self.rewardAd?.controller = self
        self.rewardAd?.delegate = self
        self.rewardAd?.tolerateTimeout = 5
        self.rewardAd?.posId = "47d196ffaaa92ae93c"
        // 2、加载激励视频广告
        self.rewardAd?.load()
    }
    
    @objc func showRewardAd() {
        if isReady && self.rewardAd!.rewardvodAdIsReady() {
            self.rewardAd?.show()
        } else {
            self.view.makeToast("激励视频未准备好")
        }
    }

}
