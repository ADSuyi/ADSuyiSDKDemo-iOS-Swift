//
//  AdSuyiBaseContentViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陶冶明 on 2021/2/18.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit

class AdSuyiBaseContentViewController: UIViewController {

    var vc: UIViewController? = nil
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let vc = self.vc {
            self.addChild(vc)
            self.view.addSubview(vc.view)
            vc.view.frame = self.view.frame
            vc.didMove(toParent: self)
        }
        configBackButtonInFullScreen()
        
        super.viewDidLoad()
    }
    
    func configBackButtonInFullScreen() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "close"), for: .normal)
        self.view.addSubview(backButton)
        backButton.frame = CGRect(x: 20, y: 60, width: 44, height: 44)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
}
