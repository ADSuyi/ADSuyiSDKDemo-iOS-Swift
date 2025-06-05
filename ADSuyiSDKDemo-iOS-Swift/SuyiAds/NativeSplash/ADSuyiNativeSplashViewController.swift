//
//  ADSuyiNativeSplashViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by Erik on 2022/1/24.
//  Copyright © 2022 陈坤. All rights reserved.
//

import UIKit


class ADSuyiNativeSplashViewController: UIViewController, ADSuyiSDKNativeAdDelegate {
    
    var nativeAd : ADSuyiSDKNativeAd!
    
    var presentVC : UIViewController!
    
    var timer : ADSuyiKitTimer!
    
    var skipCount = 5
    
    lazy var BackgroundView = {() -> UIView in
        var view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = UIScreen.main.bounds
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var SkipLabel = {()->UILabel in
        var label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: 70, height: 25)
        label.backgroundColor = UIColor.clear
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.cornerRadius = 6
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    lazy var CustomClickLabel = {() -> UILabel in
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 10
        label.text = "点击跳转详情页    >"
        label.textAlignment = NSTextAlignment.center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var PresentVC = {() -> UIViewController in
        var vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        return vc
    }()
    
    var backgroundView : UIView!
    var skipLabel : UILabel!
    var customClickLabel:UILabel!
    
    @objc func timerAction(timer:ADSuyiKitTimer) -> Void {
        skipCount-=1;
        skipCount = skipCount < 0 ? 0 : skipCount
        self.skipLabel.text = "跳过 | \(skipCount)"
        if skipCount == 0 && UIViewController.jsd_top() == self.presentVC {
            closeAd()
        }
        
    }
    
    func closeAd() {
        //        self.backgroundView.removeFromSuperview()
        self.presentVC.dismiss(animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.backgroundView = BackgroundView;
        self.skipLabel = SkipLabel;
        self.customClickLabel = CustomClickLabel;
        self.presentVC = PresentVC
        loadNativeAd()
        // Do any additional setup after loading the view.
    }
    
    func loadNativeAd() {
        if nativeAd == nil {
            self.nativeAd = ADSuyiSDKNativeAd.init(adSize: CGSize.init(width: self.view.bounds.size.width, height: 10))
            self.nativeAd.posId = "e9eaffb6b9d97cd813"
            self.nativeAd.delegate = self
            self.nativeAd.controller = self.presentVC
            self.nativeAd.tolerateTimeout = 4
        }
        self.nativeAd.load(1)
    }
    
    // MARK: - ADSuyiSDKNativeAdDelegate
    
    func adsy_nativeAdSucess(toLoad nativeAd: ADSuyiSDKNativeAd, adViewArray: [UIView & ADSuyiAdapterNativeAdViewDelegate]) {
        if adViewArray.count > 0{
            for item : UIView&ADSuyiAdapterNativeAdViewDelegate in adViewArray {
                // 判断信息流广告是否为自渲染类型（可选实现） 可仿照所示样式demo实现 如无所需样式则需自行实现
                // 如果单纯只配置了模版信息流，那么不需要实现，如果配置了自渲染信息流，那么需要实现
                if item.renderType() == ADSuyiAdapterRenderType.native {
                    //1、常规样式
                    setUpUnifiedNativeSplashAdView(adview: item)
                } else {
                    self.backgroundView.addSubview(item)
                    item.frame = CGRect.init(x: self.view.bounds.size.width/2 - item.bounds.size.width/2, y: self.view.bounds.size.height/2 - item.bounds.size.height/2, width: item.bounds.size.width, height: item.bounds.size.height)
                    self.backgroundView.addSubview(self.skipLabel)
                    self.skipLabel.isUserInteractionEnabled = true
                    self.skipLabel.frame = CGRect.init(x: self.view.bounds.size.width - self.skipLabel.bounds.size.width - 30, y: 44, width: self.skipLabel.bounds.size.width, height: self.skipLabel.bounds.size.height)
                    self.skipLabel.text = "跳过 | \(skipCount)"
                    let tap = UITapGestureRecognizer.init(target: item, action: #selector(item.adsy_close))
                    self.skipLabel.addGestureRecognizer(tap)
                    
                    self.backgroundView.addSubview(self.customClickLabel)
                    self.customClickLabel.frame = CGRect.init(x:self.view.bounds.size.width/2 - 150, y:self.view.bounds.size.height - 50 - 50, width: 300, height: 40);
                }
                item.adsy_registViews([item])
                
            }
        }
    }
    
    func adsy_nativeAdFail(toLoad nativeAd: ADSuyiSDKNativeAd, errorModel: ADSuyiAdapterErrorDefine) {
        
    }
    
    func adsy_nativeAdViewRenderOrRegistSuccess(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        //        UIApplication.shared.keyWindow!.addSubview(self.backgroundView)
        self.presentVC.view.addSubview(self.backgroundView)
        self.present(self.presentVC, animated: true) {
        }
        timer = ADSuyiKitTimer.init(timeInterval: 1, target: self, selector: #selector(timerAction(timer:)), repeats: true)
        timer.scheduleImmediately(false)
    }
    
    func adsy_nativeAdViewRenderOrRegistFail(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClicked(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClose(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        closeAd()
    }
    
    func adsy_nativeAdExposure(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    
    // 自渲染信息流开屏广告样式
    func setUpUnifiedNativeSplashAdView(adview : UIView & ADSuyiAdapterNativeAdViewDelegate) {
        self.backgroundView.addSubview(adview)
        // 设计的adView实际大小，其中宽度和高度可以自己根据自己的需求设置
        let adWidth:CGFloat = self.view.bounds.size.width
        let adHeight:CGFloat = self.view.bounds.size.height
        
        self.backgroundView.addSubview(self.skipLabel)
        self.skipLabel.isUserInteractionEnabled = true
        self.skipLabel.frame = CGRect.init(x: self.view.bounds.size.width - self.skipLabel.bounds.size.width - 30, y: 44, width: self.skipLabel.bounds.size.width, height: self.skipLabel.bounds.size.height)
        self.skipLabel.text = "跳过 | \(skipCount)"
        let tap = UITapGestureRecognizer.init(target: adview, action: #selector(adview.adsy_close))
        self.skipLabel.addGestureRecognizer(tap)
        
        
        
        adview.frame = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        
        self.backgroundView.addSubview(self.customClickLabel)
        self.customClickLabel.frame = CGRect.init(x:self.view.bounds.size.width/2 - 150, y:self.view.bounds.size.height - 50 - 50, width: 300, height: 40);
        
        // 显示logo图片（必要）
        //优量汇（广点通）会自带logo，不需要添加
        if adview.adsy_platform() != ADSuyiAdapterPlatform.GDT {
            let logoImage = UIImageView()
            adview.addSubview(logoImage);
            adview.adsy_platformLogoImageDarkMode(false) { (image) in
                guard let image = image else {
                    return
                }
                let maxWidth: CGFloat = 40.0;
                let logoHeight = maxWidth / image.size.width * image.size.height;
                logoImage.frame = CGRect(x: adWidth - maxWidth - 20, y: adHeight - logoHeight - 20, width: maxWidth, height: logoHeight)
            }
        }
        
        let adViewY = adHeight/2 - (adWidth - 17 * 2) / 16.0 * 9/2 - 8 - 8;
        
        // 设置标题文字（可选，但强烈建议带上）
        let titleLabel = UILabel.init()
        adview.addSubview(titleLabel)
        titleLabel.font = UIFont.adsy_PingFangMediumFont(14)
        titleLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        titleLabel.numberOfLines = 2
        titleLabel.text = adview.data?.title
        let size:CGSize = titleLabel.sizeThatFits(CGSize.init(width: adWidth - 34.0, height: 999))
        titleLabel.frame = CGRect.init(x: 17, y: adViewY, width: adWidth - 34.0, height: size.height)
        
        var height:CGFloat = size.height + adViewY + 15
        
        // 设置主图/视频（主图可选，但强烈建议带上,如果有视频试图，则必须带上）
        let mainFrame:CGRect = CGRect.init(x: 17, y: height, width: adWidth - 34.0, height: (adWidth - 34.0) / 16.0 * 9.0)
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
        
        height = height + (adWidth - 34.0) / 16.0 * 9.0 + 9.0
        
        // 设置广告标识（可选）
        let adlabel : UILabel = UILabel.init()
        adlabel.backgroundColor = UIColor.adsy_color(withHexString: "#CCCCCC")
        adlabel.textColor = UIColor.adsy_color(withHexString: "#FFFFFF")
        adlabel.font = UIFont.adsy_PingFangLightFont(12)
        adlabel.text = "广告"
        adview.addSubview(adlabel)
        adlabel.frame = CGRect.init(x: 17, y: height, width: 36, height: 18)
        adlabel.textAlignment = NSTextAlignment.center
        
        // 设置广告描述(可选)
        let descLabel : UILabel = UILabel.init()
        descLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        descLabel.font = UIFont.adsy_PingFangLightFont(12)
        descLabel.textAlignment = NSTextAlignment.left
        descLabel.text = adview.data?.desc
        adview.addSubview(descLabel)
        descLabel.frame = CGRect.init(x: 17 + 36 + 4, y: height, width: self.view.frame.size.width - 57 - 17 - 20, height: 18)
    }
    
}
