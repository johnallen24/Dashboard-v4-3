//
//  dropDownOverrideCell.swift
//  Dashboard 2
//
//  Created by John Allen on 5/22/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import DropDownMenuKit

class dropDownOverrideCell: DropDownMenuCell {

    let overviewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.text = "Connect New Device "
        view.textAlignment = .center
        view.font = UIFont(name: "GillSans-SemiBold", size: 24)//UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20)
        return view
    }()
    
    let addImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    

    }
    
    override public init() {
        super.init()
        self.addSubview(overviewContainer)
         overviewContainer.addSubview(titleLabel)
        self.addSubview(addImage)
       // self.addSubview(seperatorLine)
        seperatorLine.backgroundColor = UIColor.black
        
        addImage.image = UIImage(named: "AddIconBlack")
        //addImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            overviewContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            overviewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            overviewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            overviewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        overviewContainer.backgroundColor = UIColor.white
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: overviewContainer.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: overviewContainer.leadingAnchor, constant: 15),
            titleLabel.widthAnchor.constraint(equalTo: overviewContainer.widthAnchor, multiplier: 0.2),
            titleLabel.bottomAnchor.constraint(equalTo: overviewContainer.bottomAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            addImage.centerYAnchor.constraint(equalTo: overviewContainer.centerYAnchor, constant: 0),
            addImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            addImage.widthAnchor.constraint(equalTo: overviewContainer.heightAnchor, multiplier: 0.4),
            addImage.heightAnchor.constraint(equalTo: overviewContainer.heightAnchor, multiplier: 0.4)
            ])
        
//        NSLayoutConstraint.activate([
//            seperatorLine.heightAnchor.constraint(equalToConstant: 1),
//            seperatorLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
//            seperatorLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//            seperatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
//            ])
//
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
