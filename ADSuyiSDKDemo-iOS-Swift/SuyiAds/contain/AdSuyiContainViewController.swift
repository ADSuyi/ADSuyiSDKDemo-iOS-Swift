//
//  AdSuyiContainViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by Erik on 2021/4/27.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit

class AdSuyiContainViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "内容组件"
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
        
        let ecookLabel = UILabel.init()
        ecookLabel.textColor = UIColor.gray
        ecookLabel.text = "菜谱"
        self.view.addSubview(ecookLabel)
        ecookLabel.frame = CGRect.init(x: 30, y: 100, width: 100, height: 30)
        
        let ecookBtn = UIButton.init()
        ecookBtn.layer.cornerRadius = 10
        ecookBtn.clipsToBounds = true
        ecookBtn.backgroundColor = UIColor.white
        ecookBtn.setTitle("菜谱入口", for: .normal)
        ecookBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(ecookBtn)
        ecookBtn.frame = CGRect.init(x: 30, y: 140, width: UIScreen.main.bounds.size.width-60, height: 55)
        //        ecookBtn .addTarget(self, action: #selector(ecookBtnClick), for: .touchUpInside)
        ecookBtn.addTarget(self, action: #selector(ecookBtnClick), for: .touchUpInside)
        
        let ecookTabBtn = UIButton.init()
        ecookTabBtn.layer.cornerRadius = 10
        ecookTabBtn.clipsToBounds = true
        ecookTabBtn.backgroundColor = UIColor.white
        ecookTabBtn.setTitle("菜谱Tabbar", for: .normal)
        ecookTabBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(ecookTabBtn)
        ecookTabBtn.frame = CGRect.init(x: 30, y: 215, width: UIScreen.main.bounds.size.width-60, height: 55)
        ecookTabBtn.addTarget(self, action: #selector(ecookTabbarClick), for: .touchUpInside)
        
        
        let novelLabel = UILabel.init()
        novelLabel.textColor = UIColor.gray
        novelLabel.text = "小说"
        self.view.addSubview(novelLabel)
        novelLabel.frame = CGRect.init(x: 30, y: 295, width: 100, height: 30)
        
        let novelBtn = UIButton.init()
        novelBtn.layer.cornerRadius = 10
        novelBtn.clipsToBounds = true
        novelBtn.backgroundColor = UIColor.white
        novelBtn.setTitle("小说入口", for: .normal)
        novelBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(novelBtn)
        novelBtn.frame = CGRect.init(x: 30, y: 335, width: UIScreen.main.bounds.size.width-60, height: 55)
        novelBtn.addTarget(self, action: #selector(novelBtnClick), for: .touchUpInside)
        
        
        let novelTabBtn = UIButton.init()
        novelTabBtn.layer.cornerRadius = 10
        novelTabBtn.clipsToBounds = true
        novelTabBtn.backgroundColor = UIColor.white
        novelTabBtn.setTitle("小说tabbar", for: .normal)
        novelTabBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(novelTabBtn)
        novelTabBtn.frame = CGRect.init(x: 30, y: 410, width: UIScreen.main.bounds.size.width-60, height: 55)
        novelTabBtn.addTarget(self, action: #selector(novelTabbarBtnClick), for: .touchUpInside)
        //        ecookBtn .addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>), for: <#T##UIControl.Event#>), for: <#T##UIControl.Event#>)
        
    }
    
    @objc func ecookBtnClick() {
        
    }
    
    @objc func ecookTabbarClick() {
        
    }
    
    @objc func novelBtnClick() {
        var novelError:Error? = nil
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
    }
    
    @objc func novelTabbarBtnClick() {
        var novelError:Error? = nil
        let tabBarVc = UITabBarController.init()
        let blankVc = BlankViewController.init()
        blankVc.tabBarItem.title = "测试"
        blankVc.tabBarItem.image = UIImage.init(named: "blank")
        blankVc.tabBarItem.selectedImage = UIImage.init(named: "blank")
        let blankNav = UINavigationController.init(rootViewController: blankVc)
        //将内容SDK控制器作为底部分页 无需为containViewController添加导航栏控制器
        // 判断返回控制器是否有效
        if ADSuyiSDKContainAd.isValidController(with: ADSuyiContainVcType.tabBar) {
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
