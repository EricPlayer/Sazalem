//
//  MusicViewController.swift
//  SazAlem
//
//  Created by Esset Murat on 1/25/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit
import LNPopupController
import RNLoadingButton_Swift
import GoogleMobileAds
import Alamofire
import CoreMedia
import MediaPlayer
import SwiftyJSON


var isReplayEnabled = false
var isShuffleEnabled = false
var isGoodButtonPressed = false
var isBadButtonPressed = false
var isNextButtonPressed = false

class MusicViewController : UIViewController {
    
    var audioUrl : String? {
        didSet {
            downloadButton.isEnabled = true
            downloadButton.alpha = 1
        }
    }
    var url : URL?
    var songsCount : Int?
    var songID : Int?
    var page : Int?
    var songs : [Song]?
    var index : Int?
    var homeViewControllerDelegate : HomeViewControllerDelegate?
    
    var homeTimer : Timer?
    
    var isLiked = false
    var isLyricsOpened = false
    
    let blueView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .blue
        view.alpha = 0.9
        
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 92.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "temp")
        
        return imageView
    }()
    
    let singerName : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .black
        
        return label
    }()
    
    let songName : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        
        return label
    }()
    
    lazy var progressBar : UISlider = {
        let progressBar = UISlider()
        
        progressBar.minimumValue = 0
        progressBar.minimumTrackTintColor = .blue
        progressBar.maximumTrackTintColor = .gray
        progressBar.setThumbImage(UIImage(named: "slider_thumb")?.withRenderingMode(.alwaysOriginal), for: .normal)
        progressBar.addTarget(self, action: #selector(seekAudio), for: .valueChanged)
        
        return progressBar
    }()
    
    lazy var pauseButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named : "big_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        button.addTarget(self, action: #selector(pauseMusic), for: .touchUpInside)
        
        return button
    }()
    
    lazy var prevButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named : "prev")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePrevButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nextButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named : "big_next")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        
        return button
    }()
    
    let currentTime : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .blue
        
        return label
    }()
    
    let fullTime : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .blue
        
        return label
    }()
    
    lazy var shuffleButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "shuffle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShuffleButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var replayButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "replay")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleReplay), for: .touchUpInside)
        
        return button
    }()
    
    lazy var downloadButton : RNLoadingButton = {
        let button = RNLoadingButton(type: .system)
        
        button.setImage(UIImage(named: "download")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDownloadButton), for: .touchUpInside)
        button.isLoading = false
        button.activityIndicatorAlignment = .center
        button.activityIndicatorColor = .white
        button.hideImageWhenLoading = true
        button.activityIndicatorViewStyle = .white
        button.isEnabled = false
        button.alpha = 0.5
        
        return button
    }()
    
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "chat")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCommentButton), for: .touchUpInside)
        
        return button
    }()

    let goodShadowView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var goodButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named : "likegray")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleGoodButton), for: .touchUpInside)
        
        return button
    }()
    
    let goodCount : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = .gray
        
        return label
    }()
    
    let badShadowView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var badButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named : "dislikegray")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleBadButton), for: .touchUpInside)
        
        return button
    }()
    
    let badCount : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = .gray
        
        return label
    }()
    
    let shadowView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var lyricsButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "lyrics")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleLyricsButton), for: .touchUpInside)
        
        return button
    }()
    
    let lyricsView : UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.layer.cornerRadius = 5
        textView.showsVerticalScrollIndicator = false
        textView.alpha = 0
        textView.isEditable = false
        
        return textView
    }()
    
    let likeShadowView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named : "like_deselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        
        return button
    }()
   
    lazy var adBanner : GADBannerView = {
        let banner = GADBannerView()
        
        banner.adUnitID = "ca-app-pub-7813891820290008/4000382391"
        banner.rootViewController = self
        
        return banner
    }()

    func setupViews() {
        let blueViewHeight = view.frame.height * 0.52
        
        view.addSubview(goodShadowView)
        goodShadowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(blueViewHeight)
            make.left.equalTo(15)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(badShadowView)
        badShadowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(blueViewHeight)
            make.left.equalTo(goodShadowView.snp.right).offset(15)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(likeShadowView)
        likeShadowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(blueViewHeight)
            make.right.equalTo(-15)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(blueViewHeight)
            make.right.equalTo(likeShadowView.snp.left).offset(-15)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(blueView)
        blueView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(blueViewHeight)
        }
        
        blueView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(185)
            make.height.equalTo(185)
        }
        
        blueView.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.right.equalTo(-5)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        blueView.addSubview(commentButton)
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(17)
            make.right.equalTo(downloadButton.snp.left).offset(-5)
            make.width.equalTo(30)
            make.height.equalTo(50)
        }
        
        blueView.addSubview(lyricsView)
        lyricsView.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-40)
        }
        
        view.addSubview(singerName)
        singerName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(blueView.snp.bottom).offset(45)
            make.height.equalTo(20)
        }
        
        view.addSubview(songName)
        songName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(singerName.snp.bottom).offset(5)
            make.height.equalTo(15)
        }
        
        view.addSubview(goodButton)
        goodButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(blueView.snp.bottom)
            make.left.equalTo(15)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(goodCount)
        goodCount.snp.makeConstraints { (make) in
            make.top.equalTo(goodButton.snp.bottom).offset(5)
            make.centerX.equalTo(goodButton)
        }
        
        view.addSubview(badButton)
        badButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(blueView.snp.bottom)
            make.left.equalTo(goodButton.snp.right).offset(15)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(badCount)
        badCount.snp.makeConstraints { (make) in
            make.top.equalTo(badButton.snp.bottom).offset(5)
            make.centerX.equalTo(badButton)
        }
        
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.center.equalTo(likeShadowView)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(lyricsButton)
        lyricsButton.snp.makeConstraints { (make) in
            make.center.equalTo(shadowView)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.top.equalTo(songName.snp.bottom).offset(45)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(2)
        }
        
        view.addSubview(currentTime)
        currentTime.snp.makeConstraints { (make) in
            make.bottom.equalTo(progressBar.snp.top).offset(-10)
            make.left.equalTo(progressBar)
        }
        
        view.addSubview(fullTime)
        fullTime.snp.makeConstraints { (make) in
            make.bottom.equalTo(progressBar.snp.top).offset(-10)
            make.right.equalTo(progressBar)
        }
        
        view.addSubview(pauseButton)
        pauseButton.snp.makeConstraints { (make) in
            make.top.equalTo(progressBar.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        view.addSubview(prevButton)
        prevButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(pauseButton)
            make.right.equalTo(pauseButton.snp.left).offset(-15)
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(pauseButton)
            make.left.equalTo(pauseButton.snp.right).offset(15)
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        view.addSubview(shuffleButton)
        shuffleButton.snp.makeConstraints { (make) in
            make.right.equalTo(prevButton.snp.left).offset(-25)
            make.centerY.equalTo(prevButton)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        view.addSubview(replayButton)
        replayButton.snp.makeConstraints { (make) in
            make.left.equalTo(nextButton.snp.right).offset(25)
            make.centerY.equalTo(nextButton)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        // Жарнама
        if !UserDefaults.standard.bool(forKey: "isUserSubbed") {
            view.addSubview(adBanner)
            adBanner.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Player page")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

        if let id = songID {
            let array = UserDefaults.standard.array(forKey: "favSongsID") as? [Int] ?? [Int]()
            
            for i in array {
                if i == id {
                    likeButton.setImage(UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    likeButton.backgroundColor = .pink
                    
                    isLiked = true
                } else {
                    likeButton.setImage(UIImage(named: "like_deselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    likeButton.backgroundColor = .white
                    
                    isLiked = false
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        popupBar.isTranslucent = false
        
        let pause = UIBarButtonItem(image: UIImage(named : "pause"), style: .plain, target: self, action: #selector(pauseMusic))
        self.popupItem.leftBarButtonItems = [pause]
        
        let more = UIBarButtonItem(image: UIImage(named : "next"), style: .plain, target: self, action: #selector(moreAction))
        self.popupItem.rightBarButtonItems = [more]
        
        setupViews()
        
        if !UserDefaults.standard.bool(forKey: "isUserSubbed") {
            let request = GADRequest()
            adBanner.load(request)
        }

        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePlayerTime), userInfo: nil, repeats: true)
    }
    
    @objc
    func seekAudio() {
        avPlayer.seek(to: progressBar.value)
    }
    
    @objc
    func updatePlayerTime() {
        let intTime = avPlayer.getCurrentTimeSecond()
        
        if avPlayer.isPlaying() {
            pauseButton.setImage(UIImage(named : "big_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            musicViewController.popupItem.leftBarButtonItems?.first?.image = #imageLiteral(resourceName: "pause")
        } else {
            pauseButton.setImage(UIImage(named : "big_play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            musicViewController.popupItem.leftBarButtonItems?.first?.image = #imageLiteral(resourceName: "play")
        }
        
        if intTime > 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        let minute = Int(intTime / 60)
        let second = Int(intTime - minute*60)
        
        if second < 10 {
            currentTime.text = "\(minute):0\(second)"
        } else {
            currentTime.text = "\(minute):\(second)"
        }
        
        let durationMinute = avPlayer.getDurationsMinute()
        let durationSecond = avPlayer.getDurationsSecond()
        
        if durationSecond < 10 {
            fullTime.text = "\(durationMinute):0\(durationSecond)"
        } else {
            fullTime.text = "\(durationMinute):\(durationSecond)"
        }
        
        progressBar.maximumValue = Float(avPlayer.getDuration())
        progressBar.value = Float(intTime)
    }
    
    @objc
    func handleReplay() {
        if isReplayEnabled {
            isReplayEnabled = false
            replayButton.tintColor = .clear
            replayButton.setImage(replayButton.currentImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            isReplayEnabled = true
            replayButton.tintColor = .blue
            replayButton.setImage(replayButton.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc
    func handleShuffleButton() {
        if isShuffleEnabled {
            isShuffleEnabled = false
            shuffleButton.tintColor = .clear
            shuffleButton.setImage(shuffleButton.currentImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            isShuffleEnabled = true
            shuffleButton.tintColor = .blue
            shuffleButton.setImage(shuffleButton.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc
    func handleCommentButton() {
        let commentsViewController = CommentsViewController()
        commentsViewController.songID = self.songID
        //commentsViewController.pageComment = self.page!
        let commentNavController = UINavigationController(rootViewController: commentsViewController)
        
        present(commentNavController, animated: true, completion: nil)
    }
    
    @objc
    func moreAction() {
        
    }
    
    @objc
    func handlePrevButton() {
        isPrevButtonPressed = true
    }
    
    @objc
    func handleNextButton() {
        isNextButtonPressed = true
    }
    
    @objc
    func pauseMusic() {
        avPlayer.pause()
        
        pauseButton.setImage(UIImage(named : "big_play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        pauseButton.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
        
        let play = UIBarButtonItem(image: UIImage(named : "play"), style: .plain, target: self, action: #selector(playMusic))
        self.popupItem.leftBarButtonItems = [play]
    }
    
    @objc
    func playMusic() {
        avPlayer.play()
        
        pauseButton.setImage(UIImage(named : "big_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseMusic), for: .touchUpInside)
        
        let pause = UIBarButtonItem(image: UIImage(named : "pause"), style: .plain, target: self, action: #selector(pauseMusic))
        self.popupItem.leftBarButtonItems = [pause]
    }
    
    @objc
    func setMark(mark : String) {
        if let id = songID, UserDefaults.standard.integer(forKey: "user_id") != 0 {
            Alamofire.request("http://sazalem.com/ajaxfile/api/giveMark.php", method: .post, parameters: ["song_id" : id, "user_id" :UserDefaults.standard.integer(forKey: "user_id"), "mark" : mark]).responseJSON { (response) in
                print("success")
            }
        }
    }
    
    @objc
    func handleGoodButton() {
        if !isGoodButtonPressed {
            goodButton.setImage(UIImage(named: "likewhite")?.withRenderingMode(.alwaysOriginal), for: .normal)
            goodButton.backgroundColor = .pink
            badButton.setImage(UIImage(named: "dislikegray")?.withRenderingMode(.alwaysOriginal), for: .normal)
            badButton.backgroundColor = .white
            isBadButtonPressed = false
            isGoodButtonPressed = true
            
            setMark(mark: "like")
        }
    }
    
    @objc
    func handleBadButton() {
        if !isBadButtonPressed {
            badButton.setImage(UIImage(named: "dislikewhite")?.withRenderingMode(.alwaysOriginal), for: .normal)
            badButton.backgroundColor = .lightBlue
            goodButton.setImage(UIImage(named: "likegray")?.withRenderingMode(.alwaysOriginal), for: .normal)
            goodButton.backgroundColor = .white
            isGoodButtonPressed = false
            isBadButtonPressed = true
            
            setMark(mark: "dislike")
            
        }
    }
    
    @objc
    func handleLikeButton() {
        if !isLiked {
            likeButton.setImage(UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            likeButton.backgroundColor = .pink
            
            if let id = songID {
                var array = UserDefaults.standard.array(forKey: "favSongsID") as? [Int] ?? [Int]()
                if !array.contains(id) {
                    array.append(id)
                    UserDefaults.standard.set(array, forKey: "favSongsID")
                }
            }
            
            isLiked = true
        } else {
            likeButton.setImage(UIImage(named: "like_deselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            likeButton.backgroundColor = .white
            
            if let id = songID {
                var array = UserDefaults.standard.array(forKey: "favSongsID") as? [Int] ?? [Int]()
                for i in 0..<array.count {
                    if array[i] == id {
                        array.remove(at: i)
                    }
                }
                
                UserDefaults.standard.set(array, forKey: "favSongsID")
            }
            
            isLiked = false
        }
    }
    
    @objc
    func handleLyricsButton() {
        if !isLyricsOpened {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.imageView.alpha = 0
                self.lyricsView.alpha = 1
                self.lyricsButton.backgroundColor = .lightBlue
                self.lyricsButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }, completion: nil)
            
            isLyricsOpened = true
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.imageView.alpha = 1
                self.lyricsView.alpha = 0
                self.lyricsButton.backgroundColor = .white
                self.lyricsButton.setImage(UIImage(named: "lyrics")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }, completion: nil)
            
            isLyricsOpened = false
        }
    }
    
    @objc
    func handleDownloadButton() {
        if UserDefaults.standard.bool(forKey: "isUserSubbed") {
            if let stringUrl = songs![index!].download_link {
                if let audioUrl = URL(string: stringUrl) {
                    
                    // then lets create your document folder url
                    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    // lets create your destination file url
                    let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                    
                    // to check if it exists before downloading it
                    if FileManager.default.fileExists(atPath: destinationUrl.path) {
                        print("The file already exists at path")
                        indicator.setDefaultMaskType(.none)
                        indicator.setDefaultStyle(.dark)
                        indicator.showError(withStatus: "Бұл ән жүктелген")
                        // if the file doesn't exist
                    } else {
                        downloadButton.isLoading = true
                        // you can use NSURLSession.sharedSession to download the data asynchronously
                        URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                            guard let location = location, error == nil else { return }
                            do {
                                // after downloading your file you need to move it to your destination url
                                try FileManager.default.moveItem(at: location, to: destinationUrl)
                                print("File moved to documents folder")
                                DispatchQueue.main.async {
                                    self.downloadButton.isLoading = false
                                }
                                indicator.setDefaultMaskType(.none)
                                indicator.setDefaultStyle(.dark)
                                indicator.showSuccess(withStatus: "Жүктелді, бұл ән Таңдаулы бетінде")
                            } catch let error as NSError {
                                print(error.localizedDescription)
                            }
                        }).resume()
                    }
                }
            }
        } else {
            present(SubscriptionViewController(), animated: true, completion: nil)
        }
    }
    
    func updateUI() {
        
        if let song = self.songs {
            if let ind = self.index {
                self.lyricsView.text = song[ind].song_text
                if let likeCount = song[ind].like, let dislikeCount = song[ind].dislike {
                    self.goodCount.text = "\(likeCount)"
                    self.badCount.text = "\(dislikeCount)"
                }
                if let cover_url = song[ind].singer_picture {
                    self.imageView.kf.setImage(with: URL(string: cover_url))
                }
            }
        }
    }
    
    func setSongByIndex(ind:Int) {

        homeTimer?.invalidate()

        
        if self.songs == nil {
            return
        }
        loadSong(song: self.songs![ind])
        self.popupItem.title    = self.songs![ind].singer_name
        self.popupItem.subtitle = self.songs![ind].song_name
        self.singerName.text    = self.songs![ind].singer_name
        self.songName.text      = self.songs![ind].song_name
        self.lyricsView.text    = self.songs![ind].song_text
        
        if let likeCount = self.songs![ind].like, let dislikeCount = self.songs![ind].dislike {
            self.goodCount.text = "\(likeCount)"
            self.badCount.text = "\(dislikeCount)"
        }
        
        self.songID = self.songs![ind].id
        self.popupItem.leftBarButtonItems?.first?.image = UIImage(named: "pause")
        self.pauseButton.setImage(UIImage(named: "big_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        if let cover_url = self.songs![ind].singer_picture {
            self.imageView.kf.setImage(with: URL(string: cover_url))
        }
        if let art_work = self.songs![ind].artwork {
            self.imageView.image = art_work
        }
        
        self.audioUrl = self.songs![ind].audio
        self.url = self.songs![ind].url
        self.fullTime.text = self.songs![ind].song_text

        homeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateNowPlayingCenterTime), userInfo: nil, repeats: true)

    }

    func setSong(ind:Int, song:[Song]) {
        
        self.index = ind
        self.songs = song
        setSongByIndex(ind:ind)
        if let remote_url = self.audioUrl {
            let remote_url = remote_url.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let url = URL(string: remote_url) else { return print("#sazalem. bad url") }
            if AVAsset(url: url).isPlayable {
                avPlayer.setMusic(stringUrl: remote_url)
            }
        } else {
            if let local_url = self.url {
                avPlayer.setMusic(url: local_url)
            }
        }

    }
    
    func playNextSong() {
        
        if self.index == nil {
            return
        }
        
        if !isReplayEnabled {
            if isShuffleEnabled {
                let randomIndex = arc4random_uniform(UInt32(self.songs!.count))
                
                var intIndex = Int(randomIndex)
                if intIndex+1 >= self.songs!.count {
                    intIndex = 0
                }
                    
                self.index = intIndex
                setSongByIndex(ind: self.index!)
                if let remote_url = self.audioUrl {
                    avPlayer.setMusic(stringUrl: remote_url)
                } else {
                    if let local_url = self.url {
                        avPlayer.setMusic(url: local_url)
                    }
                }

            } else {
                
                self.index = self.index! + 1
                if self.index! >= self.songs!.count {
                    self.index = 0
                }
                setSongByIndex(ind: self.index!)
                if let remote_url = self.audioUrl {
                    avPlayer.setMusic(stringUrl: remote_url)
                } else {
                    if let local_url = self.url {
                        avPlayer.setMusic(url: local_url)
                    }
                }

            }
            
        } else {
            avPlayer.seek(to: 0)
            avPlayer.play()
        }

    }

    func playPrevSong() {
        
        if self.index == nil {
            return
        }
        
        self.index = self.index! - 1
        
        if self.index! < 0 {
            self.index = 0
        }
        
        setSongByIndex(ind: self.index!)
        if let remote_url = self.audioUrl {
            avPlayer.setMusic(stringUrl: remote_url)
        } else {
            if let local_url = self.url {
                avPlayer.setMusic(url: local_url)
            }
        }

    }
    
    @objc
    func updateNowPlayingCenterTime() {
        
        let current_time = NSNumber(value: avPlayer.getCurrentTimeSecond())
        let duration     = NSNumber(value: avPlayer.getDuration())
        
        var image = self.imageView.image
        if image == nil {
            image = UIImage(named: "hit")
        }
        
        updateNowPlayingCenter(title: self.songs![self.index!].song_name!, artist: self.songs![self.index!].singer_name!,
                               albumArt: image!, currentTime: current_time,
                               songLength: duration, PlaybackRate: 1.0)

    }

    func updateNowPlayingCenter(title: String, artist: String, albumArt: AnyObject, currentTime: NSNumber, songLength: NSNumber, PlaybackRate: Double){
        
        let songInfo : Dictionary<String, Any> = [
            
            MPMediaItemPropertyTitle: title,
            
            MPMediaItemPropertyArtist: artist,
            
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: albumArt as! UIImage),
            
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            
            MPMediaItemPropertyPlaybackDuration: songLength,
            
            MPNowPlayingInfoPropertyPlaybackRate: PlaybackRate
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        
    }

    func loadSong(song : Song) {
        
        if let id = song.id {
            if song.download_link == nil {
                
                indicator.setDefaultStyle(.dark)
                indicator.setDefaultMaskType(.black)
                indicator.show(withStatus: "Күте тұрыңызшы...")
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
                            })
                        }
                    } else {
                        print("Error loading song by id: ", id)
                    }
                }
                
            }
        }
        
    }

}
