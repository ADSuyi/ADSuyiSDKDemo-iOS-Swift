//
//  AdSuyiDrawVodViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/6/17.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class AdSuyiDrawVodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ADSuyiSDKDrawvodAdDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height - statusBarHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let adView = self.dataArray[indexPath.row]
        adView.tag = 999
        cell.contentView.addSubview(adView)
        adView.registView()
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let adView = cell.contentView.viewWithTag(999)
        if adView != nil {
            adView?.removeFromSuperview()
        }
        let arrAdView = self.dataArray[indexPath.row]
        arrAdView.unRegist()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adCell:UITableViewCell = self.mainTableView?.dequeueReusableCell(withIdentifier: tableViewCellInentifier, for: indexPath) ?? UITableViewCell.init()
        return adCell
    }
    
    func adsy_drawvodAdSuccess(toLoad drawvodAd: ADSuyiSDKDrawvodAd, drawvodAdArray drawvodAdViewArray: [ADSuyiAdapterDrawvodAdView]) {
        if drawvodAdViewArray.count > 0 {
            for adView:ADSuyiAdapterDrawvodAdView in drawvodAdViewArray {
                adView.render()
            }
        }
    }
    
    func adsy_drawvodAdFail(toLoad drawvodAd: ADSuyiSDKDrawvodAd, errorModel: ADSuyiAdapterErrorDefine) {
        
    }
    
    func adsy_drawvodAdSuccess(toRender drawvodAd: ADSuyiSDKDrawvodAd, view drawvodAdView: ADSuyiAdapterDrawvodAdView) {
        self.dataArray.append(drawvodAdView)
        self.mainTableView?.reloadData()
    }
    
    func adsy_drawvodAdFail(toRender drawvodAd: ADSuyiSDKDrawvodAd, view drawvodAdView: ADSuyiAdapterDrawvodAdView, error: Error?) {
        
    }
    
    func adsy_drawvodAdPlayerDidPlayFinish(_ drawvodAdView: ADSuyiAdapterDrawvodAdView) {
        
    }
    
    func adsy_drawvodAdDidExposure(_ drawvodAdView: ADSuyiAdapterDrawvodAdView) {
        
    }
    
    func adsy_drawvodAdDidClick(_ drawvodAdView: ADSuyiAdapterDrawvodAdView) {
        
    }
    
    private var dataArray:Array<ADSuyiAdapterDrawvodAdView> = Array.init()

    var drawvodAd : ADSuyiSDKDrawvodAd?
    var mainTableView : UITableView?
    
    let tableViewCellInentifier : String = "tableViewCellInentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setUpUI()
        
        loadDrawvodAd()
    }
    
    
    func setUpUI() {
        self.mainTableView = UITableView.init()
        self.mainTableView?.delegate = self
        self.mainTableView?.dataSource = self
        self.mainTableView?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: tabBarHeight), size: CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - statusBarHeight))
        
        self.mainTableView?.isPagingEnabled = true
        self.mainTableView?.showsVerticalScrollIndicator = false
        self.mainTableView?.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            self.mainTableView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.mainTableView?.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: tableViewCellInentifier)
        self.view.addSubview(self.mainTableView!)
        
        let btn = UIButton.init()
        self.view.addSubview(btn)
        btn.frame = CGRect.init(x: 22, y: 44, width: 44, height: 44)
        btn.setImage(UIImage.init(named: "close"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(closeCloseButton), for: .touchUpInside)
    }
    
    func loadDrawvodAd() {
        if drawvodAd == nil {
            self.drawvodAd = ADSuyiSDKDrawvodAd.init(size: CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height - statusBarHeight))
            self.drawvodAd?.posId = "16e160a112f019de2b"
            self.drawvodAd?.delegate = self
            self.drawvodAd?.controller = self
            self.drawvodAd?.tolerateTimeout = 4
        }
        
        self.drawvodAd?.load(3)
        
    }
    
    @objc func closeCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }

}
