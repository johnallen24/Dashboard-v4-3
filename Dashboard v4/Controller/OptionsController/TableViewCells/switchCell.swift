//
//  switchCell.swift
//  Dashboard 2
//
//  Created by John Allen on 5/16/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func switchChanged(cell: switchCell)
}

class switchCell: UITableViewCell {
    
    
   var delegate: CustomCellDelegate?
    
    @objc func switchChanged() {
    delegate?.switchChanged(cell: self)
        print("hello")
    }
    
    
    let switchButton: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        
        return view
    }()
    
    
    let label: UILabel = {
        let view = UILabel()
        view.text = "Graph Turned On"
        view.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = UIColor.blue
        
        switchButton.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        
        contentView.addSubview(switchButton)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            switchButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            switchButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            switchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
            ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
            ])
        
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
       
        
        
        
        
        
    }
    
}
