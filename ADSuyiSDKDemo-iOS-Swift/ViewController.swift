//
//  ViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陈坤 on 2020/5/27.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private var mainTable:UITableView!
    private var dataArray: Array<String> = ["开屏广告 SplashAD","横幅广告 BannerAD","信息流广告(模板) NativeAD","信息流广告列表(自渲染) NativeAD","插屏广告 InterstitalAD","全屏视频 FullScreenVideoAD","沉浸式视频 DrawVideoAD","激励视频 RewardVideoAD"]
    private let tableViewCellID = "SimpleTableIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [NSString stringWithFormat:@"ADSuyiSDK-Demo-v%@",[ADSuyiSDK getSDKVersion]]
        self.title = NSString.init(format: "ADSuyiSDK-Demo-v%@", ADSuyiSDK.getVersion()) as String
        
        self.view.backgroundColor = UIColor.white
        
        
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    private func initTableView() {
        mainTable = UITableView.init(frame: self.view.bounds)
        mainTable.frame.origin.y = CGFloat(tabBarHeight)
        self.view.addSubview(mainTable)
        mainTable.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints:[NSLayoutConstraint] = [
            NSLayoutConstraint.init(item: mainTable!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: mainTable!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: mainTable!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: mainTable!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)]
        self.view.addConstraints(viewConstraints)
        
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.reloadData()
        
    }
    
    // mark - UITableViewDelegate/UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: .default, reuseIdentifier: tableViewCellID)
        let title = dataArray[indexPath.row]
        
        let view = cell.contentView.viewWithTag(999)
        if view != nil {
            view?.removeFromSuperview()
        }
        
        let labTitle = UILabel.init()
        labTitle.font = UIFont.adsy_PingFangRegularFont(14)
        labTitle.backgroundColor = UIColor.white
        labTitle.textAlignment = NSTextAlignment.center
        labTitle.tag = 999
        labTitle.textColor = UIColor.adsy_color(withHexString: "#666666")
        labTitle.text = title
        cell.contentView.addSubview(labTitle)
        labTitle.frame = CGRect.init(x: 16, y: 8, width: SCREEN_WIDTH - 32, height: 32)
        labTitle.layer.cornerRadius = 4
        labTitle.layer.borderWidth = 1
        labTitle.layer.borderColor = UIColor.adsy_color(withHexString: "#E5E5EA")?.cgColor
        labTitle.layer.shadowColor = UIColor.adsy_color(withHexString: "#000000", alphaComponent: 0.1)?.cgColor
        labTitle.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        labTitle.layer.shadowOpacity = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(ADSuyiSplashViewController.init(), animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(ADSuyiBannerViewController.init(), animated: true)
            break
        case 2:
            let nativeVC = AdSuyiNativeViewController.init()
            nativeVC.posid = "d4366018478613f768"
            self.navigationController?.pushViewController(nativeVC, animated: true)
            break
        case 3:
            let nativeVC = AdSuyiNativeViewController.init()
            nativeVC.posid = "26fe47d8b06658ace0"
            self.navigationController?.pushViewController(nativeVC, animated: true)
            break
        case 4:
            self.navigationController?.pushViewController(AdSuyiInterstitialViewController.init(), animated: true)
            break
        case 5:
            self.navigationController?.pushViewController(AdSuyiFullScreenVodViewController.init(), animated: true)
            break
        case 6:
            self.navigationController?.pushViewController(AdSuyiDrawVodViewController.init(), animated: true)
            break
        case 7:
            self.navigationController?.pushViewController(AdSuyiRewardViewController.init(), animated: true)
            break
        default:
            break
        }
    }


}

