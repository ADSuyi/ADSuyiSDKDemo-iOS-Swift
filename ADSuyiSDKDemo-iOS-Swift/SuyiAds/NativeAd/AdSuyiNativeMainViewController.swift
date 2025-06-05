//
//  AdSuyiNativeMainViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 技术2 on 2022/2/15.
//  Copyright © 2022 陈坤. All rights reserved.
//

import UIKit

class AdSuyiNativeMainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private var mainTable:UITableView!
    private var dataArray: Array<String> = ["原生信息流广告","信息流开屏广告","信息流插屏广告"]
    private let tableViewCellID = "SimpleTableIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSString.init(format: "信息流广告") as String
        
        self.view.backgroundColor = UIColor.white
        
        initTableView()
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
            let nativeVC = AdSuyiNativeViewController.init()
            nativeVC.posid = "177a790a315eeb7053"
            self.navigationController?.pushViewController(nativeVC, animated: true)
            break
        case 1:
            let nativeVC = ADSuyiNativeSplashViewController.init()
            self.navigationController?.pushViewController(nativeVC, animated: true)
            break
        case 2:
            self.navigationController?.pushViewController(NativeInterstitialAdViewController.init(), animated: true)
            break
        default:
            break
        }
    }


}

