//
//  AdSuyiFullScreenVodViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/17.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiFullScreenVodViewController: UIViewController, ADSuyiSDKFullScreenVodAdDelegate {
    func adsy_fullScreenVodAdCloseLandingPage(_ fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        
    }
    
    func adsy_fullScreenVodAdSucced(toLoad fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
        let extInfo = fullScreenVodAd.adsy_extInfo()
        print("ecpm=", extInfo?.ecpm ?? "")
        print("ecpmType=", extInfo?.ecpmType.rawValue ?? 0)
    }
    
    func adsy_fullScreenVodAdReady(toPlay fullScreenVodAd: ADSuyiSDKFullScreenVodAd) {
        print(#function)
        // 3、展示全屏视频广告
        isReady = true
        self.view.makeToast("全屏视频准备完成")
        
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
    var isReady:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        let loadBtn = UIButton.init()
        loadBtn.layer.cornerRadius = 10;
        loadBtn.clipsToBounds = true;
        loadBtn.backgroundColor = UIColor.white
        loadBtn.setTitle("加载全屏视频", for: .normal)
        loadBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(loadBtn)
        loadBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2-60, width: UIScreen.main.bounds.size.width-60, height: 55)
        loadBtn.addTarget(self, action: #selector(loadFullScreenVodAd), for: .touchUpInside)
        
        let showBtn = UIButton.init()
        showBtn.layer.cornerRadius = 10
        showBtn.clipsToBounds = true
        showBtn.backgroundColor = UIColor.white
        showBtn.setTitle("展示全屏视频", for: .normal)
        showBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(showBtn)
        showBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2+20, width: UIScreen.main.bounds.size.width-60, height: 55)
        showBtn.addTarget(self, action: #selector(showFullScreenVodAd), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
    }
    
    @objc func loadFullScreenVodAd() {
        // 1、初始化全屏视频
        self.fullScreenVod = ADSuyiSDKFullScreenVodAd.init()
        self.fullScreenVod?.delegate = self
        self.fullScreenVod?.controller = self
        self.fullScreenVod?.tolerateTimeout = 5
        self.fullScreenVod?.posId = "f3953777bc833957d8"
        if SetConfigManager.shared().fullAdAdScenceId != "" {
            self.fullScreenVod?.scenesId = SetConfigManager.shared().fullAdAdScenceId
        }
        // 2、加载全屏视频广告
        self.fullScreenVod?.loadData()
    }
    
    @objc func showFullScreenVodAd() {
        if isReady {
            self.fullScreenVod?.show()
        }else {
            self.view.makeToast("全屏视频未准备好")
        }
    }
    

}
