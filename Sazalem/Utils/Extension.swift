//
//  Extension.swift
//  SazAlem
//
//  Created by Esset Murat on 12/26/17.
//  Copyright © 2017 Esset Murat. All rights reserved.
//

import UIKit
import MaterialTextField
import Alamofire
import SwiftyJSON
import MediaPlayer
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyVK
import GoogleSignIn

var isRandomNumberUsed = false

enum Provider : String {
    case facebook = "facebook"
    case vk = "vk"
    case google = "google"
}

protocol SubscriptionViewControllerDelegate {
    func showAlert()
    func showRestoredAlert()
}

protocol HomeViewControllerDelegate {
    func handlePrevSong()
}

extension UIViewController {
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowOpacity = 0.1
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationController?.navigationBar.layer.shadowRadius = 10
        navigationController?.navigationBar.isTranslucent = false
    }
}

extension Date {
    public func timeAgo(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) жыл бұрын"
        }
        
        if let year = components.year, year >= 1 {
            return "Өткен жылы"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) ай бүрын"
        }
        
        if let month = components.month, month >= 1 {
            return "Өткен айда"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) апта бұрын"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Өткен аптада"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) күн бұрын"
        }
        
        if let day = components.day, day >= 1 {
            return "Кеше"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) сағат бұрын"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "Бір сағат бұрын"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) минут бұрын"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "Бір минут бұрын"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) секунд бұрын"
        }
        
        return "Жаңа ғана"
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static let gradientFirstColor : UIColor = {
        return rgb(red: 63, green: 170, blue: 250)
    }()
    
    static let gradientSecondColor : UIColor = {
        return rgb(red: 111, green: 75, blue: 226)
    }()
    
    static let gradientThirdColor : UIColor = {
        return rgb(red: 171, green: 75, blue: 226)
    }()
    
    static let placeholderColor : UIColor = {
        return rgb(red: 126, green: 126, blue: 127)
    }()
    
    static let underlineColor : UIColor = {
        return rgb(red: 224, green: 224, blue: 224)
    }()
    
    static let menuSelectionColor : UIColor = {
        return rgb(red: 0, green: 0, blue: 0, alpha: 0.3)
    }()
    
    static let blue : UIColor = {
        return rgb(red: 111, green: 75, blue: 226)
    }()
    
    static let gray : UIColor = {
        return rgb(red: 155, green: 155, blue: 160)
    }()
    
    static let pink : UIColor = {
        return rgb(red: 255, green: 82, blue: 117)
    }()
    
    static let lightBlue : UIColor = {
        return rgb(red: 61, green: 170, blue: 250)
    }()
}

extension UIView {
    func addBackgroundGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.gradientFirstColor.cgColor, UIColor.gradientSecondColor.cgColor, UIColor.gradientThirdColor.cgColor]
        gradient.locations = [0.0, 0.72, 1.0]
        
        layer.insertSublayer(gradient, at: 0)
    }
}

extension FavouriteViewController {
}

extension HomeViewController {
}

extension SearchViewController {

}

extension SingerDetailViewController {

}

extension CommentsViewController {
    func loadComments(pageComment : Int, isLoad : Bool) {
        if let id = songID  {
            indicator.setDefaultMaskType(.black)
            indicator.show(withStatus: "Күте тұрыңыз...")
            Alamofire.request("http://sazalem.com/ajaxfile/api/ko_get_comments_page.php?page=\(pageComment)&song_id=\(id)").responseJSON { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let commentsArray = json["comments"].arrayValue
                        var count = 0
                        for comment in commentsArray {
                            let temp = Comment()
                            
                            let dateString = comment["created"].stringValue
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
                            let date = dateFormatter.date(from: dateString)
                            
                            temp.created = date
                            temp.author = comment["author"].stringValue
                            temp.comment_text = comment["comment_text"].stringValue
                            
                            self.comments.append(temp)
                            count = count + 1
                        }
                        
                        //self.comments = comments
                        if(count == 20) {
                            self.pageComment = self.pageComment + 1
                        } else {
                            self.isLoad = false
                        }
                        self.tableView.reloadData()
                        indicator.dismiss()
                    }
                }
            }
        }
    }
}

extension SingersViewController {
    func loadSingers(page : Int) {
        let url = "http://sazalem.kz/api/ko_author_list_page_v2.php?page=\(page)&sazalem_id=0"
        indicator.setDefaultMaskType(.black)
        indicator.show(withStatus: "Күте тұрыңыз...")
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for singer in json["autors"].arrayValue {
                        let temp = Singer()
                        
                        temp.id = singer["id"].intValue
                        temp.author = singer["autor"].stringValue
                        temp.singer_picture = singer["singer_picture"].stringValue
                        
                        self.singers.append(temp)
                    }
                    
                    self.page += 1
                    self.tableView.reloadData()
                    indicator.dismiss()
                }
            } else {
                print("some error")
            }
        }
    }
}

extension SingersViewCell {
    func loadSingerSongs() {
        var songs = [SingerSong]()
        if let id = singerID {
            let url = "http://sazalem.kz/api/ko_author_song_list.php?author_id=\(id)"
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        for song in json["songs"].arrayValue {
                            let temp = SingerSong()
                            
                            temp.id = song["id"].intValue
                            temp.song_name = song["song_name"].stringValue
                            
                            songs.append(temp)
                        }
                        
                        self.singerSongsCount = songs.count
                    }
                }
            })
        }
    }
}

