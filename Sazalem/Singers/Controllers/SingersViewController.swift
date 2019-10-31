//
//  SingersViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 12/29/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SingersViewController : UIViewController, GADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    let cellID = "searchCellID"
    var page = 1
    var singers = [Singer]()
    
    lazy var tableView : UITableView = {
        let tb = UITableView()
        
        tb.delegate = self
        tb.dataSource = self
        
        return tb
    }()
    
    lazy var adBanner : GADBannerView = {
        let banner = GADBannerView()
        
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-7813891820290008/5100467809"
        banner.rootViewController = self
        banner.backgroundColor = UIColor.lightGray
        
        return banner
    }()
    
    func prepareAdBanner() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(adBanner)
        adBanner.snp.makeConstraints { (make) in
            //make.bottom.equalToSuperview()
            make.top.equalTo(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Әншілер"
        
        tableView.contentInset = UIEdgeInsets(top: 55, left: 0, bottom: 0, right: 0)
        tableView.register(SingersViewCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        
        prepareAdBanner()
        
        loadSingers(page: 1)
        
        if !UserDefaults.standard.bool(forKey: "isUserSubbed") {
            let request = GADRequest()
            adBanner.load(request)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SingersViewCell
        
        if indexPath.row == singers.count - 1 {
            loadSingers(page: page)
        }
        
        cell.number.text = "\(indexPath.row + 1)."
        cell.textLabel?.text = singers[indexPath.row].author
        cell.singerID = singers[indexPath.row].id
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        navigationItem.title = "Әншілер"
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Singers page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        /*
        if let popupHeight = tabBarController?.popupBar.frame.height {
            adBanner.snp.remakeConstraints({ (make) in
                //make.bottom.equalTo(-popupHeight)
                make.top.equalTo(0)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            })
        }
 */
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let singerDetailViewController = SingerDetailViewController()
        singerDetailViewController.singerAlbumArt = singers[indexPath.row].singer_picture
        singerDetailViewController.singerID = singers[indexPath.row].id
        singerDetailViewController.singerNameString = singers[indexPath.row].author
        navigationItem.title = ""
        navigationController?.pushViewController(singerDetailViewController, animated: true)
    }
}
