//
//  SubscriptionViewController.swift
//  Sazalem
//
//  Created by Esset Murat on 2/13/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit

class SubscriptionViewController : UIViewController, SubscriptionViewControllerDelegate {

    let contentView : UIView = {
        let view = UIView()
        
        //view.backgroundColor = .blue
        
        return view
    }()

    let navView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .blue
        
        return view
    }()

    let deviderView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray
        
        return view
    }()

    lazy var closeButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var yearlyView : UIView = {
        let view = UIView()
        
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleYearly)))
        
        return view
    }()
    
    let yearlyLabel : UILabel = {
        let label = UILabel()
        
        label.text = "1 жыл"
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        
        label.text = "2590KZT"
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .right
        
        return label
    }()
    
    let tarifLabel : UILabel = {
        let label = UILabel()
        
        label.text = "/ЖЫЛЫНА"
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var monthlyView : UIView = {
        let view = UIView()
        
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMonthly)))
        
        return view
    }()
    
    let monthlyLabel : UILabel = {
        let label = UILabel()
        
        label.text = "1 ай"
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    let monthlyPriceLabel : UILabel = {
        let label = UILabel()
        
        label.text = "299KZT"
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .right
        
        return label
    }()
    
    let monthlyTarifLabel : UILabel = {
        let label = UILabel()
        
        label.text = "/АЙЫНА"
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .right
        
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        
        label.text = "- Еш жарнамамыз ән тыңдайсыз"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let descriptionLabel2 : UILabel = {
        let label = UILabel()
        
        label.text = "- Офлайн ән тыңдайсыз"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let descriptionLabel3 : UILabel = {
        let label = UILabel()
        
        label.text = "- Қалаған уақытыңызда Premium аккаунттан бас тарта аласыз"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let descriptionLabel4 : UILabel = {
        let label = UILabel()
        
        label.text = "Сіз iTunes аккаунты арқылы жазылып, төлей аласыз. Сіздің жазылымыңыз автоматты түрде ұзартылады" +
        " және ағымдағы периодтың бітуіне кем дегенде 24 сағат бұрын жазылымнан бас тарту мүмкіндігіңіз болады." +
        "Жазылу қолданушымен басқарыла алады және автоматты түрде ұзартылуды сатып алғаннан кейін қолданушының икемдеу бөліміне" +
        " кіріп өшіруге болады"
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let descriptionLabelRestore : UILabel = {
        let label = UILabel()
        
        label.text = "Қалпына келтіру"
        label.numberOfLines = 0
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let descriptionLabel5 : UILabel = {
        let label = UILabel()
        
        label.text = "Privacy & Terms"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let descriptionLabel6 : UILabel = {
        let label = UILabel()
        
        label.text = "-----------------------------------------------------------"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let scrl : UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        //sc.backgroundColor = .cyan
        return sc
    }()

    @objc
    func handleYearly() {
        SubscriptionService.shared.purchase(product: .yearly)
    }
    
    @objc
    func handleMonthly() {
        SubscriptionService.shared.purchase(product: .monthly)
    }
    
    @objc func handleRestore(sender: UITapGestureRecognizer) {
        
        SubscriptionService.shared.restorePurchases()

    }

    @objc
    func handleCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string : "http://sazalem.com/privacy-policy/")!, options: [:], completionHandler: { (status) in
                
            })
        } else {
            UIApplication.shared.openURL(URL(string: "http://sazalem.com/privacy-policy/")!)
        }
        
    }

    func setupViews() {
        view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(15)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        // Yearly
        view.addSubview(yearlyView)
        yearlyView.snp.makeConstraints { (make) in
            make.centerY.equalTo(navView.snp.bottom)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        
        yearlyView.addSubview(yearlyLabel)
        yearlyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        yearlyView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-15)
            make.bottom.equalTo(yearlyView.snp.centerY)
        }
        
        yearlyView.addSubview(tarifLabel)
        tarifLabel.snp.makeConstraints { (make) in
            make.top.equalTo(yearlyView.snp.centerY)
            make.right.equalTo(-15)
            make.bottom.equalTo(-5)
        }
 
        // Monthly
        view.addSubview(monthlyView)
        monthlyView.snp.makeConstraints { (make) in
            make.top.equalTo(yearlyView.snp.bottom).offset(15)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        
        monthlyView.addSubview(monthlyLabel)
        monthlyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        monthlyView.addSubview(monthlyPriceLabel)
        monthlyPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-15)
            make.bottom.equalTo(monthlyView.snp.centerY)
        }
        
        monthlyView.addSubview(monthlyTarifLabel)
        monthlyTarifLabel.snp.makeConstraints { (make) in
            make.top.equalTo(monthlyView.snp.centerY)
            make.right.equalTo(-15)
            make.bottom.equalTo(-5)
        }
        
        view.addSubview(descriptionLabelRestore)
        descriptionLabelRestore.snp.makeConstraints { (make) in
            make.centerY.equalTo(monthlyView.snp.bottom).offset(30)
            make.centerX.equalTo(monthlyView.snp.centerX)
            make.height.equalTo(20)
        }

        
        self.view.addSubview(scrl)

        scrl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0).isActive = true
        scrl.topAnchor.constraint(equalTo: view.topAnchor, constant: 230).isActive = true
        scrl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0).isActive = true
        scrl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        
        scrl.addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: scrl.leftAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: scrl.topAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrl.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrl.bottomAnchor, constant: 0).isActive = true
        //contentView.frame =  CGRectMake(0 , self.view.frame.height * 0.7, self.view.frame.width, self.view.frame.height * 0.3)


        // add labelOne to the scroll view
        contentView.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: scrl.leadingAnchor, constant: 16.0).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: scrl.topAnchor, constant: 30.0).isActive = true

        contentView.addSubview(descriptionLabel2)
        
        // pin labelTwo at 400-pts from the left
        descriptionLabel2.leadingAnchor.constraint(equalTo: scrl.leadingAnchor, constant: 16).isActive = true
        
        // pin labelTwo at 1000-pts from the top
        descriptionLabel2.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30).isActive = true
        
        // "pin" labelTwo to right & bottom with 16-pts padding
        descriptionLabel2.rightAnchor.constraint(equalTo: scrl.rightAnchor, constant: -16).isActive = true
        //descriptionLabel2.bottomAnchor.constraint(equalTo: scrl.bottomAnchor, constant: -16).isActive = true

        contentView.addSubview(descriptionLabel3)
        descriptionLabel3.leadingAnchor.constraint(equalTo: scrl.leadingAnchor, constant: 16).isActive = true
        descriptionLabel3.topAnchor.constraint(equalTo: descriptionLabel2.bottomAnchor, constant: 30).isActive = true
        descriptionLabel3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        //scrl.addSubview(descriptionLabel6)
        //descriptionLabel6.topAnchor.constraint(equalTo: descriptionLabel3.bottomAnchor, constant: 40).isActive = true
        //descriptionLabel6.snp.makeConstraints { (make) in
        //    make.centerX.equalToSuperview()
        //}
        
        contentView.addSubview(deviderView)
        deviderView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-40)
        }
        deviderView.topAnchor.constraint(equalTo: descriptionLabel3.bottomAnchor, constant: 40).isActive = true
        //deviderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        //deviderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        contentView.addSubview(descriptionLabel4)
        descriptionLabel4.leadingAnchor.constraint(equalTo: scrl.leadingAnchor, constant: 16).isActive = true
        descriptionLabel4.topAnchor.constraint(equalTo: deviderView.bottomAnchor, constant: 30).isActive = true
        descriptionLabel4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        contentView.addSubview(descriptionLabel5)
        //descriptionLabel5.leadingAnchor.constraint(equalTo: scrl.leadingAnchor, constant: 16).isActive = true
        descriptionLabel5.topAnchor.constraint(equalTo: descriptionLabel4.bottomAnchor, constant: 20).isActive = true
        //descriptionLabel5.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        descriptionLabel5.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        descriptionLabel5.isUserInteractionEnabled = true
        descriptionLabel5.addGestureRecognizer(tap)

        let tapRestore = UITapGestureRecognizer(target: self, action: #selector(handleRestore))
        descriptionLabelRestore.isUserInteractionEnabled = true
        descriptionLabelRestore.addGestureRecognizer(tapRestore)
    }

    func showAlert() {
        let alert = UIAlertController(title: "Қате", message: "Жазылымыңыз бар немесе белгісіз қате", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Жақсы", style: .cancel) { (action) in }
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    func showRestoredAlert() {
        let alert = UIAlertController(title: "Жазылым", message: "Жазылымды қалпына келтіру сәтті аяқталды!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Жақсы", style: .cancel) { (action) in }
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        
        SubscriptionService.shared.delegate = self
        SubscriptionService.shared.getSubscription()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let height:CGFloat = descriptionLabel.bounds.size.height + descriptionLabel2.bounds.size.height
        + descriptionLabel3.bounds.size.height + descriptionLabel4.bounds.size.height
        + descriptionLabel5.bounds.size.height+16+30+30+20+30+60
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)

    }

}