extension LoginViewController {
    static func createTextField(placeholder : String) -> MFTextField {
        let textField = MFTextField()
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.placeholderFont = UIFont.systemFont(ofSize: 11)
        textField.placeholderColor = .placeholderColor
        textField.placeholderAnimatesOnFocus = true
        textField.underlineColor = .underlineColor
        textField.underlineHeight = 1
        
        return textField
    }
    
    func loginWithSocialID(id : String, name : String, gender : String, url : String, provider : Provider) {
        indicator.setDefaultStyle(.dark)
        indicator.setDefaultMaskType(.none)
        indicator.show()
        
        Alamofire.request("http://sazalem.com/ajaxfile/api/authorization.php", method: .post, parameters: ["id" : id, "name" : name, "gender" : gender, "photo" : url, "provider" : provider.rawValue]).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if json["state"].stringValue == "1" {
                        let id = json["user_id"].intValue
                        UserDefaults.standard.set(id, forKey: "user_id")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        
                        UIApplication.shared.keyWindow?.rootViewController = TabBarController()
                        self.dismiss(animated: true, completion: nil)
                    } else if json["state"].stringValue == "0" {
                        UserDefaults.standard.set(0, forKey: "user_id")
                        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                        
                        indicator.setDefaultMaskType(.none)
                        indicator.setDefaultStyle(.dark)
                        indicator.showError(withStatus: "Белгісіз қате")
                    }
                }
            }
        }
    }
    
    func getVKuserData() {
        VK.API.Users.get([.fields: "last_name,first_name,sex,photo_200_orig"])
            .configure(with: Config.init(httpMethod: .POST))
            .onSuccess {
                let json = JSON($0)
                
                let data = json[0]
                let id = data["id"].intValue
                let name = data["first_name"].stringValue + " " + data["last_name"].stringValue
                var gender = ""
                if data["sex"].intValue == 1 {
                    gender = "female"
                } else if data["sex"].intValue == 2 {
                    gender = "male"
                }
                let url = data["photo_200_orig"].stringValue
                
                self.loginWithSocialID(id: "\(id)", name: name, gender: gender, url: url, provider: .vk)
            }
            .onError { print("SwiftyVK: friends.get fail \n \($0)") }
            .send()
    }
    
    @objc
    func handleSocailLogin(sender: UIButton) {
        if sender.tag == 0 {
            VK.sessions.default.logIn(onSuccess: { info in
                self.getVKuserData()
            }, onError: { error in
                print(error)
            })
        } else if sender.tag == 1 {
            let login = FBSDKLoginManager()
            login.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
                if error != nil {
                    return
                }
                
                self.returnUserData()
            }
        } else if sender.tag == 2 {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    func returnUserData() {
        let parameters = ["fields" : "id, name, picture.type(large), gender"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                return
            }
            
            if let result = result as? [String : Any] {
                if let id = result["id"] as? String, let gender = result["gender"] as? String, let name = result["name"] as? String, let picture = result["picture"] as? [String : Any] {
                    if let data = picture["data"] as? [String : Any] {
                        if let url = data["url"] as? String {
                            self.loginWithSocialID(id: id, name: name, gender: gender, url: url, provider: .facebook)
                        }
                    }
                }
            }
        }
    }
    
    func emailLogin() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            print(email, password)
            let url : String = .email_login
            
            Alamofire.request(url, method: .post, parameters: ["email" : email, "password" : password]).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["state"].stringValue == "1" {
                            let id = json["user_id"].intValue
                            UserDefaults.standard.set(id, forKey: "user_id")
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            
                            UIApplication.shared.keyWindow?.rootViewController = TabBarController()
                            self.dismiss(animated: true, completion: nil)
                        } else if json["state"].stringValue == "0" {
                            UserDefaults.standard.set(0, forKey: "user_id")
                            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                            
                            indicator.setDefaultMaskType(.none)
                            indicator.setDefaultStyle(.light)
                            indicator.showError(withStatus: "Белгісіз қате")
                        }
                    }
                case .failure(let error):
                    print(error)
                    return
                }
            })
        }
    }
}

extension LoginViewController : GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let token = user?.authentication?.accessToken {
            let api = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(token)"
            Alamofire.request(api).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if let id = user.userID {
                            let name = json["name"].stringValue
                            let gender = json["gender"].stringValue
                            let url = json["picture"].stringValue
                            
                            self.loginWithSocialID(id: id, name: name, gender: gender, url: url, provider: .google)
                        }
                    }
                }
            })
        }
    }
}

extension RegisterViewController {
    func register() {
        if let email = emailTextField.text, let name = nameTextField.text, let password = passwordTextField.text {
            let url : String = .register
            
            Alamofire.request(url, method: .post, parameters: ["email" : email, "name" : name, "password" : password, "gender" : "1"]).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["state"].stringValue == "1" {
                            let id = json["user_id"].intValue
                            UserDefaults.standard.set(id, forKey: "user_id")
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            
                            UIApplication.shared.keyWindow?.rootViewController = TabBarController()
                            self.dismiss(animated: true, completion: nil)
                        } else if json["state"].stringValue == "0" {
                            UserDefaults.standard.set(0, forKey: "user_id")
                            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                            
                            indicator.setDefaultMaskType(.none)
                            indicator.setDefaultStyle(.light)
                            indicator.showError(withStatus: "Белгісіз қате")
                        }
                    }
                } else {
                    print("some error")
                    return
                }
            })
        }
    }
}

extension String {
    static let main : String = {
        return "http://sazalem.com/ajaxfile/api/"
    }()
    
    static let email_login : String = {
        return main + "signInByEmail.php"
    }()
    
    static let register : String = {
        return main + "registerUserByEmail.php"
    }()
}
