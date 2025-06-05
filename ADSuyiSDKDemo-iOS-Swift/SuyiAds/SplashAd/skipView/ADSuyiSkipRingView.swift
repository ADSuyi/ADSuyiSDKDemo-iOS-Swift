//
//  ADSuyiSkipRingView.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by Erik on 2021/5/8.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation
class ADSuyiSkipRingView: UIView ,ADSuyiAdapterSplashSkipViewProtocol{
    
    var progress:NSInteger? {
        didSet {
            percentage?.text = "\(String(describing: progress))"
        }
    }
    var percentage:UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frameForContainer()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.clear
        if percentage == nil {
            percentage = UILabel.init(frame: self.bounds)
            percentage?.font = UIFont.boldSystemFont(ofSize: 12.0)
            percentage?.textColor = UIColor.orange
            percentage?.textAlignment = .center
        }
        self.addSubview(percentage!)
    }
    
    override func draw(_ rect: CGRect) {
        let backgroundPath = UIBezierPath.init()
        backgroundPath.lineWidth = 5.0
        UIColor.white.set()
        backgroundPath.lineCapStyle = .round
        backgroundPath.lineJoinStyle = .round
        
        let radius:CGFloat = (rect.size.height-5.0)*0.5
        backgroundPath.addArc(withCenter: CGPoint.init(x: rect.size.width*0.5, y: rect.size.height*0.5), radius: radius, startAngle: CGFloat(-M_PI*0.5), endAngle: CGFloat(-M_PI*0.5 + M_PI*2), clockwise: true)
        backgroundPath.stroke()
        
        let ringPath = UIBezierPath.init()
        ringPath.lineWidth = 5.0
        UIColor.orange.set()
        ringPath.lineCapStyle = .round
        ringPath.lineJoinStyle = .round
        let progressFloat = CGFloat(progress!)
        ringPath.addArc(withCenter: CGPoint.init(x: rect.size.width*0.5, y: rect.size.height*0.5), radius: radius, startAngle: CGFloat(-M_PI*0.5), endAngle: CGFloat(-M_PI*0.5) + CGFloat(M_PI*2*(Double(progressFloat)/4.0)), clockwise: true)
        ringPath.stroke()
    }
    
    
    func setLifeTime(_ lifeTime: Int) {
        progress = lifeTime
        setNeedsDisplay()
    }
    
    func frameForContainer() -> CGRect  {
        let skipViewWidth:CGFloat = 40
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
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
