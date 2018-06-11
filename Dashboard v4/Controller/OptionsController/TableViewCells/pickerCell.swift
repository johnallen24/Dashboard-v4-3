//
//  pickerCell.swift
//  Dashboard 2
//
//  Created by John Allen on 5/16/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit

class pickerCell: UITableViewCell {
    
    
    var delegate: CustomCellDelegate?
    
    
    let leftLabel: UILabel = {
        let view = UILabel()
        //view.text = "Graph Turned On"
        view.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightLabel: UILabel = {
        let view = UILabel()
        //view.text = "Graph Turned On"
        view.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = UIColor.blue
        //self.selectionStyle = .none
        contentView.addSubview(rightLabel)
        contentView.addSubview(leftLabel)
        contentView.addSubview(imageView2)
        
        
        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            leftLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
            ])
        
        NSLayoutConstraint.activate([
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            rightLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            rightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
}
