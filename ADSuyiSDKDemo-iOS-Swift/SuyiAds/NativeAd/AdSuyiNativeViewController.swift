//
//  AdSuyiNativeViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/17.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiNativeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ADSuyiSDKNativeAdDelegate {
    func adsy_nativeAdSucess(toLoad nativeAd: ADSuyiSDKNativeAd, adViewArray: [UIView & ADSuyiAdapterNativeAdViewDelegate]) {
        if adViewArray.count > 0{
            for item : UIView&ADSuyiAdapterNativeAdViewDelegate in adViewArray {
                let extInfo = item.adsy_extInfo()
                print("ecpm=", extInfo?.ecpm ?? "")
                print("ecpmType=", extInfo?.ecpmType.rawValue ?? 0)
                // 判断信息流广告是否为自渲染类型（可选实现） 可仿照所示样式demo实现 如无所需样式则需自行实现
                // 如果单纯只配置了模版信息流，那么不需要实现，如果配置了自渲染信息流，那么需要实现
                if item.renderType() == ADSuyiAdapterRenderType.native {
                    //1、常规样式
//                    setUpUnifiedNativeAdView(adview: item)
                    //2、纯图
//                    setUpUnifiedOnlyImageNativeAdView(adview: item)
                    //3、上图下文
                    setUpUnifiedTopImageNativeAdView(adview: item)
                }
                item.adsy_registViews([item])
            }
        }
        
        self.mainTableView.mj_header?.endRefreshing()
        self.mainTableView.mj_footer?.endRefreshing()
    }
    
    func adsy_nativeAdFail(toLoad nativeAd: ADSuyiSDKNativeAd, errorModel: ADSuyiAdapterErrorDefine) {
        self.mainTableView.mj_header?.endRefreshing()
        self.mainTableView.mj_footer?.endRefreshing()
    }
    
    func adsy_nativeAdViewRenderOrRegistSuccess(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        DispatchQueue.main.async {
            for _ in 0...6 {
                self.dataArray.append(NSNull.init())
            }
            self.dataArray.append(adView)
            self.mainTableView.reloadData()
        }
    }
    
    func adsy_nativeAdViewRenderOrRegistFail(_ adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClicked(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func adsy_nativeAdClose(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        for i in 0..<self.dataArray.count {
            let item = self.dataArray[i]
            if item as! NSObject == adView {
                DispatchQueue.main.async {
                    adView.adsy_unRegistView()
                    self.dataArray.remove(at: i)
                    self.mainTableView.reloadData()
                }
            }
        }
    }
    
    func adsy_nativeAdExposure(_ nativeAd: ADSuyiSDKNativeAd, adView: UIView & ADSuyiAdapterNativeAdViewDelegate) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataArray[indexPath.row]
        var cell : UITableViewCell!
        if item is ADSuyiAdapterNativeAdViewDelegate {
            cell = self.mainTableView.dequeueReusableCell(withIdentifier: adTableViewCellInentifier, for: indexPath)
            
            for v in cell.contentView.subviews {
                   v.removeFromSuperview()
            }
            
            let obj = item as! UIView
            cell.contentView.addSubview(obj)
            
            //备注：如果是自渲染信息流，建议将关闭按钮添加到和adView同一层级，切勿将关闭按钮添加到adView上 (必要)
            let tempItem = item as! UIView & ADSuyiAdapterNativeAdViewDelegate
            if !tempItem.adsy_closeButtonExist() {
                cell.contentView.addSubview(getCloseButtonWithAdItem(item: tempItem))
            }
        
        } else {
            cell = self.mainTableView.dequeueReusableCell(withIdentifier: tableViewCellInentifier, for: indexPath)
            cell.textLabel?.textAlignment = NSTextAlignment.center;
            cell.textLabel?.text = String.init(format: "ListViewitem %li", indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.dataArray[indexPath.row]
        if item is ADSuyiAdapterNativeAdViewDelegate {
            let obj = item as! UIView
            return obj.frame.size.height
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    

    var mainTableView : UITableView!
    var nativeAd : ADSuyiSDKNativeAd!
    let tableViewCellInentifier : String = "tableViewCellInentifier"
    let adTableViewCellInentifier : String = "adtableViewCellInentifier"
    private var dataArray:Array = Array<Any>.init()
    open var posid : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mainTableView = UITableView.init()
        self.mainTableView?.delegate = self
        self.mainTableView?.dataSource = self
        self.mainTableView?.frame = self.view.frame
        mainTableView?.frame.origin.y = CGFloat(tabBarHeight)
        
        self.mainTableView?.showsVerticalScrollIndicator = false
        self.mainTableView?.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            self.mainTableView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.mainTableView?.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: tableViewCellInentifier)
        self.mainTableView?.register(object_getClass(UITableViewCell()), forCellReuseIdentifier:  adTableViewCellInentifier)
        self.view.addSubview(self.mainTableView!)
        
        self.mainTableView.mj_header = MJRefreshNormalHeader.init()
        self.mainTableView.mj_footer = MJRefreshAutoNormalFooter.init()
        
        self.mainTableView.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        
        self.mainTableView.mj_footer?.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        
        self.mainTableView.mj_header?.beginRefreshing()
        
        let setBtn = UIButton.init()
        setBtn.setTitle("设置", for: .normal)
        setBtn.setTitleColor(UIColor.white, for: .normal)
        setBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        setBtn.addTarget(self, action: #selector(setBtnClick), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: setBtn)
        self.navigationItem.rightBarButtonItem = rightItem;

        
    }
    
    @objc func setBtnClick() {
        let alertVc = UIAlertController.init(title: "", message: "选择广告类型", preferredStyle: .actionSheet)
        let expressAction = UIAlertAction.init(title: "模板渲染", style: .default) { (action) in
            self.cleanAllAd()
            self.nativeAd = nil
            self.posid = "177a790a315eeb7053"
            self.loadNativeAd()
        }
        let nativeAction = UIAlertAction.init(title: "自渲染", style: .default) { (action) in
            self.cleanAllAd()
            self.nativeAd = nil
            self.posid = "e9eaffb6b9d97cd813"
            self.loadNativeAd()
        }
        let cancle = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        alertVc.addAction(expressAction)
        alertVc.addAction(nativeAction)
        alertVc.addAction(cancle)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    
    @objc func headerRefresh() {
        cleanAllAd()
        self.nativeAd = nil
        loadNativeAd()
    }
    
    @objc func footerRefresh() {
        loadNativeAd()
    }
    
    func loadNativeAd() {
        if nativeAd == nil {
            //建议将高度设置为0
            self.nativeAd = ADSuyiSDKNativeAd.init(adSize: CGSize.init(width: self.view.bounds.size.width, height: 0))
            self.nativeAd.posId = self.posid
            self.nativeAd.delegate = self
            self.nativeAd.controller = self
            self.nativeAd.tolerateTimeout = 4
            if SetConfigManager.shared().nativeAdScenceId != "" {
                self.nativeAd.scenesId = SetConfigManager.shared().nativeAdScenceId
            }
        }
        self.nativeAd.load(Int32(SetConfigManager.shared().nativeAdCount))
    }
    // 1、常规样式
    func setUpUnifiedNativeAdView(adview : UIView & ADSuyiAdapterNativeAdViewDelegate) {
        // 设计的adView实际大小，其中宽度和高度可以自己根据自己的需求设置
        let adWidth:CGFloat = self.view.bounds.size.width
        let adHeight:CGFloat = (adWidth - 34.0) / 16.0 * 9.0 + 67 + 38
        adview.frame = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        
        // 显示logo图片（必要）
        //优量汇（广点通）会自带logo，不需要添加
        if adview.adsy_platform() != ADSuyiAdapterPlatform.GDT {
            let logoImage = UIImageView()
            adview.addSubview(logoImage);
            adview.adsy_platformLogoImageDarkMode(false) { (image) in
                guard let image = image else {
                    return
                }
                let maxWidth: CGFloat = 80.0;
                let logoHeight = maxWidth / image.size.width * image.size.height;
                logoImage.frame = CGRect(x: adWidth - maxWidth, y: adHeight - logoHeight, width: maxWidth, height: logoHeight)
            }
        }

        // 设置标题文字（可选，但强烈建议带上）
        let titleLabel = UILabel.init()
        adview.addSubview(titleLabel)
        titleLabel.font = UIFont.adsy_PingFangMediumFont(14)
        titleLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        titleLabel.numberOfLines = 2
        titleLabel.text = adview.data?.title
        let size:CGSize = titleLabel.sizeThatFits(CGSize.init(width: adWidth - 34.0, height: 999))
        titleLabel.frame = CGRect.init(x: 17, y: 16, width: adWidth - 34.0, height: size.height)
        
        var height:CGFloat = size.height + 16 + 15
        
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
    // 2、纯图
    func setUpUnifiedOnlyImageNativeAdView(adview : UIView & ADSuyiAdapterNativeAdViewDelegate) {
        // 设计的adView实际大小，其中宽度和高度可以自己根据自己的需求设置
        let adWidth:CGFloat = self.view.bounds.size.width
        let adHeight:CGFloat = adWidth / 16.0 * 9.0
        adview.frame = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        
        
        // 设置主图/视频（主图可选，但强烈建议带上,如果有视频试图，则必须带上）
        let mainFrame:CGRect = CGRect.init(x: 0, y: 0, width: adWidth , height: adHeight)
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
        if adview.adsy_platform() != ADSuyiAdapterPlatform.GDT {
            let logoImage = UIImageView()
            adview.addSubview(logoImage);
            adview.adsy_platformLogoImageDarkMode(false) { (image) in
                guard let image = image else {
                    return
                }
                let maxWidth: CGFloat = 80.0;
                let logoHeight = maxWidth / image.size.width * image.size.height;
                logoImage.frame = CGRect(x: adWidth - maxWidth, y: adHeight - logoHeight, width: maxWidth, height: logoHeight)
            }
        }

    }
    
    // 3、上图下文
    func setUpUnifiedTopImageNativeAdView(adview : UIView & ADSuyiAdapterNativeAdViewDelegate) {
        // 设计的adView实际大小，其中宽度和高度可以自己根据自己的需求设置
        let adWidth:CGFloat = self.view.bounds.size.width
        let adHeight:CGFloat = (adWidth - 34.0) / 16.0 * 9.0 + 70
        adview.frame = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        

        // 显示logo图片（必要）
        if adview.adsy_platform() != ADSuyiAdapterPlatform.GDT {
            let logoImage = UIImageView()
            adview.addSubview(logoImage);
            adview.adsy_platformLogoImageDarkMode(false) { (image) in
                guard let image = image else {
                    return
                }
                let maxWidth: CGFloat = 80.0;
                let logoHeight = maxWidth / image.size.width * image.size.height;
                logoImage.image = image
                logoImage.frame = CGRect(x: adWidth - maxWidth, y: adHeight - logoHeight, width: maxWidth, height: logoHeight)
            }
        }
        
        // 设置主图/视频（主图可选，但强烈建议带上,如果有视频试图，则必须带上）
        let mainFrame:CGRect = CGRect.init(x: 17, y: 0, width: adWidth - 34.0, height: (adWidth - 34.0) / 16.0 * 9.0)
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
        
        // 设置广告标识（可选）
        let adlabel : UILabel = UILabel.init()
        adlabel.backgroundColor = UIColor.adsy_color(withHexString: "#CCCCCC")
        adlabel.textColor = UIColor.adsy_color(withHexString: "#FFFFFF")
        adlabel.font = UIFont.adsy_PingFangLightFont(12)
        adlabel.text = "广告"
        adview.addSubview(adlabel)
        adlabel.frame = CGRect.init(x: 17, y: (adWidth - 17 * 2) / 16.0 * 9 + 9, width: 36, height: 18)
        adlabel.textAlignment = NSTextAlignment.center
        
        // 设置广告描述(可选)
        let descLabel : UILabel = UILabel.init()
        descLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        descLabel.font = UIFont.adsy_PingFangLightFont(12)
        descLabel.textAlignment = NSTextAlignment.left
        descLabel.text = adview.data?.desc
        adview.addSubview(descLabel)
        descLabel.frame = CGRect.init(x: 17 + 36 + 4, y: (adWidth - 17 * 2) / 16.0 * 9 + 9, width: self.view.frame.size.width - 57 - 17 - 20, height: 18)
        
        // 设置标题文字（可选，但强烈建议带上）
        let titleLabel = UILabel.init()
        adview.addSubview(titleLabel)
        titleLabel.font = UIFont.adsy_PingFangMediumFont(14)
        titleLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        titleLabel.numberOfLines = 2
        titleLabel.text = adview.data?.title
        let size:CGSize = titleLabel.sizeThatFits(CGSize.init(width: adWidth - 34.0, height: 999))
        titleLabel.frame = CGRect.init(x: 17, y: adHeight-size.height, width: adWidth - 34.0, height: size.height)
        
    }
    
    func cleanAllAd() {
        if self.dataArray.count > 0 {
            for item : Any in self.dataArray {
                if item is ADSuyiAdapterNativeAdViewDelegate {
                    let itemObj = item as? ADSuyiAdapterNativeAdViewDelegate
                    if itemObj != nil {
                        itemObj?.adsy_unRegistView()
                    }
                }
                
            }
            self.dataArray.removeAll()
            self.mainTableView.reloadData()
        }
    }
    
    deinit {
        self.cleanAllAd()
    }
    
    func getCloseButtonWithAdItem(item:UIView & ADSuyiAdapterNativeAdViewDelegate)->UIButton{
        let closeButton = UIButton()
        //按钮位置根据需求自行设置
        closeButton.frame = CGRect(x:item.mj_w-44, y:0, width:44, height:44)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(item, action: #selector(item.adsy_close), for: .touchUpInside)
        return closeButton
    }

}
