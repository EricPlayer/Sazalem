//
//  SingerDetailViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 12/29/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

var singerDetailsTimer : Timer?

class SingerDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    let cellID = "singerDetailCellID"
    var imageViewStop : CGFloat = 0.0
    var tableViewStop : CGFloat = 0.0
    let offset_B_LabelHeader:CGFloat = 136.0
    let distance_W_LabelHeader:CGFloat = 35.4
    var navBarHeight : CGFloat = 0.0
    var imageHeight : CGFloat = 0.0
    var index : Int?
    var singerDetailsCurrentSongName : String?
    var singerDetailsCurrentSingerName : String?
    var currentSongId : Int?
    
    var singerID : Int? {
        didSet {
            loadSingerSongs()
        }
    }
    
    var singerNameString : String? {
        didSet {
            singerName.text = singerNameString
            navBarSingerLabel.text = singerNameString
        }
    }
    
    var songs = [Song]() {
        didSet {
            songsCount.text = "\(songs.count) ән"
            tableView.reloadData()
        }
    }
    
    var singerAlbumArt : String? {
        didSet {
            if let singerAlbumArt = singerAlbumArt {
                if let url = URL(string: singerAlbumArt) {
                    imageView.kf.setImage(with: url)
                }
            }
        }
    }
    
    lazy var tableView : UITableView = {
        let tb = UITableView()
        
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        
        return tb
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let bluredImageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .white
        imageView.alpha = 0
        
        return imageView
    }()
    
    let singerName : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .blue
        
        return label
    }()
    
    let navBarSingerLabel : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blue
        
        return label
    }()
    
    let songsCount : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .blue
        
        return label
    }()
    
    let topCurrentTrackView : CurrentTrackView = {
        let view = CurrentTrackView()
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        
        return view
    }()
    
    func setupViews() {
        let imageViewHeight = view.frame.height * 0.35
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }
        
        imageView.addSubview(singerName)
        singerName.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview().offset(-10)
        }

        imageView.addSubview(songsCount)
        songsCount.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview().offset(10)
        }
        
        imageView.addSubview(bluredImageView)
        bluredImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }

        bluredImageView.addSubview(navBarSingerLabel)
        navBarSingerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(70)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(topCurrentTrackView)
        topCurrentTrackView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Singer detail page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        self.transparentNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        navBarHeight = navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        setupViews()
        view.backgroundColor = .white
        tableView.register(SingerDetailViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SingerDetailViewCell
        
        cell.textLabel?.text = songs[indexPath.row].song_name
        cell.detailTextLabel?.text = singerNameString
        cell.id = songs[indexPath.row].id
        cell.index = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTimer?.invalidate()
        searchTimer?.invalidate()
        favTimer?.invalidate()
        singerDetailsTimer?.invalidate()
        
        if songs[indexPath.row].audio != nil && songs[indexPath.row].audio != "" {
            
            index = indexPath.row
            
            currentSongId = songs[indexPath.row].id
            
            musicViewController.setSong(ind: indexPath.row, song: songs)
            

            singerDetailsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatePlayerTime), userInfo: nil, repeats: true)
            
            tabBarController?.popupInteractionStyle = .drag
            tabBarController?.popupBar.barStyle = .compact
            tabBarController?.popupBar.progressViewStyle = .top
            tabBarController?.popupContentView.popupCloseButtonStyle = .chevron
            
            musicViewController.popupItem.leftBarButtonItems?.first?.image = UIImage(named: "pause")
            musicViewController.pauseButton.setImage(UIImage(named: "big_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            tabBarController?.presentPopupBar(withContentViewController: musicViewController, animated: true, completion: nil)
            
            let bottomMargin = tabBarController!.popupBar.frame.height
            
            self.tableView.snp.remakeConstraints({ (make) in
                make.top.equalTo(topCurrentTrackView.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(-bottomMargin)
            })
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

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
    
    @objc
    func updatePlayerTime() {
        
        let intTime = avPlayer.getCurrentTimeSecond()
        
        let minute = Int(intTime / 60)
        let second = Int(intTime - minute*60)

        if second < 10 {
            topCurrentTrackView.timeLine.text = "\(minute):0\(second)"
        } else {
            topCurrentTrackView.timeLine.text = "\(minute):\(second)"
        }
        
        if currentSongId != songs[index!].id {
            self.index = musicViewController.index
            let song = songs[index!]
            currentSongId = song.id
                
            updateUI(song: song)

        } else {
            
            if avPlayer.isPlaying() {
                
                if isPrevButtonPressed {
                    
                    musicViewController.playPrevSong()
                    
                    self.index = musicViewController.index
                    let song = songs[index!]
                    currentSongId = song.id
                    
                    updateUI(song: song)

                    isPrevButtonPressed = false
                }
                
                if isNextButtonPressed {
                    musicViewController.playNextSong()
                    
                    self.index = musicViewController.index
                    let song = songs[index!]
                    currentSongId = song.id
                    
                    updateUI(song: song)

                    isNextButtonPressed = false
                }
            }

        }
    }
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func loadSingerSongs() {
        indicator.show(withStatus: "Күте тұрыңыз...")
        if let id = singerID {

            let url = "http://sazalem.kz/api/singer_songs_list.php?singer_id=\(id)"
            
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        for temp in json["songs"].arrayValue {
                            
                            let song = Song()
                            song.id          = temp["id"].intValue
                            song.song_name   = temp["song_name"].stringValue
                            song.singer_name = self.singerNameString
                            song.singer_id   = temp["singer_id"].intValue
                            song.singer_picture = temp["song_picture"].stringValue
                            song.song_text      = ""
                            song.audio          = temp["stream"].stringValue
                            song.like    = 0
                            song.dislike = 0

                            self.songs.append(song)
                            self.tableView.reloadData()
                            indicator.dismiss()
                        }
                    }
                }
            })
        }
    }
    
    func updateUI(song : Song) {
        
        self.topCurrentTrackView.singerName.text = song.singer_name
        self.topCurrentTrackView.songName.text = song.song_name
        self.singerDetailsCurrentSongName = song.song_name
        self.singerDetailsCurrentSingerName = song.singer_name

    }
    
}
