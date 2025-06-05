//
//  NativeInterstitialAdViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 技术2 on 2022/2/11.
//  Copyright © 2022 陈坤. All rights reserved.
//
import UIKit

class NativeInterstitialAdViewController: UIViewController, ADSuyiSDKNativeAdDelegate {

    var nativeAd : ADSuyiSDKNativeAd!
    var presentVC : UIViewController!
    lazy var BackgroundView = {() -> UIView in
        var view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    lazy var CloseBtn = {() -> UIButton in
        var button = UIButton()
        button.frame = CGRect.init(x: BackgroundView.frame.size.width - 20 - 30, y: BackgroundView.frame.origin.y + 200, width: 30, height: 30)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(closeAd), for: .touchUpInside)
        return button
        
    }()
    lazy var AdBgView = {() -> UIView in
        var view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    lazy var PresentVC = {() -> UIViewController in
        var vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        return vc
    }()
    var backgroundView : UIView!
    var closeButton : UIButton!
    var adBgView : UIView!
    @objc func removeAllSubviewsFromeSuperView(view : UIView){
        let subvuewsArray = view.subviews;
        for tempview : UIView in subvuewsArray {
            tempview.removeFromSuperview()
        }
    }
   @objc func closeAd() {
       self.presentVC.dismiss(animated: true) {
           
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        self.backgroundView = BackgroundView
        self.closeButton = CloseBtn
        self.adBgView = AdBgView
        self.presentVC = PresentVC
        let loadBtn = UIButton.init()
        loadBtn.layer.cornerRadius = 3;
        loadBtn.clipsToBounds = true;
        loadBtn.backgroundColor = UIColor.white
        loadBtn.setTitle("加载信息流插屏", for: .normal)
        loadBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(loadBtn)
        loadBtn.frame = CGRect.init(x: 30, y: UIScreen.main.bounds.size.height/2-60, width: UIScreen.main.bounds.size.width-60, height: 40)
        loadBtn.addTarget(self, action: #selector(loadNativeAd), for: .touchUpInside)
    }
    
   @objc func loadNativeAd() {
       self.nativeAd = nil;
       self.nativeAd = ADSuyiSDKNativeAd.init(adSize: CGSize.init(width: self.view.bounds.size.width, height: 10))
       self.nativeAd.posId = "e9eaffb6b9d97cd813"
       self.nativeAd.delegate = self
       self.nativeAd.controller = self.presentVC
       self.nativeAd.tolerateTimeout = 4
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
                    setUpUnifiedNativeInterstitialAdView(adview: item)
                }
                item.adsy_registViews([item])
                
            }
        }
    }
    
    func adsy_nativeAdFail(toLoad nativeAd: ADSuyiSDKNativeAd, errorModel: ADSuyiAdapterErrorDefine) {
        
    }
    
    func adsy_nativeAdViewRenderOrRegistSuccess(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        if adView.renderType() == ADSuyiAdapterRenderType.native {
            
        } else {
            self.adBgView.frame = CGRect.init(x: (self.backgroundView.frame.size.width - adView.frame.size.width)/2, y: (self.backgroundView.frame.size.height - adView.frame.size.height)/2, width: adView.frame.size.width, height: adView.frame.size.height)
        }
        self.adBgView.addSubview(adView)
        self.backgroundView.addSubview(self.adBgView)
        self.presentVC.view.addSubview(self.backgroundView)
        self.present(self.presentVC, animated: true) {
        }
    }
    
    func adsy_nativeAdViewRenderOrRegistFail(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClicked(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClose(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        DispatchQueue.main.async {
            adView.adsy_unRegistView()
        }
        self.removeAllSubviewsFromeSuperView(view: self.adBgView)
        self.removeAllSubviewsFromeSuperView(view: self.backgroundView)
        closeAd()
    }
    
    func adsy_nativeAdExposure(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }

    
    // 自渲染信息流开屏广告样式
    func setUpUnifiedNativeInterstitialAdView(adview : UIView & ADSuyiAdapterNativeAdViewDelegate) {
        // 设计的adView实际大小，其中宽度和高度可以自己根据自己的需求设置
        let adWidth:CGFloat = self.backgroundView.frame.size.width - 17 * 2
        let adHeight:CGFloat = adWidth / 16.0 * 9
        let adBgViewHeight:CGFloat = adHeight + 130

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
        
        // 显示logo图片（必要）
        //优量汇（广点通）会自带logo，不需要添加
        if adview.adsy_platform() != ADSuyiAdapterPlatform.GDT {
            let logoImage = UIImageView()
            adview.addSubview(logoImage);
            adview.adsy_platformLogoImageDarkMode(false) { (image) in
                guard let image = image else {
                    return
                }
                let maxWidth: CGFloat = 30.0;
                let logoHeight = maxWidth / image.size.width * image.size.height;
                logoImage.frame = CGRect(x: adWidth - maxWidth, y:  adHeight - logoHeight - 5, width: maxWidth, height: logoHeight)
                logoImage.image = image
            }
        }

        // 设置广告描述(可选)
        let descLabel : UILabel = UILabel.init()
        descLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        descLabel.font = UIFont.adsy_PingFangLightFont(18)
        descLabel.textAlignment = NSTextAlignment.center
        descLabel.text = "这里是信息流自渲染适配插屏，需要开发者自行设计样式"
        self.adBgView.addSubview(descLabel)
        descLabel.frame = CGRect.init(x: 0, y: adHeight + 15, width: adWidth, height: 60)
        
        self.adBgView.frame = CGRect.init(x: 17, y: (self.backgroundView.frame.size.height - adBgViewHeight)/2, width: adWidth, height: adBgViewHeight)
        self.adBgView.isUserInteractionEnabled = true
        self.backgroundView.isUserInteractionEnabled = true
        
        //设置关闭按钮
        let closeBtnWidth:CGFloat = 40
        let closeBtnHeight:CGFloat = closeBtnWidth

        self.closeButton.frame = CGRect.init(x: (adWidth - closeBtnWidth)/2, y: self.adBgView.frame.size.height - closeBtnHeight, width: closeBtnWidth, height: closeBtnHeight)
        self.adBgView.addSubview(self.CloseBtn)
    }

}
