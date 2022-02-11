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
    
    lazy var BackgroundView = {() -> UIView in
        var view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
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
    
    var backgroundView : UIView!
    var closeButton : UIButton!

   @objc func closeAd() {
        self.backgroundView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        self.backgroundView = BackgroundView;
        self.closeButton = CloseBtn;
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
        if nativeAd == nil {
            self.nativeAd = ADSuyiSDKNativeAd.init(adSize: CGSize.init(width: self.view.bounds.size.width, height: 10))
            self.nativeAd.posId = "e9eaffb6b9d97cd813"
            self.nativeAd.delegate = self
            self.nativeAd.controller = self
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
                }
                item.adsy_registViews([item])
                
            }
        }
    }
    
    func adsy_nativeAdFail(toLoad nativeAd: ADSuyiSDKNativeAd, errorModel: ADSuyiAdapterErrorDefine) {
        
    }
    
    func adsy_nativeAdViewRenderOrRegistSuccess(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        UIApplication.shared.keyWindow!.addSubview(self.backgroundView)
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
        
        self.backgroundView.addSubview(self.closeButton)
        
        adview.frame = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        
       let adViewY = adHeight/2 - (adWidth - 17 * 2) / 16.0 * 9/2 - 8 - 8;

        // 设置标题文字（可选，但强烈建议带上）
        let titleLabel = UILabel.init()
        adview.addSubview(titleLabel)
        titleLabel.font = UIFont.adsy_PingFangMediumFont(14)
        titleLabel.textColor = UIColor.adsy_color(withHexString: "#FFFFFF")
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
                logoImage.frame = CGRect(x: adWidth - maxWidth - 20, y: mainFrame.maxY - logoHeight - 5, width: maxWidth, height: logoHeight)
                logoImage.image = image
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
        descLabel.textColor = UIColor.adsy_color(withHexString: "#FFFFFF")
        descLabel.font = UIFont.adsy_PingFangLightFont(12)
        descLabel.textAlignment = NSTextAlignment.left
        descLabel.text = adview.data?.desc
        adview.addSubview(descLabel)
        descLabel.frame = CGRect.init(x: 17 + 36 + 4, y: height, width: self.view.frame.size.width - 57 - 17 - 20, height: 18)
    }

}
