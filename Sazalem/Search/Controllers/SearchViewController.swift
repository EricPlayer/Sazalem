//
//  SearchViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 12/29/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum SearchType {
    case singer
    case song
}

var searchTimer : Timer?

class SearchViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let cellID = "searchCellID"
    var isSearching = false
    var data = [Song]()
    var singerData = [Singer]()
    var index : Int?
    var searchCurrentSongName : String?
    var searchCurrentSingerName : String?
    var currentSongId : Int?

    lazy var searchTypeView : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Әнді іздеу", "Әншіні іздеу"])
        
        segmentedControl.tintColor = .blue
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleType), for: .valueChanged)
        
        return segmentedControl
    }()
    
    lazy var searchBar : UISearchBar = {
        let bar = UISearchBar()
        
        bar.delegate = self
        bar.enablesReturnKeyAutomatically = false
        
        return bar
    }()
    
    lazy var tableView : UITableView = {
        let tb = UITableView()
        
        tb.delegate = self
        tb.dataSource = self
        tb.tableFooterView = UIView()
        tb.separatorStyle = .none
        
        return tb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Search page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func setupViews() {
        view.addSubview(searchTypeView)
        searchTypeView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(30)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(searchTypeView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        view.backgroundColor = .white
        configureNavigationBar()
        setupViews()
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func search(key : String, searchType : SearchType) {
        
        data.removeAll()
        singerData.removeAll()
        let id = UserDefaults.standard.integer(forKey: "user_id")
        if searchType == .song {
            if id != 0 {
            
                Alamofire.request("http://sazalem.com/ajaxfile/api/ka_lyrics_search_v1.php?key=\(key)&sazalem_id=\(id)").responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let songsArray = json["results"][1]["lyrics"].arrayValue
                        
                        for song in songsArray {
                            let temp = Song()
                            
                            temp.id = song["id"].intValue
                            temp.song_name = song["song_name"].stringValue
                            temp.singer_name = song["singer_name"].stringValue
                            temp.song_picture = song["song_picture"].stringValue
                            temp.audio = song["stream"].stringValue
                            
                            self.data.append(temp)
                        }
                        
                        self.tableView.reloadData()
                    }
                })
            } else {
                Alamofire.request("http://sazalem.com/ajaxfile/api/ka_lyrics_search_v1.php?key=\(key)&sazalem_id=").responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let songsArray = json["results"][1]["lyrics"].arrayValue
                        
                        for song in songsArray {
                            let temp = Song()
                            
                            temp.id = song["id"].intValue
                            temp.song_name = song["song_name"].stringValue
                            temp.singer_name = song["singer_name"].stringValue
                            temp.song_picture = song["song_picture"].stringValue
                            temp.audio = song["stream"].stringValue

                            self.data.append(temp)
                        }
                        
                        self.tableView.reloadData()
                    }
                })
            }
        } else {
            if id != 0 {
                Alamofire.request("http://sazalem.kz/api/ko_author_search_v2.php?key=\(key)&sazalem_id=\(id)").responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let singersArray = json["autors"].arrayValue
                        
                        for singer in singersArray {
                            let temp = Singer()
                            
                            temp.id = singer["id"].intValue
                            temp.author = singer["autor"].stringValue
                            temp.singer_picture = singer["singer_picture"].stringValue
                            
                            self.singerData.append(temp)
                        }
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    @objc
    func handleType() {
        searchBar.text = nil
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeViewCell
        
        if searchTypeView.selectedSegmentIndex == 0 {
            cell.textLabel?.text = data[indexPath.row].song_name
            cell.detailTextLabel?.text = data[indexPath.row].singer_name
            if let stringUrl = data[indexPath.row].singer_picture {
                if let url = URL(string: stringUrl) {
                    cell.profileImage.kf.setImage(with: url)
                }
            }
        } else {
            cell.textLabel?.text = singerData[indexPath.row].author
            if let stringUrl = singerData[indexPath.row].singer_picture {
                if let url = URL(string: stringUrl) {
                    cell.profileImage.kf.setImage(with: url)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        homeTimer?.invalidate()
        favTimer?.invalidate()
        searchTimer?.invalidate()
        singerDetailsTimer?.invalidate()
        
        if searchTypeView.selectedSegmentIndex == 0 {

            searchCurrentSongName = data[indexPath.row].song_name
            searchCurrentSingerName = data[indexPath.row].singer_name
            
            musicViewController.setSong(ind: indexPath.row, song: data)

            index = indexPath.row + 1
            searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatePlayerTime), userInfo: nil, repeats: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            tabBarController?.popupInteractionStyle = .drag
            tabBarController?.popupBar.barStyle = .compact
            tabBarController?.popupBar.progressViewStyle = .top
            tabBarController?.popupContentView.popupCloseButtonStyle = .chevron
            
            searchCurrentSongName = data[indexPath.row].song_name
            searchCurrentSingerName = data[indexPath.row].singer_name
            
            
            tabBarController?.presentPopupBar(withContentViewController: musicViewController, animated: true, completion: nil)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let singerDetailViewController = SingerDetailViewController()
            singerDetailViewController.singerAlbumArt = singerData[indexPath.row].singer_picture
            singerDetailViewController.singerID = singerData[indexPath.row].id
            singerDetailViewController.singerNameString = singerData[indexPath.row].author
            singerDetailViewController.singerName.textColor = .black
            singerDetailViewController.songsCount.textColor = .black
            navigationItem.title = ""
            navigationController?.pushViewController(singerDetailViewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTypeView.selectedSegmentIndex == 0 {
            return data.count
        }
        
        return singerData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let text = searchBar.text, let encoded_text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if searchTypeView.selectedSegmentIndex == 0 {
                search(key: encoded_text, searchType: .song)
            } else {
                print("searching singer")
                search(key: encoded_text, searchType: .singer)
            }
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
        
        if index == nil {
            return
        }
        if index!+1>self.data.count {
            return
        }
        if self.data.count == 0 {
            return
        }
        if currentSongId != self.data[index!].id {
            self.index = musicViewController.index
            currentSongId = self.data[index!].id
                
            searchCurrentSongName = self.data[index!].song_name
            searchCurrentSingerName = self.data[index!].singer_name
                
        } else {
                
            if avPlayer.isPlaying() {
                    
                if isPrevButtonPressed {
                        
                    musicViewController.playPrevSong()
                        
                    self.index = musicViewController.index
                    currentSongId = self.data[index!].id
                        
                    searchCurrentSongName   = self.data[index!].song_name
                    searchCurrentSingerName = self.data[index!].singer_name
                    isPrevButtonPressed = false
                }
                    
                if isNextButtonPressed {
                    
                    musicViewController.playNextSong()
                        
                    self.index = musicViewController.index
                    currentSongId = self.data[self.index!].id
                        
                    searchCurrentSongName   = self.data[self.index!].song_name
                    searchCurrentSingerName = self.data[self.index!].singer_name
                        
                    isNextButtonPressed = false
                }
                
            }
        }
        
    }
    
}
