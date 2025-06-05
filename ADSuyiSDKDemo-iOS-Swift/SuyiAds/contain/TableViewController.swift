//
//  TableViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 技术 on 2020/10/29.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit
class TableViewController: UITableViewController {

    var typeArray = NSArray.init()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "内容SDK接入类型"
        self.tableView.backgroundColor = UIColor.white
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView .register(UITableViewCell.self, forCellReuseIdentifier: "containType")
        self.typeArray = ["仅内容控制器","带导航栏内容控制器","带底部栏内容控制器","内容控制器做子控制器"]
        // Do any additional setup after loading the view.
    }
    #warning("初次初始化SDK 可能因网络权限获取等原因导致SDK初始化失败 init error")
    #warning("SDK初始化失败 接入内容控制器将无法显示数据 建议在接入时对SDK初始化状态做判断并对返回值类型判断")

    // MARK: - tableview delegate datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==1 {
            return 2
        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "containType", for: indexPath)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "containType")
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let labelTitle = UILabel.init()
        labelTitle.font = UIFont.adsy_PingFangRegularFont(14)
        labelTitle.backgroundColor = UIColor.white
        labelTitle.textAlignment = NSTextAlignment.center
        labelTitle.textColor = UIColor.adsy_color(withHexString: "#666666")
        labelTitle.tag = 999
        if indexPath.section==0 {
            switch indexPath.row {
            case 0:
                labelTitle.text = self.typeArray[0] as? String
                break
            case 1:
                labelTitle.text = self.typeArray[2] as? String
                break
            default:
                labelTitle.text = self.typeArray[3] as? String
            }
        }else{
            switch indexPath.row {
            case 0:
                labelTitle.text = self.typeArray[0] as? String
                break
            case 1:
                labelTitle.text = self.typeArray[2] as? String
            default:
                break
            }
        }
        cell.contentView.addSubview(labelTitle)
        labelTitle.frame = CGRect.init(x: 16, y: 8, width: self.view.bounds.size.width-32, height: 32)
        labelTitle.layer.cornerRadius = 4
        labelTitle.layer.borderWidth = 1
        labelTitle.layer.borderColor = UIColor.adsy_color(withHexString: "#E5E5EA")?.cgColor
        labelTitle.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        labelTitle.layer.shadowOpacity = 1
        cell.contentView.addSubview(labelTitle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var novelError:Error? = nil
        if indexPath.section==0 {
            // push方式
            switch indexPath.row {
            case 0:
                // 仅内容控制器
                // 判断返回控制器是否有效
                if ADSuyiSDKContainAd.isValidController(with: ADSuyiContainVcType.push) {
                    var containVc = UIViewController.init()
                    do {
                        try containVc =  ADSuyiSDKContainAd.containViewController(with: ADSuyiContainVcType.push)
                    } catch {
                        novelError = error
                    }
                    if novelError == nil {
                        self.navigationController?.pushViewController(containVc, animated: true)
                    }
                }
                break
            case 1:
                let tabBarVc = UITabBarController.init()
                let blankVc = BlankViewController.init()
                blankVc.tabBarItem.title = "返回页"
                blankVc.tabBarItem.image = UIImage.init(named: "blank")
                blankVc.tabBarItem.selectedImage = UIImage.init(named: "blank")
                let blankNav = UINavigationController.init(rootViewController: blankVc)
                //将内容SDK控制器作为底部分页 无需为containViewController添加导航栏控制器
                // 判断返回控制器是否有效
                if ADSuyiSDKContainAd.isValidController(with: ADSuyiContainVcType.push) {
                    var containVc = UIViewController.init()
                    do {
                        try containVc =  ADSuyiSDKContainAd.containViewController(with: ADSuyiContainVcType.push)
                    } catch {
                        novelError = error
                    }
                    // 如果无错误
                    if novelError == nil {
                        containVc.tabBarItem.title = "内容页"
                        containVc.tabBarItem.image = UIImage.init(named: "contain")
                        containVc.tabBarItem.selectedImage = UIImage.init(named: "contain")
                        containVc.title = "内容页"
                        tabBarVc .addChild(containVc)
                    }
                    tabBarVc.addChild(blankNav)
                    self.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.pushViewController(tabBarVc, animated: true)
                }
                break
            case 2:
                //内容控制器作为子控制器
                 // 判断返回控制器是否有效
                if ADSuyiSDKContainAd.isValidController(with: ADSuyiContainVcType.push) {
                    var containVc = UIViewController.init()
                    do {
                        try containVc =  ADSuyiSDKContainAd.containViewController(with: ADSuyiContainVcType.push)
                    } catch {
                        novelError = error
                    }
                    if novelError == nil {
                        self .addChild(containVc)
                        self.navigationController?.pushViewController(self.children[0], animated: true)
                    }
                }
                break
                
            default:
                break
            }
        }else {
            //推出方式 present
            switch indexPath.row {
            case 0:
                //仅内容控制器 不建议使用present方式推出（显示时按钮点击 针对push有效）
                // 判断返回控制器是否有效
                if ADSuyiSDKContainAd.isValidController(with: ADSuyiContainVcType.present) {
                    var containVc = UIViewController.init()
                    do {
                        try containVc =  ADSuyiSDKContainAd.containViewController(with: ADSuyiContainVcType.present)
                    } catch {
                        novelError = error
                    }
                    if novelError == nil {
                        containVc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        self.present(containVc, animated: true, completion: nil)
                    }
                }
                break
            case 1:
                //带底部栏的内容控制器 一般使tabBar作为根控制器 此处示例作为present推出
                let tabBarVc = UITabBarController.init()
                let blankVc = BlankViewController.init()
                blankVc.tabBarItem.title = "返回页"
                blankVc.tabBarItem.image = UIImage.init(named: "blank")
                blankVc.tabBarItem.selectedImage = UIImage.init(named: "blank")
                let blankNav = UINavigationController.init(rootViewController: blankVc)
                //若将内容SDK作为底部分页 无需为内容控制器添加导航栏
                // 判断返回控制器是否有效
                if ADSuyiSDKContainAd.isValidController(with: ADSuyiContainVcType.present) {
                    var containVc = UIViewController.init()
                    do {
                        try containVc =  ADSuyiSDKContainAd.containViewController(with: ADSuyiContainVcType.push)
                    } catch {
                        novelError = error
                    }
                    // 如果无错误
                    if novelError == nil {
                        containVc.tabBarItem.title = "内容页"
                        containVc.tabBarItem.image = UIImage.init(named: "contain")
                        containVc.tabBarItem.selectedImage = UIImage.init(named: "contain")
                        containVc.title = "内容页"
                        tabBarVc .addChild(containVc)
                    }
                    tabBarVc.addChild(blankNav)
                    tabBarVc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    self.present(tabBarVc, animated: true, completion: nil)
                }
                break
            default:
                break
            }
            
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.adsy_color(withHexString: "#666666")
        label.textAlignment = NSTextAlignment.center
        if section==0 {
            label.text = "push方式接入"
        }else{
            label.text = "present方式接入"
        }
        return label
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
