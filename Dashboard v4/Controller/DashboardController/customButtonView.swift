//
//  customButton.swift
//  Dashboard 2
//
//  Created by John Allen on 5/23/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit

protocol customButtonViewDelegate {
    func buttonPressed(view: customButtonView)
}


class customButtonView: UIView {
    
    
   
    
    
    var delegate: customButtonViewDelegate?
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Connect New Device "
        view.textAlignment = .center
        view.font = UIFont(name: "GillSans-SemiBold", size: 20)
        return view
    }()
    
    let phoneButtonWrapper: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(phoneConnect), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    @objc func phoneConnect() {
       delegate?.buttonPressed(view: self)
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(phoneButtonWrapper)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
            ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
            ])
        
        
        
        NSLayoutConstraint.activate([
            phoneButtonWrapper.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            phoneButtonWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            phoneButtonWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            phoneButtonWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
