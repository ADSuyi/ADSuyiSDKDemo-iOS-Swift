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
    private var dataArray: Array<String> = ["开屏广告","信息流广告","Banner横幅广告","激励视频","插屏广告","Draw视频","全屏视频","组合广告 GroupAd"]
    private let tableViewCellID = "SimpleTableIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [NSString stringWithFormat:@"ADSuyiSDK-Demo-v%@",[ADSuyiSDK getSDKVersion]]
        self.title = NSString.init(format: "ADmobile 广告聚合SDK Demo") as String
        
        self.view.backgroundColor = UIColor.white
        
        let setBtn = UIButton.init()
//        setBtn.setTitle("设置", for: .normal)
        setBtn.setTitleColor(UIColor.white, for: .normal)
        setBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setBtn.setImage(UIImage.init(named: "set"), for: .normal)
        setBtn.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        setBtn.addTarget(self, action: #selector(setBtnClick), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: setBtn)
        self.navigationItem.rightBarButtonItem = rightItem;
        
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    @objc func setBtnClick()  {
        self.navigationController?.pushViewController(SetTableViewController(), animated: true)
    }
    
    private func initTableView() {
        mainTable = UITableView.init(frame: self.view.bounds)
        mainTable.frame.origin.y = CGFloat(tabBarHeight)
        mainTable.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
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
        mainTable.separatorStyle = .none;
        mainTable.reloadData()
        
    }
    
    // mark - UITableViewDelegate/UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel.init()
        label.textAlignment = .center
        label.text = ADSuyiSDK.getVersion()
        label.textColor = UIColor.init(red: 36/255.0, green: 132/255.0, blue: 207/255.0, alpha: 1);
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: .default, reuseIdentifier: tableViewCellID)
        let title = dataArray[indexPath.row]
        cell.contentView.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        cell.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.contentView.clipsToBounds = true
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
        labTitle.clipsToBounds = true
        cell.contentView.addSubview(labTitle)
        labTitle.frame = CGRect.init(x: 16, y: 8, width: SCREEN_WIDTH - 32, height: 55)
        labTitle.layer.cornerRadius = 10
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
            self.navigationController?.pushViewController(AdSuyiNativeMainViewController.init(), animated: true)
            break
        case 2:
            self.navigationController?.pushViewController(ADSuyiBannerViewController.init(), animated: true)
            break
        case 3:
            self.navigationController?.pushViewController(AdSuyiRewardViewController.init(), animated: true)
            break
        case 4:
            self.navigationController?.pushViewController(AdSuyiInterstitialViewController.init(), animated: true)
            break
        case 5:
            self.navigationController?.pushViewController(AdSuyiDrawVodViewController.init(), animated: true)
            break
        case 6:
            self.navigationController?.pushViewController(AdSuyiFullScreenVodViewController.init(), animated: true)
            break
        case 7:
            let vc = ADSuyiGroupAdViewController()
            vc.nativePosid = "e9eaffb6b9d97cd813"
            vc.rewardPosid = "47d196ffaaa92ae93c"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }


}

