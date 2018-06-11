//
//  DeviceView .swift
//  Dashboard 2
//
//  Created by John Allen on 5/20/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit

protocol deviceViewDelegate {
    func deviceViewPressed(view: DeviceView)
}



class DeviceView: UIView {
    
//    let labelStackView: UIStackView = {
//        let view = UIStackView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let levelLabel: UILabel = {
//        let view = UILabel()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.text = "Connect New Device "
//        view.textAlignment = .center
//        view.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20)
//        return view
//    }()
//    
//    let isChargingLabel: UILabel = {
//        let view = UILabel()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.text = "Connect New Device "
//        view.textAlignment = .center
//        view.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20)
//        return view
//    }()
//    
    
    var delegate: deviceViewDelegate?
    
    let nameLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textAlignment = .center
    view.font = UIFont(name: "GillSans-SemiBold", size: 24)//UIFont(name: "AvenirNext-Medium", size: 20)
    view.backgroundColor = UIColor.clear
    return view
    }()
    
    let phoneImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.clear
        return view
    }()
    
    let deviceInfoTextView: UITextView = {
    let view = UITextView()
    view.textAlignment = .center
    view.font = UIFont(name: "GillSans-SemiBold", size: 15)//UIFont(name: "AvenirNext-Medium", size: 15)//  UIFont.boldSystemFont(ofSize: 15)//(name: "AppleSDGothicNeo-Medium ", size: 20)
    view.isScrollEnabled = false
    view.isEditable = false
    view.backgroundColor = UIColor.clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    
    let deviceInfoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "AvenirNext-Medium", size: 15)
        return view
    }()
    
    let infoStackView: UIStackView = {
        
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let deviceButtonWrapper: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deviceViewTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func deviceViewTapped() {
        delegate?.deviceViewPressed(view: self)
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(nameLabel)
        self.addSubview(phoneImageView)
        self.addSubview(deviceInfoTextView)
        self.addSubview(deviceButtonWrapper)
        
        NSLayoutConstraint.activate([
            deviceButtonWrapper.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            deviceButtonWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            deviceButtonWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            deviceButtonWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15)
            ])
        
        NSLayoutConstraint.activate([
            phoneImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            phoneImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            phoneImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            phoneImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
            ])
        
        
        
        //deviceInfoTextView.contentInset = UIEdgeInsetsMake(-25,0.0,0,0.0);
       
        NSLayoutConstraint.activate([
            deviceInfoTextView.topAnchor.constraint(equalTo: phoneImageView.bottomAnchor, constant: 0),
            deviceInfoTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            deviceInfoTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            deviceInfoTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
