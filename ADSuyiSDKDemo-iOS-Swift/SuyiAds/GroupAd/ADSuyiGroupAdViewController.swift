//
//  ADSuyiGroupAdViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 技术 on 2021/1/27.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit

class ADSuyiGroupAdViewController: UIViewController,ADSuyiSDKNativeAdDelegate,ADSuyiSDKRewardvodAdDelegate {
    func adsy_rewardvodAdServerDidSucceed(_ rewardvodAd: ADSuyiSDKRewardvodAd, info: [AnyHashable : Any]) {
        
    }
    
    func adsy_rewardvodAdCloseLandingPage(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdServerDidSucceed(_ rewardvodAd: ADSuyiSDKRewardvodAd) {
        
    }
    
    func adsy_rewardvodAdServerDidFailed(_ rewardvodAd: ADSuyiSDKRewardvodAd, errorModel: ADSuyiAdapterErrorDefine) {
        
    }
    
    
    var rewardAd: ADSuyiSDKRewardvodAd?;
    
    var nativeAd: ADSuyiSDKNativeAd?;
    
    var textView:UITextView = UITextView.init();
    
    open var nativePosid = ""
    open var rewardPosid = ""
    var logString:String = ""
    var alertView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.alertView = UIView.init()
        self.alertView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.alertView?.frame = self.view.frame
         
        // Do any additional setup after loading the view.
        
        let normalBtn = UIButton.init()
        normalBtn.setTitle("组合广告正常路径示例", for: .normal)
        normalBtn.setTitleColor(UIColor.black, for: .normal)
        normalBtn.backgroundColor = UIColor.white
        normalBtn.layer.cornerRadius = 10
        normalBtn.clipsToBounds = true
        self.view.addSubview(normalBtn)
        normalBtn.frame = CGRect.init(x: 30, y: 100, width: UIScreen.main.bounds.size.width-60, height: 55)
        normalBtn.addTarget(self, action: #selector(loadNormal), for: .touchUpInside)
        
        let errorBtn = UIButton.init()
        errorBtn.setTitle("组合广告异常切换示例", for: .normal)
        errorBtn.setTitleColor(UIColor.black, for: .normal)
        errorBtn.backgroundColor = UIColor.white
        errorBtn.layer.cornerRadius = 10
        errorBtn.clipsToBounds = true
        self.view.addSubview(errorBtn)
        errorBtn.frame = CGRect.init(x: 30, y: 180, width: UIScreen.main.bounds.size.width-60, height: 55)
        errorBtn.addTarget(self, action: #selector(loadError), for: .touchUpInside)
        
        self.textView = UITextView.init()
        self.textView.textColor = UIColor.gray
        self.textView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        self.textView.frame = CGRect.init(x: 30, y: 260, width: UIScreen.main.bounds.size.width-60, height: 250)
        self.textView.isEditable = false
        self.view.addSubview(self.textView)
        
    }
    
    @objc func loadNormal() {
        self.nativeAd = nil
        nativePosid = "e9eaffb6b9d97cd813"
        self.requestNativeAd()
        logString = logString + "开始获取DL广告\n"
        textView.text = logString
        
    }
    
    @objc func loadError() {
        nativeAd = nil
        nativePosid = ""
        self.requestNativeAd()
        logString = logString + "开始获取DL广告\n"
        self.textView.text = logString
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
            }
        }
        logString = logString + "获取DL广告成功\n"
        self.textView.text = logString
    }
    
    func adsy_nativeAdFail(toLoad nativeAd: ADSuyiSDKNativeAd, errorModel: ADSuyiAdapterErrorDefine) {
        // 加载激励图文失败 加载激励视频
        logString = logString + "获取DL广告失败\n"
        requestRewardAd()
        logString = logString + "开始获取激励视频广告\n"
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
        logString = logString + "获取激励视频成功\n"
        self.textView.text = logString
    }
    
    func adsy_rewardvodAdReady(toPlay rewardvodAd: ADSuyiSDKRewardvodAd) {
        // 3、展示激励视频广告
        logString = logString + "展示激励视频\n"
        self.textView.text = logString
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
