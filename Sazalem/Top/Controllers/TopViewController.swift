//
//  TopViewController.swift
//  Sazalem
//
//  Created by Гани Мырзамуратов on 4/24/19.
//  Copyright © 2019 Gani Myrzamurat. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import AVFoundation
import LNPopupController
import GoogleMobileAds
import Alamofire
import SwiftyJSON
import MediaPlayer

var isTopPrevButtonPressed = false

var topTimer : Timer?

class TopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    let cellID = "topCellID"
    var songs = [Song]()
    
    var isQueued = false
    var nextSongID : Int?
    var page = 0
    var loadedSongs = [Song]()
    var index : Int?
    var currentSongName : String?
    var currentSingerName : String?
    var currentSongId : Int?
    
    
    lazy var adBanner : GADBannerView = {
        let banner = GADBannerView()
        
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-7813891820290008/1867799805"
        banner.rootViewController = self
        banner.backgroundColor = UIColor.lightGray
        
        return banner
    }()
    
    let cover : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tb = UITableView()
        
        tb.delegate = self
        tb.dataSource = self
        
        return tb
    }()
    
    func setupViews() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(-20)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(cover)
        cover.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        // Әнді көрсететін баннер
        /*
         view.addSubview(currentSongView)
         currentSongView.snp.makeConstraints { (make) in
         make.top.equalTo(15)
         make.left.right.equalToSuperview()
         make.height.equalTo(50)
         }*/
        // Жарнама
        if !UserDefaults.standard.bool(forKey: "isUserSubbed") {
            view.addSubview(adBanner)
            adBanner.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                //make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Top song page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        view.backgroundColor = .white
        
        navigationItem.title = "Үздік әндер"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .done, target: self, action: #selector(handleSerchButton))
        configureNavigationBar()
        setupViews()
        
        if !UserDefaults.standard.bool(forKey: "isUserSubbed") {
            tableView.contentInset = UIEdgeInsets(top: 85, left: 0, bottom: 0, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        tableView.register(TopViewCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        
        indicator.setBackgroundColor(.clear)
        indicator.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 50))
        
        loadTopSongs(page: page)
        
        if !UserDefaults.standard.bool(forKey: "isUserSubbed") {
            let request = GADRequest()
            adBanner.load(request)
        }
        
        //SubscriptionService.shared.getSubscription()
    }
    
    @objc
    func handleSerchButton() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TopViewCell
        
        if indexPath.row == songs.count - 1 {
            loadTopSongs(page: page)
        }
        
        cell.textLabel?.text = songs[indexPath.row].song_name
        cell.detailTextLabel?.text = songs[indexPath.row].singer_name
        if let stringUrl = songs[indexPath.row].singer_picture {
            if let url = URL(string: stringUrl) {
                cell.profileImage.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        topTimer?.invalidate()
        favTimer?.invalidate()
        searchTimer?.invalidate()
        singerDetailsTimer?.invalidate()
        
        index = indexPath.row
        currentSongName = songs[indexPath.row].song_name
        currentSingerName = songs[indexPath.row].singer_name
        currentSongId = songs[indexPath.row].id
        
        //loadSong(song: songs[indexPath.row])
        
        topTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatePlayerTime), userInfo: nil, repeats: true)
        
        //currentSongView.singerName.text = songs[indexPath.row].singer_name
        //currentSongView.songName.text = songs[indexPath.row].song_name
        
        musicViewController.setSong(ind: indexPath.row, song: songs)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tabBarController?.popupInteractionStyle = .drag
        tabBarController?.popupBar.barStyle = .compact
        tabBarController?.popupBar.progressViewStyle = .top
        tabBarController?.popupContentView.popupCloseButtonStyle = .chevron
        
        musicViewController.page = page - 1
        
        tabBarController?.presentPopupBar(withContentViewController: musicViewController, animated: true, completion: nil)
        
        /*
        //if let popupHeight = tabBarController?.popupBar.frame.height {
        adBanner.snp.remakeConstraints({ (make) in
            //make.bottom.equalTo(-popupHeight)
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        })
        //}*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay:
                musicViewController.playMusic()
            case .remoteControlPause:
                musicViewController.pauseMusic()
            case .remoteControlNextTrack:
                musicViewController.handleNextButton()
            case .remoteControlPreviousTrack:
                musicViewController.handlePrevButton()
            case .remoteControlTogglePlayPause:
                break
            default:
                break
            }
        }
    }
    
    func loadTopSongs(page : Int) {
        
        indicator.setDefaultStyle(.dark)
        indicator.setDefaultMaskType(.black)
        indicator.show(withStatus: "Күте тұрыңызшы...")
        //let song = Song()
        //let url = "http://sazalem.kz/api/ko_last_songs_v4.php?lang=kz&page=\(page)&sazalem_id=0"
        //let url = "http://sazalem.kz/api/ka_and_last_songs_v2.php?lang=kz&page=\(page)&sazalem_id=0"
        let url = "http://sazalem.kz/api/ka_get_top_songs_v1.php?lang=kz&page=\(page)"
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for song in json["results"][1]["lyrics"].arrayValue {
                        let temp = Song()
                        
                        temp.id = song["id"].intValue
                        temp.song_name = song["song_name"].stringValue
                        temp.singer_name = song["singer_name"].stringValue
                        temp.singer_id = song["singer_id"].intValue
                        temp.singer_picture = song["song_picture"].stringValue
                        temp.song_text = song["song_text"].stringValue
                        temp.audio = song["stream"].stringValue
                        temp.like = song["like"].intValue
                        temp.dislike = song["dislike"].intValue
                        
                        self.songs.append(temp)
                        
                    }
                    
                    indicator.dismiss(completion: {
                        self.tableView.reloadData()
                    })
                    self.page += 1
                }
            }
        }
    }
    
    @objc
    func updatePlayerTime() {
        
        if currentSongId != songs[index!].id {
            self.index = musicViewController.index
            currentSongId = songs[index!].id
            
            currentSongName = songs[self.index!].song_name
            currentSingerName = songs[self.index!].singer_name
            
        } else {
            
            if avPlayer.isPlaying() {
                
                if isTopPrevButtonPressed {
                    
                    musicViewController.playPrevSong()
                    
                    self.index = musicViewController.index
                    currentSongId = songs[self.index!].id
                    
                    currentSongName = songs[self.index!].song_name
                    currentSingerName = songs[self.index!].singer_name
                    isTopPrevButtonPressed = false
                }
                
                if isNextButtonPressed {
                    musicViewController.playNextSong()
                    
                    self.index = musicViewController.index
                    currentSongId = songs[self.index!].id
                    
                    currentSongName = songs[self.index!].song_name
                    currentSingerName = songs[self.index!].singer_name
                    
                    isNextButtonPressed = false
                }
                
            }
        }
        
    }
    
    func loadSong(song : Song) {
        
        if song.download_link == nil {
            
            indicator.setDefaultStyle(.dark)
            indicator.setDefaultMaskType(.black)
            indicator.show(withStatus: "Күте тұрыңызшы...")
            let id = song.id!
            let url = "http://sazalem.kz/api/ko_get_song_by_id_v2.php?key=\(id)"
            Alamofire.request(url).responseJSON { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let temp = json["results"][0]["lyrics"][0]
                        
                        song.id          = temp["id"].intValue
                        song.song_name   = temp["song_name"].stringValue
                        song.singer_name = temp["singer_name"].stringValue
                        song.singer_id   = temp["singer_id"].intValue
                        song.singer_picture = temp["singer_picture"].stringValue
                        song.song_text      = temp["song_text"].stringValue
                        song.download_link   = temp["audio"].stringValue
                        song.like    = temp["like"].intValue
                        song.dislike = temp["dislike"].intValue
                        
                        indicator.dismiss(completion: {
                            musicViewController.updateUI()
                            self.tableView.reloadData()
                        })
                    }
                } else {
                    print("Error loading song by id: ", id)
                }
            }
            
        }
        
    }
    
}
