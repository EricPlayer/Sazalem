//
//  MusicPlayer.swift
//  Sazalem
//
//  Created by Гани Мырзамуратов on 4/20/19.
//  Copyright © 2019 Esset Murat. All rights reserved.
//

import Foundation
import AVFoundation

class musicPlayer : UIViewController {

    var avPlayer : AVPlayer!
    var durationMinute : Int = 0
    var durationSecond : Int = 0
    var durationIntTime : Int = 0


    func setMusic(stringUrl : String) {
        
        guard let url = URL(string: stringUrl) else {
            print("Invalid URL")
            return
        }
        
        setMusic(url: url)

    }
    
    func setMusic(url : URL) {
        
        let item = AVPlayerItem(url: url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        
        if avPlayer != nil {
            avPlayer.removeObserver(self, forKeyPath: "status")
            if #available(iOS 10.0, *) {
                avPlayer.removeObserver(self, forKeyPath: "timeControlStatus")
            } else {
                avPlayer.removeObserver(self, forKeyPath: "rate")
            }
        }
        avPlayer = AVPlayer(playerItem: item)

        avPlayer.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        if #available(iOS 10.0, *) {
            avPlayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            avPlayer.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
        }
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        // Your code here
        
        musicViewController.playNextSong()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === avPlayer {
            if keyPath == "status" {
                if avPlayer.status == .readyToPlay {
                    avPlayer.play()
                }
            } else if keyPath == "timeControlStatus" {
                if #available(iOS 10.0, *) {
                    if avPlayer.timeControlStatus == .playing {
                        setDuration()
                    } else {
                        //videoCell?.muteButton.isHidden = true
                    }
                }
            } else if keyPath == "rate" {
                if avPlayer.rate > 0 {
                    setDuration()
                } else {
                    //videoCell?.muteButton.isHidden = true
                }
            }
        }
    }
    
    func setDuration() {
        
        if let playerItem = avPlayer.currentItem {
            if avPlayer.status == .readyToPlay {
                let durationTime = playerItem.asset.duration
                durationIntTime = Int(CMTimeGetSeconds(durationTime))
                durationMinute = Int(durationIntTime / 60)
                durationSecond = Int(durationIntTime - durationMinute*60)
            }
        }
    }
    
    func play() {
        
        avPlayer.play()
        
    }
    
    func pause() {
        
        avPlayer.pause()
        
    }
    
    func seek(to : Float) {
        
        avPlayer.seek(to: CMTimeMakeWithSeconds(Float64(to), preferredTimescale: (avPlayer.currentItem?.currentTime().timescale)!))
        
    }
    
    func getCurrentTimeSecond() -> Int {
        
        return Int(CMTimeGetSeconds(avPlayer.currentItem!.currentTime()))
        
    }
    
    func getDurationsMinute() -> Int {
        
        return durationMinute
        
    }
    
    func getDurationsSecond() -> Int {
        
        return durationSecond
        
    }

    func getDuration() -> Int {
        
        return durationIntTime
        
    }

    func isPlaying() -> Bool {
        
        var state = false
        /*
        if avPlayer.timeControlStatus == .playing {
            state = true
        }*/
        if #available(iOS 10.0, *) {
            if (avPlayer.timeControlStatus == .playing) {
                state = true
            }
        } else {
            if (avPlayer.rate != 0.0) {
                state = true
            }
        }

        return state
        
    }
    
}
