//
//  BlankViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 技术 on 2020/10/29.
//  Copyright © 2020 陈坤. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试"
        self.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.init(red: 225/255.0, green: 233/255.0, blue: 239/255.0, alpha: 1)
        let backBtn = UIButton.init()
        backBtn.setTitle("返回上一级", for: UIControl.State.normal)
        backBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        backBtn.titleLabel?.textAlignment = NSTextAlignment.center
        backBtn.layer.borderColor = UIColor.gray.cgColor
        backBtn.layer.borderWidth = 1
        backBtn.layer.cornerRadius = 3
        backBtn.addTarget(self, action: #selector(backBtnClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.frame = CGRect.init(x: UIScreen.main.bounds.width/2-60, y: UIScreen.main.bounds.height/2-10, width: 120, height: 30)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func backBtnClick() {
        
        if self.tabBarController?.presentedViewController == nil {
            self.tabBarController?.navigationController?.popViewController(animated: true)
        }
        self.tabBarController?.dismiss(animated: true, completion: nil)
        
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
