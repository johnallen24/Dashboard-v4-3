//
//  connectedPhonesCell.swift
//  Dashboard 2
//
//  Created by John Allen on 5/24/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import DropDownMenuKit


protocol deviceSelectionDelegate {
    func deviceSelected(view: DeviceView)
}

class connectedPhonesCell: DropDownMenuCell, deviceViewDelegate {
    
    
    var delegate: deviceSelectionDelegate?
    
    let deviceView1: DeviceView = {
        let view = DeviceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        return view
    }()
    
    let deviceView2: DeviceView = {
        let view = DeviceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 2
        return view
        
    }()
    
    let deviceView3: DeviceView = {
        let view = DeviceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 3
        return view
        
    }()
    
    let deviceView4: DeviceView = {
        let view = DeviceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 4
        return view
        
    }()
    
    
    let overStackView: UIStackView = {
                let view = UIStackView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Connected Devices"
        view.textAlignment = .left
        view.font = UIFont(name: "GillSans-SemiBold", size: 20)
        return view
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let overviewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
   
    
    func deviceViewPressed(view: DeviceView) {
        print("joseph")
        delegate?.deviceSelected(view: view)
        
    }
    
    
    
    override public init() {
        super.init()
        self.addSubview(overviewContainer)
        self.addSubview(titleLabel)
        self.addSubview(overStackView)
        overviewContainer.addSubview(seperatorLine)
        //self.bringSubview(toFront: seperatorLine)
        
        deviceView1.delegate = self
        deviceView2.delegate = self
        deviceView3.delegate = self
        deviceView4.delegate = self
        
        
        
        
        overStackView.addArrangedSubview(deviceView1)
         overStackView.addArrangedSubview(deviceView2)
         overStackView.addArrangedSubview(deviceView3)
         overStackView.addArrangedSubview(deviceView4)
        
        overStackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            overviewContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            overviewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            overviewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            overviewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        overviewContainer.backgroundColor = UIColor.white

        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1)
            ])
        
        NSLayoutConstraint.activate([
            overStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            overStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            overStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            overStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        overStackView.backgroundColor = UIColor.white
        
        
        NSLayoutConstraint.activate([
                        seperatorLine.heightAnchor.constraint(equalToConstant: 2),
                        seperatorLine.leadingAnchor.constraint(equalTo: overviewContainer.leadingAnchor, constant: 0),
                        seperatorLine.trailingAnchor.constraint(equalTo: overviewContainer.trailingAnchor, constant: 0),
                        seperatorLine.topAnchor.constraint(equalTo: overviewContainer.topAnchor, constant: 0)
                        ])
        
        seperatorLine.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    
    }
       
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
