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
                if item.renderType() == ADSuyiAdapterRenderType.native {
                    
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
        for i in 0...self.dataArray.count {
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
            let obj = item as! UIView
            obj.tag = 999
            cell.contentView.addSubview(obj)
            
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
        
    }
    
    
    @objc func headerRefresh() {
        cleanAllAd()
        loadNativeAd()
    }
    
    @objc func footerRefresh() {
        loadNativeAd()
    }
    
    func loadNativeAd() {
        if nativeAd == nil {
            self.nativeAd = ADSuyiSDKNativeAd.init(adSize: CGSize.init(width: self.view.bounds.size.width, height: 10))
            self.nativeAd.posId = self.posid
            self.nativeAd.delegate = self
            self.nativeAd.controller = self
            self.nativeAd.tolerateTimeout = 4
        }
        self.nativeAd.load(1)
    }
    
    func setUpUnifiedNativeAdView(adview : UIView & ADSuyiAdapterNativeAdViewDelegate) {
        let adWidth:CGFloat = self.view.bounds.size.width
        let adHeight:CGFloat = (adWidth - 34.0) / 16.0 * 9.0 + 67 + 38
        adview.frame = CGRect.init(x: 0, y: 0, width: adWidth, height: adHeight)
        
        let titleLabel = UILabel.init()
        adview.addSubview(titleLabel)
        titleLabel.font = UIFont.adsy_PingFangMediumFont(14)
        titleLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        titleLabel.numberOfLines = 2
        titleLabel.text = adview.data?.title
        let size:CGSize = titleLabel.sizeThatFits(CGSize.init(width: adWidth - 34.0, height: 999))
        titleLabel.frame = CGRect.init(x: 17, y: 16, width: adWidth - 34.0, height: size.height)
        
        var height:CGFloat = size.height + 16 + 15
        
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
        
        let adlabel : UILabel = UILabel.init()
        adlabel.backgroundColor = UIColor.adsy_color(withHexString: "#CCCCCC")
        adlabel.textColor = UIColor.adsy_color(withHexString: "#FFFFFF")
        adlabel.font = UIFont.adsy_PingFangLightFont(12)
        adlabel.text = "广告"
        adview.addSubview(adlabel)
        adview.frame = CGRect.init(x: 17, y: height, width: 36, height: 18)
        adlabel.textAlignment = NSTextAlignment.center
        
        let descLabel : UILabel = UILabel.init()
        descLabel.textColor = UIColor.adsy_color(withHexString: "#333333")
        descLabel.font = UIFont.adsy_PingFangLightFont(12)
        descLabel.textAlignment = NSTextAlignment.left
        descLabel.text = adview.data?.desc
        adview.addSubview(descLabel)
        descLabel.frame = CGRect.init(x: 17 + 36 + 4, y: height, width: self.view.frame.size.width - 57 - 17 - 20, height: 18)
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

}
