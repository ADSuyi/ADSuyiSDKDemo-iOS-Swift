//
//  AdSuyiContentViewController.swift
//  ADSuyiSDKDemo-iOS-Swift
//
//  Created by 陶冶明 on 2021/2/18.
//  Copyright © 2021 陈坤. All rights reserved.
//

import UIKit


class AdSuyiContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ADSuyiSDKContentAdDelegate {
    
    var _contentAdWidth = 0.0
    var _contentAdHeight = 0.0

    let tableView = UITableView()
    var items = Array<UIView&ADSuyiSDKContentAdViewProtocol>()
    var contentAd: ADSuyiSDKContentAd? = nil
    let contentView: (UIView&ADSuyiSDKContentAdViewProtocol)? = nil
    
    let customBtn = UIButton.init()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.items.removeAll()
            self?.tableView.reloadData()
            self?.loadContentAd()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadContentAd()
        })
        self.loadContentAd()
        customBtn.setTitle("自定义视图进入内容视频页", for: .normal)
        customBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        customBtn.backgroundColor = UIColor.lightGray
        customBtn.layer.cornerRadius = 4
        customBtn.addTarget(self, action: #selector(entryContentVc), for: .touchUpInside)
        self.view.addSubview(customBtn)
        customBtn.frame = CGRect.init(x: UIScreen.main.bounds.size.width/2 - 100, y: UIScreen.main.bounds.size.height - 80, width: 200, height: 50)
        self.view.bringSubviewToFront(customBtn)
    }
// MARK:Action
    
    @objc func entryContentVc() {
        if self.items.first == nil {
            self.view.makeToast("内容视频加载失败")
            return
        }
        contentAd?.clickContentPage(withContentView: self.items.first!)
    }
    
    func loadContentAd() {
        if(contentAd == nil) {
            contentAd = ADSuyiSDKContentAd()
            contentAd!.delegate = self
            contentAd!.posId = "7d4b7081b1cb1467aa"
        }
        contentAd!.load()
    }

    // MARK: tableview delegate datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        return item.contentAdSize.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.contentView.addSubview(item)
        item.frame = CGRect(x: 0, y: 0, width: item.contentAdSize.width, height: item.contentAdSize.height)
        return cell!
    }

    // MARK: - ADSuyiContentAdDelegate
    
    func adsy_contentAdSucess(toLoad contentAd: ADSuyiSDKContentAd, contentAdView: UIView & ADSuyiSDKContentAdViewProtocol) {
        contentAdView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        contentAdView.backgroundColor = .red
        contentAdView.adsy_registView(nil)
        self.items.append(contentAdView)
        self.tableView.reloadData();
        self.tableView.mj_header?.endRefreshing()
        self.tableView.mj_footer?.endRefreshing()
    }

    func adsy_contentAdFail(toLoad contentAd: ADSuyiSDKContentAd, errorModel: ADSuyiAdapterErrorDefine) {
        self.tableView.mj_header?.endRefreshing()
        self.tableView.mj_footer?.endRefreshing()
    }
    func adsy_contentAdClicked(_ contentAd: ADSuyiSDKContentAd, contentDetailPage contentPageVc: UIViewController) {
        let contentVC = AdSuyiBaseContentViewController()
        contentVC.vc = contentPageVc
        self.navigationController?.pushViewController(contentVC, animated: true)
    }

}
