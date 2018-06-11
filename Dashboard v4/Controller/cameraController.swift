//
//  cameraController.swift
//  Dashboard 2
//
//  Created by John Allen on 5/24/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

//
//  SurfaceCoilController.swift
//  Dashboard 2
//
//  Created by John Allen on 5/14/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit



class cameraController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false 
        view.dropShadow(scale: true)
        return view
    }()
    
    let cameraButton: UIButton = {
                let button = UIButton(type: .custom)
                button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
                return button
            }()
    
    
    let coverContainer: UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        
        
    }()
    
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Lepton Thermal Imaging"
        view.textAlignment = .center
        view.font = UIFont(name: "GillSans-SemiBold", size: 42)//UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20)
       //view.backgroundColor = UIColor.blue
        return view
    }()
    
    let subLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Tap the Camera to Connect"
        view.textAlignment = .center
        view.font = UIFont(name: "GillSans-SemiBold", size: 28)//UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20)
        //view.backgroundColor = UIColor.red
        return view
    }()
    
    let webView: UIWebView = {
        let web = UIWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    @objc func cameraTapped() {
        cameraButton.alpha = 1
        titleLabel.alpha = 1
        subLabel.alpha = 1
        UIView.animate(withDuration: 0.4, animations: {
            self.cameraButton.alpha = 0
            self.titleLabel.alpha = 0
            self.subLabel.alpha = 0},
                       completion: { (success: Bool) in
                        self.setupWebview()
        })
        
    }
    
    func setupWebview() {
        
            self.view.addSubview(self.webView)
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
            self.webView.backgroundColor = UIColor.blue
        print("abby")
    view.addSubview(coverContainer)
        
        
        NSLayoutConstraint.activate([
            coverContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            coverContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            coverContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            coverContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ])
        coverContainer.backgroundColor = UIColor.clear
        
        
        let rurl = URL(string: "http://192.168.20.1:8080/")
            self.webView.delegate = self
            self.webView.loadRequest(URLRequest(url: rurl!))
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.refresh))
            tapGR.delegate = self
            tapGR.numberOfTapsRequired = 2
            self.coverContainer.addGestureRecognizer(tapGR)
        
    }
    
    
    @objc func refresh() {
        
     
            webView.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.webView.alpha = 1
                })
            
            let rurl = URL(string: "http://192.168.20.1:8080/")
            
            self.webView.loadRequest(URLRequest(url: rurl!))
            
    }
            
//            webView.removeFromSuperview()
//
//            view.addSubview(webView)
//            NSLayoutConstraint.activate([
//                self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//                self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//                self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//                self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
//                ])
            
        
        
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       view.addSubview(cameraButton)
        view.addSubview(titleLabel)
        view.addSubview(subLabel)
        cameraImageView.image = UIImage(named: "CameraImage")
        
        let image = UIImage(named: "CameraImage")
        cameraButton.setImage(image, for: .normal)
        cameraButton.imageView?.contentMode = .scaleAspectFit
        cameraButton.adjustsImageWhenHighlighted = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
            ])
        
        
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            subLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            subLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
            ])
        
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            cameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200),
            cameraButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -100)
            ])
        
    }
    
}
