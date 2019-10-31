//
//  FavouriteViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 12/29/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
var currentSongId : Int?

var queuedItemsCount = 0

var favTimer : Timer?

class FavouriteViewController : UITableViewController {
    let cellID = "favouriteCellID"
    var timer : Timer?
    var songs = [Song]()
    var index : Int?
    var favCurrentSongName : String?
    var favCurrentSingerName : String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Favoure page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        if songs.count > 0 {
            songs.removeAll()
        }
        
        loadDownloadedSongs()
        
        if let bottomInset = tabBarController?.popupBar.frame.height {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Таңдаулы"
        configureNavigationBar()
        
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func loadDownloadedSongs() {
        
        /*
        if NetworkReachabilityManager()!.isReachable {
            let array = UserDefaults.standard.array(forKey: "favSongsID") as? [Int] ?? [Int]()
            
            for i in array {
                loadSongByID(id: i)
            }
        }*/
        
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                
                let mp3files = directoryContents.filter { $0.pathExtension == "mp3" }
                
                for url in mp3files {
                    
                    let asset = AVURLAsset(url: url)
                    
                    if let song_name = asset.commonMetadata[0].stringValue, let singer_name = asset.commonMetadata[2].stringValue, let artwork = asset.commonMetadata[3].value as? Data {
                        let song = Song()
                        
                        song.song_name = song_name
                        song.singer_name = singer_name
                        song.url = url
                        song.artwork = UIImage(data: artwork)
                        
                        songs.append(song)
                    }
                }
                
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    @objc
    func reloadData() {
        tableView.reloadData()
        print("reloading table view")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeViewCell
        
        cell.textLabel?.text = songs[indexPath.row].song_name
        cell.detailTextLabel?.text = songs[indexPath.row].singer_name
        cell.profileImage.image = songs[indexPath.row].artwork
        
        if let image = songs[indexPath.row].song_picture, let url = URL(string: image) {
            cell.profileImage.kf.setImage(with: url)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTimer?.invalidate()
        favTimer?.invalidate()
        searchTimer?.invalidate()
        singerDetailsTimer?.invalidate()
        
        
        index = indexPath.row
        favCurrentSongName = songs[indexPath.row].song_name
        favCurrentSingerName = songs[indexPath.row].singer_name

        
        tabBarController?.popupInteractionStyle = .drag
        tabBarController?.popupBar.barStyle = .compact
        tabBarController?.popupBar.progressViewStyle = .top
        tabBarController?.popupContentView.popupCloseButtonStyle = .chevron
        
        musicViewController.setSong(ind: indexPath.row, song: songs)
        

        tabBarController?.presentPopupBar(withContentViewController: musicViewController, animated: true, completion: nil)
        favTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePlayerTime), userInfo: nil, repeats: true)
        
        if let bottomInset = tabBarController?.popupBar.frame.height {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let filemanager = FileManager.default
            try! filemanager.removeItem(at: songs[indexPath.row].url!)
            
            songs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
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
        
        if currentSongId != songs[index!].id {
            self.index = musicViewController.index
            currentSongId = songs[index!].id
            
            favCurrentSongName = songs[self.index!].song_name
            favCurrentSingerName = songs[self.index!].singer_name
            
        } else {
            
            if avPlayer.isPlaying() {
                
                if isPrevButtonPressed {
                    
                    musicViewController.playPrevSong()
                    
                    self.index = musicViewController.index
                    currentSongId = songs[self.index!].id
                    
                    favCurrentSongName = songs[self.index!].song_name
                    favCurrentSingerName = songs[self.index!].singer_name
                    isPrevButtonPressed = false
                }
                
                if isNextButtonPressed {
                    musicViewController.playNextSong()
                    
                    self.index = musicViewController.index
                    currentSongId = songs[self.index!].id
                    
                    favCurrentSongName = songs[self.index!].song_name
                    favCurrentSingerName = songs[self.index!].singer_name
                    
                    isNextButtonPressed = false
                }
                
            }
        }

    }
    
}
