//
//  ADSuyiSkipView.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by Erik on 2021/5/8.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit

class ADSuyiSkipView: UIView,ADSuyiAdapterSplashSkipViewProtocol {
    
    var titleLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = self.frameForContainer()
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setLifeTime(_ lifeTime: Int) {
        
        DispatchQueue.global().async {
            DispatchQueue.main.async { [self] in
                if self.titleLabel == nil {
                    self.titleLabel = UILabel.init()
                    self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    self.titleLabel?.textColor = UIColor.red
                    self.titleLabel?.textAlignment = .center
                    self.addSubview(self.titleLabel!)
                }
                if lifeTime > 0 {
                    self.titleLabel?.text = "\(lifeTime) | 关闭"
                } else {
                    self.titleLabel?.text = "关闭"
                }
            }
        }
        
        
    }
    
    func frameForContainer() -> CGRect  {
        let skipViewWidth:CGFloat = 80
        let skipViewHeight:CGFloat = 40
        let skipViewRightMargin:CGFloat = 12
        let skipViewTopMargin:CGFloat = 8
        // 状态栏高度  此处未作是否刘海屏幕判断
        let statusBarHeight:CGFloat = 44
        let y = statusBarHeight + skipViewTopMargin
        let x = UIScreen.main.bounds.size.width - skipViewRightMargin - skipViewWidth
        return CGRect.init(x: x, y: y, width: skipViewWidth, height: skipViewHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = self.bounds
    }

}
