//
//  dropDownButtonsCell.swift
//  Dashboard 2
//
//  Created by John Allen on 5/23/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import DropDownMenuKit


protocol dropDownButtonsCellDelegate {
    func buttonPressed(view: customButtonView)
}

class dropDownButtonsCell: DropDownMenuCell, customButtonViewDelegate {
    
    
    var delegate: dropDownButtonsCellDelegate?
    
    let overviewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let phoneButtonWrapper: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor.clear
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        //button.addTarget(self, action: #selector(phoneConnect), for: .touchUpInside)
//        return button
//    }()
    
    
    let imageView1: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView2: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let label1: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Connect New Device "
        view.textAlignment = .center
        view.font = UIFont(name: "GillSans-SemiBold", size: 24)//UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20)
        return view
    }()
    
    let label2: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Connect New Device "
        view.textAlignment = .center
        view.font = UIFont(name: "GillSans-SemiBold", size: 24)
        return view
    }()
    
    
    let phoneButton: customButtonView = {
        let view = customButtonView(frame: CGRect.zero)
        view.tag = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let wearableButton: customButtonView = {
    let view = customButtonView(frame: CGRect.zero)
        view.tag = 2
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}()
    
   
    
    func buttonPressed(view: customButtonView) {
       delegate?.buttonPressed(view: view)
        
        
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    override public init() {
        super.init()
        self.addSubview(overviewContainer)
       //self.addSubview(buttonContainer1)
        self.addSubview(phoneButton)
        self.addSubview(wearableButton)
        //self.addSubview(phoneButtonWrapper)
    
        phoneButton.delegate = self
        wearableButton.delegate = self
        
        phoneButton.label.text = "Phone"
        phoneButton.imageView.image = UIImage(named: "IphoneIcon")
        
        wearableButton.label.text = "Wearable"
        wearableButton.imageView.image = UIImage(named: "WatchIcon")
        
        
        
        NSLayoutConstraint.activate([
            overviewContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            overviewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            overviewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            overviewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        overviewContainer.backgroundColor = UIColor.white
        
        NSLayoutConstraint.activate([
            phoneButton.topAnchor.constraint(equalTo: overviewContainer.topAnchor, constant: 0),
           phoneButton.centerXAnchor.constraint(equalTo: overviewContainer.centerXAnchor, constant: -100),
            phoneButton.widthAnchor.constraint(equalTo: overviewContainer.widthAnchor, multiplier: 0.2),
            phoneButton.bottomAnchor.constraint(equalTo: overviewContainer.bottomAnchor, constant: -20)
            ])
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(connectPhone))
//        phoneButton.addGestureRecognizer(gesture)
        
      //  phoneButtonWrapper.frame = phoneButton.frame
        
        //phoneButtonWrapper.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
//
        
        
        
        
//        NSLayoutConstraint.activate([
//            phoneButtonWrapper.topAnchor.constraint(equalTo: phoneButton.topAnchor, constant: 0),
//            phoneButtonWrapper.leadingAnchor.constraint(equalTo: phoneButton.leadingAnchor, constant: 0),
//            phoneButtonWrapper.trailingAnchor.constraint(equalTo: phoneButton.trailingAnchor, constant: 0),
//            phoneButtonWrapper.bottomAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 0)
//            ])

        
        
        NSLayoutConstraint.activate([
            wearableButton.topAnchor.constraint(equalTo: overviewContainer.topAnchor, constant: 0),
              wearableButton.centerXAnchor.constraint(equalTo: overviewContainer.centerXAnchor, constant: 100),
             wearableButton.widthAnchor.constraint(equalTo: overviewContainer.widthAnchor, multiplier: 0.2),
            wearableButton.bottomAnchor.constraint(equalTo: overviewContainer.bottomAnchor, constant: -20)
            ])
        
        
        
        
    }
    
   

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

