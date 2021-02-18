//
//  ADSuyiGroupAdViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 技术 on 2021/1/27.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit

class ADSuyiGroupAdViewController: UIViewController,ADSuyiSDKNativeAdDelegate,ADSuyiSDKRewardvodAdDelegate {
    
    var rewardAd: ADSuyiSDKRewardvodAd?;
    
    var nativeAd: ADSuyiSDKNativeAd?;
    
    open var nativePosid = ""
    open var rewardPosid = ""
    
    var alertView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.alertView = UIView.init()
        self.alertView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.alertView?.frame = self.view.frame
        let btn = UIButton.init()
        btn.setTitle("获取组合广告", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 4.0
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.black.cgColor
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(requestNativeAd), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(btn)
        btn.frame = CGRect.init(x: UIScreen.main.bounds.size.width/2-60, y: UIScreen.main.bounds.size.height/2-15, width: 120, height: 30)
        // Do any additional setup after loading the view.
    }
    
    @objc func requestNativeAd() {
        if nativeAd == nil {
            nativeAd = ADSuyiSDKNativeAd.init(adSize: CGSize.init(width: 320, height: 180))
            nativeAd!.posId = nativePosid
            nativeAd!.delegate = self
            nativeAd!.controller = self
        }
        nativeAd!.load(1)
    }
    
    @objc func requestRewardAd() {
        rewardAd = ADSuyiSDKRewardvodAd.init()
        rewardAd!.delegate = self
        rewardAd!.controller = self
        rewardAd!.tolerateTimeout = 5
        rewardAd!.posId = rewardPosid
        rewardAd!.load()
    }
    
//    MARK: ADSuyiNativeAdDelegate
    
    func adsy_nativeAdSucess(toLoad nativeAd: ADSuyiSDKNativeAd, adViewArray: [UIView & ADSuyiAdapterNativeAdViewDelegate]) {
        if adViewArray.count > 0{
            for item : UIView&ADSuyiAdapterNativeAdViewDelegate in adViewArray {
                if item.renderType() == ADSuyiAdapterRenderType.native {
                    setUpUnifiedNativeAdView(adview: item)
                }
                item.adsy_registViews([item])
                item.adsy_platform()
                //广点通视频信息流广告会给mediaView添加事件，点击会出现半屏广告，以下为广点通官方给予的解决方案
                if let data = item.data {
                    if item.adsy_platform() == ADSuyiAdapterPlatform.GDT && item.renderType() == ADSuyiAdapterRenderType.native && data.shouldShowMediaView == true {
                            item.adsy_mediaView(forWidth: 0.0)?.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    func adsy_nativeAdFail(toLoad nativeAd: ADSuyiSDKNativeAd, errorModel: ADSuyiAdapterErrorDefine) {
        // 加载激励图文失败 加载激励视频
        requestRewardAd()
    }
    
    func adsy_nativeAdViewRenderOrRegistSuccess(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        DispatchQueue.main.async {
            adView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height/2-adView.bounds.size.height/2, width: adView.bounds.size.width, height: adView.bounds.size.height)
            self.alertView?.addSubview(adView)
            self.view.addSubview(self.alertView!)
        }
    }
    
    func adsy_nativeAdViewRenderOrRegistFail(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClicked(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClose(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
            DispatchQueue.main.async {
                adView.adsy_unRegistView()
                adView.removeFromSuperview()
                self.alertView?.removeFromSuperview()
            }
    }
    
    func adsy_nativeAdExposure(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
//    MARK:  ADSuyiRewardAdDelegate
    func adsy_rewardvodAdLoadSuccess(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdReady(toPlay rewardvodAd: ADSuyiSDKRewardvodAd) {
        // 3、展示激励视频广告
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpUnifiedNativeAdView(adview : UIView & ADSuyiAdapterNativeAdViewDelegate) {
        // 设计的adView实际大小，其中宽度和高度可以自己根据自己的需求设置
        let adWidth:CGFloat = self.view.bounds.size.width
        let adHeight:CGFloat = adWidth/16.0 * 9.0
        adview.frame = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        
        // 设置主图/视频（主图可选，但强烈建议带上,如果有视频试图，则必须带上）
        let mainFrame:CGRect = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        if adview.data?.shouldShowMediaView ?? false {
            let mediaView:UIView = adview.adsy_mediaView(forWidth: mainFrame.size.width) ?? UIView.init()
            mediaView.frame = mainFrame
            adview.addSubview(mediaView)
        } else {
            let imageView:UIImageView = UIImageView.init()
            imageView.backgroundColor = UIColor.adsy_color(withHexString: "#CCCCCC")
            adview.addSubview(imageView)
            imageView.frame = mainFrame
            
            let urlStr:String = adview.data?.imageUrl ?? ""
            if urlStr.count > 0 {
                DispatchQueue.global().async {
                    let url = URL.init(string: urlStr)
                    if url != nil {
                        let data = NSData.init(contentsOf: url!)
                        if data != nil {
                            let image = UIImage.init(data: data! as Data)
                            DispatchQueue.main.async {
                                imageView.image = image
                            }
                        }
                    }
                }
            }
        }
        
        // 展示关闭按钮（必要）
        let closeButton = UIButton()
        adview.addSubview(closeButton)
        closeButton.frame = CGRect(x:adWidth-44, y:0, width:44, height:44)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(adview, action: #selector(adview.adsy_close), for: .touchUpInside)
        
        // 显示logo图片（必要）
        let logoImage = UIImageView()
        adview.addSubview(logoImage);
        adview.adsy_platformLogoImageDarkMode(false) { (image) in
            guard let image = image else {
                return
            }
            let maxWidth: CGFloat = 80.0;
            let logoHeight = maxWidth / image.size.width * image.size.height;
            logoImage.frame = CGRect(x: adWidth - maxWidth, y: adHeight - logoHeight, width: maxWidth, height: logoHeight)
            logoImage.image = image
        }

        
    }

}
