//
//  ADSuyiBannerViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/16.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class ADSuyiBannerItem : NSObject {
    var rate : CGFloat?
    var posId : String?
    var title : String?
    
    init(rate : CGFloat, posId : String, title : String) {
        self.posId = posId
        self.rate = rate
        self.title = title
    }
}

class ADSuyiBannerViewController: UIViewController, ADSuyiSDKBannerAdViewDelegate {
    func adsy_bannerViewDidPresent(_ bannerView: ADSuyiSDKBannerAdView) {
        
    }
    
    func adsy_bannerAdCloseLandingPage(_ bannerView: ADSuyiSDKBannerAdView) {
        
    }
    
    func adsy_bannerViewDidReceived(_ bannerView: ADSuyiSDKBannerAdView) {
        print(#function)
        let extInfo = bannerView.adsy_extInfo()
        print("ecpm=", extInfo?.ecpm ?? "")
        print("ecpmType=", extInfo?.ecpmType.rawValue ?? 0)
    }
    
    func adsy_bannerViewClicked(_ bannerView: ADSuyiSDKBannerAdView) {
        print(#function)
    }
    
    func adsy_bannerViewExposure(_ bannerView: ADSuyiSDKBannerAdView) {
        print(#function)
    }
    

    var bannerAdView : ADSuyiSDKBannerAdView?
    let screensSize = UIScreen.main.bounds.size
    
    lazy var dataArray : Array<ADSuyiBannerItem> = [ADSuyiBannerItem.init(rate: 640/100.0, posId: "9ca1e179e38ca5a35c", title: "640*100"), ADSuyiBannerItem.init(rate: 600/150.0, posId: "f75ccc39a18436f65c", title: "600*150"), ADSuyiBannerItem.init(rate: 600/260.0, posId: "ddf3dbdbef73a0e0b2", title: "600*260"), ADSuyiBannerItem.init(rate: 600/300.0, posId: "2a74467bee2eb3e31f", title: "600*300"), ADSuyiBannerItem.init(rate: 690/388.0, posId: "cf17c076d6d2b5f86f", title: "690*388"), ADSuyiBannerItem.init(rate: 600/400.0, posId: "1d54d4991ffd9273b7", title: "600*400"), ADSuyiBannerItem.init(rate: 600/500.0, posId: "2e5443fd293252ad30", title: "600*500")]
    
    var btnArray : Array<UIButton> = Array.init()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        for i in 0..<self.dataArray.capacity{
            createButtonItem(toReceived: self.dataArray[i], index: i)
        }
        
    }
    
    func createButtonItem(toReceived bannerItem : ADSuyiBannerItem, index : NSInteger) {
        let btn = UIButton.init()
        self.view.addSubview(btn)
        
        let btn_num_per_line:CGFloat = 4
        let btn_height:CGFloat = 32
        let btn_margin_top:CGFloat = 10
        let btn_margin_left:CGFloat = 10
        let margin_top:CGFloat = 16
        let margin_left:CGFloat = 17
        
        let btn_width =  ((self.view.frame.size.width - margin_left * 2) - ((btn_num_per_line - 1) * btn_margin_left)) / btn_num_per_line
        
        let x = (CGFloat((index % NSInteger(btn_num_per_line))) * (btn_margin_left + btn_width)) + margin_left;
        
        let y = CGFloat(index / NSInteger(btn_num_per_line)) * (btn_margin_top + btn_height) + margin_top + 100;
        
        btn.frame = CGRect.init(x: x, y: y, width: btn_width, height: btn_height);
        btn.tag = NSInteger(index)
        
        btn.addTarget(self, action: #selector(clickLoadBannerButton(button:)), for: .touchUpInside)
        
        btn.setTitle(bannerItem.title, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.init(red: 0, green: 122/255.0, blue: 1, alpha: 1), for: UIControl.State.normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(red: 199/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1).cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(btn)
        
        self.btnArray.append(btn)
        
    }
    
    @objc func clickLoadBannerButton(button : UIButton) {
        button.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            button.isEnabled = true
        }
        
        for itemBtn in self.btnArray {
            itemBtn.backgroundColor = (itemBtn == button) ? UIColor.init(red: 222/255.0, green: 236/255.0, blue: 251/255.0, alpha: 1) : UIColor.white
        }
        let bannerItem : ADSuyiBannerItem = self.dataArray[button.tag]
        loadBannerView(bannerItem.rate!, posid: bannerItem.posId!)
    }
    
    func loadBannerView(_ rate:CGFloat, posid:String) {
        if bannerAdView != nil {
            self.bannerAdView?.removeFromSuperview()
            self.bannerAdView = nil
        }
        // 1、初始化banner广告视图，并传入期望的宽高
        let height = screensSize.width / rate
        bannerAdView = ADSuyiSDKBannerAdView.init(frame: CGRect.init(x: 0, y: 250, width: screensSize.width, height: height))
        bannerAdView?.delegate = self
        // 2、传入广告位id
        bannerAdView?.posId = posid
        bannerAdView?.tolerateTimeout = 4
        if SetConfigManager.shared().bannerAdScenceId != "" {
            bannerAdView?.scenesId = SetConfigManager.shared().bannerAdScenceId
        }
        self.view.addSubview(bannerAdView!)
        // 3、加载并展示；设置控制器，用来弹出落地页，重要
        bannerAdView?.loadAndShow(self)
    }
    
    func adsy_bannerViewClose(_ bannerView: ADSuyiSDKBannerAdView) {
        print(#function)
        bannerAdView?.removeFromSuperview()
        bannerAdView = nil
    }
    
    func adsy_bannerViewFail(toReceived bannerView: ADSuyiSDKBannerAdView, errorModel: ADSuyiAdapterErrorDefine) {
        print(#function)
        bannerAdView?.removeFromSuperview()
        bannerAdView = nil
    }

}
