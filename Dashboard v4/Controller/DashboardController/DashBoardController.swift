//
//  ViewController.swift
//  Dashboard
//
//  Created by John Allen on 5/10/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import DropDownMenuKit
import CoreBluetooth

class DashBoardController: UIViewController, UIGestureRecognizerDelegate, DropDownMenuDelegate {
    
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var sensorTagPeripheral : CBPeripheral?
    
    var browser: MCNearbyServiceBrowser!
    
    var firstTimeSetup = true
    
    var timerForBatteryTemp: Timer?
    
    var selectedDevice: Int? {
        willSet {
            DispatchQueue.main.async { [unowned self] in
            if newValue == nil {
                self.titleView.title = "No Devices Connected"
                self.titleView.layoutSubviews()
            }
            else{
                self.titleView.title = self.peerIDS[newValue! - 1].displayName
                self.titleView.layoutSubviews()
            }
            }
        }
    }
    
    var buttonsCellisShowing = false 
    var firstTimeConnecting = true
    
    var batteryTemp: String?
    
    
    var peerIDS: [MCPeerID] = []
    var deviceNames: [String] = ["", "", ""]
    var batteryLevels: [String] = ["", "", ""]
    var batteryStates: [String] = ["", "", ""]
    var voltages: [String] = ["", "", ""]
    var capacitys: [String] = ["", "", ""]
    
    //var peerIDS:
     var deviceViews: [DeviceView] = []
    
    var titleView: DropDownTitleView!
    @IBOutlet var navigationBarMenu: DropDownMenu!
    @IBOutlet var toolbarMenu: DropDownMenu!
    
    

    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    var graphColorsDecoder: [GraphView.colors] = [.blue, .orange, .pink, .purple]
    
    var graphTypesDecoder: [GraphView.graphType] = [.cubicLineWithArea, .cubicLine, .linearLineWithArea, .linearLine, .bar, .step]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var viewCenter: CGPoint {
        get {
            let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
            let centerY: CGFloat = (view.bounds.height - tabBarHeight!)/2.0
            let centerX: CGFloat = (view.bounds.width)/2.0
            let center = CGPoint(x: centerX, y: centerY)
            return center
        }
    }
   
    var newViewHeight: CGFloat {
        get {
            let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
            return UIScreen.main.bounds.height - tabBarHeight!
        }
    }
    var alternate = true
    
    var newView: UIView!
    
    
   var fullScreenView: GraphView!
    
   var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    
    var effect:UIVisualEffect!
    
    
    var oldHeight:CGFloat = 0
    
    var menucells: [DropDownMenuCell] = []
    
    
    
    
    let graphView1: GraphView = {
        let view = GraphView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        view.graphName = .batteryLevel
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "Battery Level: " 
        //view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.graphColor = .blue
        return view
    }()
    
    let graphView2: GraphView = {
        let view = GraphView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.graphName = .voltage
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "Voltage: "
       // view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.graphColor = .orange
        return view
    }()
    
    let graphView3: GraphView = {
        let view = GraphView()
       // view.translatesAutoresizingMaskIntoConstraints = false
        view.graphName = .capacity
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "Capacity: "
        //view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.graphColor = .pink
        return view
    }()
    
    let graphView4: GraphView = {
        let view = GraphView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.graphName = .wearablevoltage
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "Wearable Voltage: "
       // view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.graphColor = .purple
        return view
    }()
    
    var second = 0
    let popUpView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let overviewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coverContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let singleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topLeftContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topRightContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomLeftContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomRightContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let dropDownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Devices", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dropMenu), for: .touchUpInside)
        return button
    }()
    
    let phoneConnectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect to Iphone", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showConnectivity), for: .touchUpInside)
        return button
    }()
    
    var tap1: UITapGestureRecognizer!
    var tap2: UITapGestureRecognizer!
    var tap3: UITapGestureRecognizer!
    var tap4: UITapGestureRecognizer!

    var taptap1 = UITapGestureRecognizer(target: self, action: #selector(didTap1))
    var taptap2 = UITapGestureRecognizer(target: self, action: #selector(didTap2))
    var taptap3 = UITapGestureRecognizer(target: self, action: #selector(didTap3))
    var taptap4 = UITapGestureRecognizer(target: self, action: #selector(didTap4))
    
    
    var topStackView: UIStackView!
    var bottomStackView: UIStackView!
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    
//
//        
//        effect = visualEffectView.effect
//        visualEffectView.effect = nil
//        
//        peerID = MCPeerID(displayName: UIDevice.current.name)
//        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
//        mcSession.delegate = self
//        
//        view.backgroundColor = colorWithHexString(hexString: "#eaf3f9") //f0f0f0 4d4b4e e3e3e5
//        //view.setGradientBackground(colorOne: colorWithHexString(hexString: "f0f0f0"), colorTwo: colorWithHexString(hexString: "4d4b4e"))
//        initialSetup()
//    }
    
    
    var topAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    var leftAnchor: NSLayoutConstraint?
    var rightAnchor: NSLayoutConstraint?
    var widthAnchor: NSLayoutConstraint?
    
    var topAnchor2: NSLayoutConstraint?
    var bottomAnchor2: NSLayoutConstraint?
    var leftAnchor2: NSLayoutConstraint?
    var rightAnchor2: NSLayoutConstraint?
    var widthAnchor2: NSLayoutConstraint?
    
    var topAnchor3: NSLayoutConstraint?
    var bottomAnchor3: NSLayoutConstraint?
    var leftAnchor3: NSLayoutConstraint?
    var rightAnchor3: NSLayoutConstraint?
    var widthAnchor3: NSLayoutConstraint?
    
    var topAnchor4: NSLayoutConstraint?
    var bottomAnchor4: NSLayoutConstraint?
    var leftAnchor4: NSLayoutConstraint?
    var rightAnchor4: NSLayoutConstraint?
    var widthAnchor4: NSLayoutConstraint?
    
    func initialSetup() {
        
        
        view.addSubview(topContainer)
        view.addSubview(bottomContainer)
        topContainer.addSubview(phoneConnectButton)
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -((self.tabBarController?.tabBar.frame.size.height)! + 40)),
            // topContainer.heightAnchor.constraint(equalToConstant: (newViewHeight/2) - 60)
            ])
        
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -((self.tabBarController?.tabBar.frame.size.height)! + 40)),
            //bottomContainer.heightAnchor.constraint(equalToConstant: (newViewHeight/2) - 60),
            bottomContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -40),
            //bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 40),
            ])
        
        
        phoneConnectButton.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor, constant: 0).isActive = true
        phoneConnectButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor, constant:0).isActive = true
        phoneConnectButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        phoneConnectButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        phoneConnectButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        phoneConnectButton.layer.borderWidth = 1
        phoneConnectButton.layer.borderColor = UIColor.black.cgColor
        
        
        phoneConnectButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        phoneConnectButton.setTitleColor(UIColor.black, for: .normal)
        phoneConnectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 100)
        phoneConnectButton.titleLabel?.numberOfLines = 1
        phoneConnectButton.titleLabel?.adjustsFontSizeToFitWidth = true
        phoneConnectButton.titleLabel?.baselineAdjustment = .alignCenters
        phoneConnectButton.layer.cornerRadius = 25
        
    }
    
    
    func setupTopContainer() {
        
        phoneConnectButton.removeFromSuperview()
        
        topContainer.addSubview(graphView1)
        topContainer.addSubview(graphView2)
        
        topContainer.alpha = 0
        bottomContainer.alpha = 0
        
        tap1 = UITapGestureRecognizer(target: self, action: #selector(didTap1))
        tap2 = UITapGestureRecognizer(target: self, action: #selector(didTap2))
        graphView1.addGestureRecognizer(tap1)
        graphView2.addGestureRecognizer(tap2)
        
        topAnchor =  graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
        topAnchor?.isActive = true
        bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
        bottomAnchor?.isActive = true
        leftAnchor = graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0)
        leftAnchor?.isActive = true
        widthAnchor = graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor?.isActive = true
        
        
        topAnchor2 =  graphView2.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
        topAnchor2?.isActive = true
        bottomAnchor2 =  graphView2.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
        bottomAnchor2?.isActive = true
        rightAnchor2 = graphView2.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0)
        rightAnchor2?.isActive = true
        widthAnchor2 =  graphView2.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor2?.isActive = true
        
        UIView.animate(withDuration: 0.4,
                       animations: { self.topContainer.alpha = 1
            self.bottomContainer.alpha = 1})
    }
    
    func setupViews() {
        
        topContainer.removeFromSuperview()
        bottomContainer.removeFromSuperview()
        graphView1.removeFromSuperview()
        graphView2.removeFromSuperview()
        graphView3.removeFromSuperview()
        graphView4.removeFromSuperview()
        
        view.addSubview(topContainer)
        view.addSubview(bottomContainer)
        topContainer.addSubview(graphView1)
        topContainer.addSubview(graphView2)
        bottomContainer.addSubview(graphView3)
        bottomContainer.addSubview(graphView4)
        
        

        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -((self.tabBarController?.tabBar.frame.size.height)! + 40)),
           // topContainer.heightAnchor.constraint(equalToConstant: (newViewHeight/2) - 60)
            ])
        
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -((self.tabBarController?.tabBar.frame.size.height)! + 40)),
            //bottomContainer.heightAnchor.constraint(equalToConstant: (newViewHeight/2) - 60),
            bottomContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -40),
            //bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 40),
            ])
        
        tap1 = UITapGestureRecognizer(target: self, action: #selector(didTap1))
        tap2 = UITapGestureRecognizer(target: self, action: #selector(didTap2))
        tap3 = UITapGestureRecognizer(target: self, action: #selector(didTap3))
        tap4 = UITapGestureRecognizer(target: self, action: #selector(didTap4))
        graphView1.addGestureRecognizer(tap1)
        graphView2.addGestureRecognizer(tap2)
        graphView3.addGestureRecognizer(tap3)
        graphView4.addGestureRecognizer(tap4)
        
        
        topAnchor =  graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
        topAnchor?.isActive = true
        bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
        bottomAnchor?.isActive = true
        leftAnchor = graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0)
        leftAnchor?.isActive = true
        widthAnchor = graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor?.isActive = true
        
        
        topAnchor2 =  graphView2.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
        topAnchor2?.isActive = true
        bottomAnchor2 =  graphView2.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
        bottomAnchor2?.isActive = true
        rightAnchor2 = graphView2.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0)
        rightAnchor2?.isActive = true
        widthAnchor2 =  graphView2.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor2?.isActive = true
        
        
//        NSLayoutConstraint.activate([
//            graphView2.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0),
//            graphView2.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5),
//            graphView2.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0),
//            graphView2.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0)
//            ])
//
        topAnchor3 =  graphView3.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
        topAnchor3?.isActive = true
        bottomAnchor3 = graphView3.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
        bottomAnchor3?.isActive = true
        leftAnchor3 = graphView3.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0)
        leftAnchor3?.isActive = true
        widthAnchor3 = graphView3.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor3?.isActive = true
        
        
//        NSLayoutConstraint.activate([
//            graphView3.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0),
//            graphView3.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0),
//            graphView3.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0),
//            graphView3.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5)
//            ])
        
        topAnchor4 =  graphView4.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
        topAnchor4?.isActive = true
        bottomAnchor4 = graphView4.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
        bottomAnchor4?.isActive = true
        rightAnchor4 =  graphView4.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: 0)
        rightAnchor4?.isActive = true
        widthAnchor4 = graphView4.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor4?.isActive = true
        
        
        
//        NSLayoutConstraint.activate([
//            graphView4.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0),
//            graphView4.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5),
//            graphView4.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0),
//            graphView4.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: 0)
//            ])
    
        
        oldHeight = newViewHeight
        
    }
    
    
    @objc func didTap1() {
        tapAnimate(graphView: 1)
        
    }
    
    
    @objc func didTap2() {
        tapAnimate(graphView: 2)
        
    }
    
    @objc func didTap3() {
        tapAnimate(graphView: 3)
        
    }
    
    @objc func didTap4() {
        tapAnimate(graphView: 4)
        
    }
    
    func tapAnimate(graphView: Int)
    
    {
      
//        graphView1.removeFromSuperview()
//        graphView2.removeFromSuperview()
//        graphView3.removeFromSuperview()
//        graphView4.removeFromSuperview()
//        bottomContainer.removeFromSuperview()
//        topContainer.removeFromSuperview()
//
        switch graphView {
        case 1:
            topContainer.bringSubview(toFront: graphView1)
            view.bringSubview(toFront: topContainer)
            
         
            
            widthAnchor?.isActive = false
            topAnchor?.isActive = false
            leftAnchor?.isActive = false
            bottomAnchor?.isActive = false
            topAnchor = graphView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
            topAnchor?.isActive = true
            leftAnchor = graphView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            leftAnchor?.isActive = true
            rightAnchor = graphView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            rightAnchor?.isActive = true
            bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -40)
            bottomAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()}, completion: { (success:Bool) in
                self.graphView2.removeFromSuperview()
                self.graphView3.removeFromSuperview()
                self.graphView4.removeFromSuperview()
        })
        
            tap1 = UITapGestureRecognizer(target: self, action: #selector(didTapAgain1))
            graphView1.removeGestureRecognizer(tap1)
            graphView1.addGestureRecognizer(tap1)
            graphView2.removeGestureRecognizer(tap2)
            graphView3.removeGestureRecognizer(tap3)
            graphView4.removeGestureRecognizer(tap4)
   
        case 2:
            topContainer.bringSubview(toFront: graphView2)
            view.bringSubview(toFront: topContainer)
            
            widthAnchor2?.isActive = false
            topAnchor2?.isActive = false
            leftAnchor2?.isActive = false
            bottomAnchor2?.isActive = false
            topAnchor2 =  graphView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
            topAnchor2?.isActive = true
            leftAnchor2 = graphView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            leftAnchor2?.isActive = true
            rightAnchor2 = graphView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            rightAnchor2?.isActive = true
            bottomAnchor2 = graphView2.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -40)
            bottomAnchor2?.isActive = true
            
//
            
            UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()}, completion: { (success:Bool) in
                self.graphView1.removeFromSuperview()
                self.graphView3.removeFromSuperview()
                self.graphView4.removeFromSuperview()
            })
            
            
            graphView2.removeGestureRecognizer(tap2)
            tap2 = UITapGestureRecognizer(target: self, action: #selector(didTapAgain2))
            graphView2.addGestureRecognizer(tap2)
            graphView1.removeGestureRecognizer(tap1)
            graphView3.removeGestureRecognizer(tap3)
            graphView4.removeGestureRecognizer(tap4)
            
            
        case 3:
            bottomContainer.bringSubview(toFront: graphView3)
            view.bringSubview(toFront: bottomContainer)
            
            widthAnchor3?.isActive = false
            topAnchor3?.isActive = false
            leftAnchor3?.isActive = false
            bottomAnchor3?.isActive = false
            topAnchor3 = graphView3.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
            topAnchor3?.isActive = true
            leftAnchor3 = graphView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            leftAnchor3?.isActive = true
            rightAnchor3 = graphView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            rightAnchor3?.isActive = true
            bottomAnchor3 = graphView3.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -40)
            bottomAnchor3?.isActive = true
        
            UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()}, completion: { (success:Bool) in
                self.graphView2.removeFromSuperview()
                self.graphView1.removeFromSuperview()
                self.graphView4.removeFromSuperview()
            })
            
            graphView3.removeGestureRecognizer(tap3)
            tap3 = UITapGestureRecognizer(target: self, action: #selector(didTapAgain3))
            graphView3.addGestureRecognizer(tap3)
            graphView1.removeGestureRecognizer(tap1)
            graphView2.removeGestureRecognizer(tap2)
            graphView4.removeGestureRecognizer(tap4)
            
        case 4:
            bottomContainer.bringSubview(toFront: graphView4)
            view.bringSubview(toFront: bottomContainer)
            
            widthAnchor4?.isActive = false
            topAnchor4?.isActive = false
            leftAnchor4?.isActive = false
            rightAnchor4?.isActive = false
            bottomAnchor4?.isActive = false
            
            topAnchor4 = graphView4.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
            topAnchor4?.isActive = true
           leftAnchor4 = graphView4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            leftAnchor4?.isActive = true
           rightAnchor4 = graphView4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            rightAnchor4?.isActive = true
            bottomAnchor4 = graphView4.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -40)
            bottomAnchor4?.isActive = true
            
           
            UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()}, completion: { (success:Bool) in
                self.graphView2.removeFromSuperview()
                self.graphView1.removeFromSuperview()
                self.graphView3.removeFromSuperview()
            })
            graphView4.removeGestureRecognizer(tap4)
            tap4 = UITapGestureRecognizer(target: self, action: #selector(didTapAgain4))
            graphView4.addGestureRecognizer(tap4)
            graphView1.removeGestureRecognizer(tap1)
            graphView2.removeGestureRecognizer(tap2)
            graphView3.removeGestureRecognizer(tap3)
           
            
        default:
            print("noooo")
        }
        
    }
    
    @objc func didTapAgain1() {
        
        resetViews(1)
        
        widthAnchor?.isActive = false
        topAnchor?.isActive = false
        leftAnchor?.isActive = false
        bottomAnchor?.isActive = false
        rightAnchor?.isActive = false
        
        topAnchor =  graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
        topAnchor?.isActive = true
        bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
        bottomAnchor?.isActive = true
        leftAnchor = graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0)
        leftAnchor?.isActive = true
        widthAnchor = graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()})
        graphView1.removeGestureRecognizer(tap1)
        tap1 = UITapGestureRecognizer(target: self, action: #selector(didTap1))
        graphView1.addGestureRecognizer(tap1)
        tap2 = UITapGestureRecognizer(target: self, action: #selector(didTap2))
        graphView2.addGestureRecognizer(tap2)
        tap3 = UITapGestureRecognizer(target: self, action: #selector(didTap3))
        graphView3.addGestureRecognizer(tap3)
        tap4 = UITapGestureRecognizer(target: self, action: #selector(didTap4))
        graphView4.addGestureRecognizer(tap4)
        
        
    }
    
    @objc func didTapAgain2() {
        
        resetViews(2)
        
        widthAnchor2?.isActive = false
        topAnchor2?.isActive = false
        leftAnchor2?.isActive = false
        bottomAnchor2?.isActive = false
        rightAnchor2?.isActive = false
        
        topAnchor2 =  graphView2.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
        topAnchor2?.isActive = true
        bottomAnchor2 =  graphView2.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
        bottomAnchor2?.isActive = true
        rightAnchor2 = graphView2.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0)
        rightAnchor2?.isActive = true
        widthAnchor2 =  graphView2.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor2?.isActive = true
        
        
        UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()})
        graphView2.removeGestureRecognizer(tap2)
        tap2 = UITapGestureRecognizer(target: self, action: #selector(didTap2))
        graphView2.addGestureRecognizer(tap2)
        tap1 = UITapGestureRecognizer(target: self, action: #selector(didTap1))
        graphView1.addGestureRecognizer(tap1)
        tap3 = UITapGestureRecognizer(target: self, action: #selector(didTap3))
        graphView3.addGestureRecognizer(tap3)
        tap4 = UITapGestureRecognizer(target: self, action: #selector(didTap4))
        graphView4.addGestureRecognizer(tap4)
    }
    
    @objc func didTapAgain3() {
        
        resetViews(3)
        
        widthAnchor3?.isActive = false
        topAnchor3?.isActive = false
        leftAnchor3?.isActive = false
        bottomAnchor3?.isActive = false
        rightAnchor3?.isActive = false
        
        topAnchor3 =  graphView3.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
        topAnchor3?.isActive = true
        bottomAnchor3 = graphView3.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
        bottomAnchor3?.isActive = true
        leftAnchor3 = graphView3.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0)
        leftAnchor3?.isActive = true
        widthAnchor3 = graphView3.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor3?.isActive = true
        
        UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()})
        graphView3.removeGestureRecognizer(tap3)
        tap3 = UITapGestureRecognizer(target: self, action: #selector(didTap3))
        graphView3.addGestureRecognizer(tap3)
        tap1 = UITapGestureRecognizer(target: self, action: #selector(didTap1))
        graphView1.addGestureRecognizer(tap1)
        tap2 = UITapGestureRecognizer(target: self, action: #selector(didTap2))
        graphView2.addGestureRecognizer(tap2)
        tap4 = UITapGestureRecognizer(target: self, action: #selector(didTap4))
        graphView4.addGestureRecognizer(tap4)
    }
    
    @objc func didTapAgain4() {
        
        resetViews(4)
        
        widthAnchor4?.isActive = false
        topAnchor4?.isActive = false
        leftAnchor4?.isActive = false
        bottomAnchor4?.isActive = false
        rightAnchor4?.isActive = false
        
        topAnchor4 =  graphView4.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
        topAnchor4?.isActive = true
        bottomAnchor4 = graphView4.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
        bottomAnchor4?.isActive = true
        rightAnchor4 =  graphView4.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: 0)
        rightAnchor4?.isActive = true
        widthAnchor4 = graphView4.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
        widthAnchor4?.isActive = true
        
    

        UIView.animate(withDuration: 0.4, animations: {self.view.layoutIfNeeded()})
        graphView4.removeGestureRecognizer(tap4)
        tap4 = UITapGestureRecognizer(target: self, action: #selector(didTap4))
        graphView4.addGestureRecognizer(tap4)
        tap1 = UITapGestureRecognizer(target: self, action: #selector(didTap1))
        graphView1.addGestureRecognizer(tap1)
        tap2 = UITapGestureRecognizer(target: self, action: #selector(didTap2))
        graphView2.addGestureRecognizer(tap2)
        tap3 = UITapGestureRecognizer(target: self, action: #selector(didTap3))
        graphView3.addGestureRecognizer(tap3)
       
    }
        

    func resetViews(_ number: Int) {
        
        switch number {
        case 1:
            topContainer.addSubview(graphView2)
            bottomContainer.addSubview(graphView3)
            bottomContainer.addSubview(graphView4)
            
            topContainer.bringSubview(toFront: graphView1)
            view.bringSubview(toFront: topContainer)
            
            topAnchor2 =  graphView2.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
            topAnchor2?.isActive = true
            bottomAnchor2 =  graphView2.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
            bottomAnchor2?.isActive = true
            rightAnchor2 = graphView2.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0)
            rightAnchor2?.isActive = true
            widthAnchor2 =  graphView2.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor2?.isActive = true
            
            
            topAnchor3 =  graphView3.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
            topAnchor3?.isActive = true
            bottomAnchor3 = graphView3.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
            bottomAnchor3?.isActive = true
            leftAnchor3 = graphView3.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0)
            leftAnchor3?.isActive = true
            widthAnchor3 = graphView3.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor3?.isActive = true
            
            
            topAnchor4 =  graphView4.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
            topAnchor4?.isActive = true
            bottomAnchor4 = graphView4.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
            bottomAnchor4?.isActive = true
            rightAnchor4 =  graphView4.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: 0)
            rightAnchor4?.isActive = true
            widthAnchor4 = graphView4.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor4?.isActive = true
            
        case 2:
            topContainer.addSubview(graphView1)
            bottomContainer.addSubview(graphView3)
            bottomContainer.addSubview(graphView4)
            
            topContainer.bringSubview(toFront: graphView2)
            view.bringSubview(toFront: topContainer)
            
            topAnchor =  graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
            topAnchor?.isActive = true
            bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
            bottomAnchor?.isActive = true
            leftAnchor = graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0)
            leftAnchor?.isActive = true
            widthAnchor = graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor?.isActive = true
            
            topAnchor3 =  graphView3.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
            topAnchor3?.isActive = true
            bottomAnchor3 = graphView3.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
            bottomAnchor3?.isActive = true
            leftAnchor3 = graphView3.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0)
            leftAnchor3?.isActive = true
            widthAnchor3 = graphView3.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor3?.isActive = true
            
            
            topAnchor4 =  graphView4.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
            topAnchor4?.isActive = true
            bottomAnchor4 = graphView4.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
            bottomAnchor4?.isActive = true
            rightAnchor4 =  graphView4.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: 0)
            rightAnchor4?.isActive = true
            widthAnchor4 = graphView4.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor4?.isActive = true
            
        case 3:
            topContainer.addSubview(graphView1)
            topContainer.addSubview(graphView2)
            bottomContainer.addSubview(graphView4)
            
            bottomContainer.bringSubview(toFront: graphView3)
            view.bringSubview(toFront: bottomContainer)
            
            topAnchor =  graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
            topAnchor?.isActive = true
            bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
            bottomAnchor?.isActive = true
            leftAnchor = graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0)
            leftAnchor?.isActive = true
            widthAnchor = graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor?.isActive = true
            
            
            topAnchor2 =  graphView2.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
            topAnchor2?.isActive = true
            bottomAnchor2 =  graphView2.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
            bottomAnchor2?.isActive = true
            rightAnchor2 = graphView2.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0)
            rightAnchor2?.isActive = true
            widthAnchor2 =  graphView2.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor2?.isActive = true
            
            topAnchor4 =  graphView4.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
            topAnchor4?.isActive = true
            bottomAnchor4 = graphView4.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
            bottomAnchor4?.isActive = true
            rightAnchor4 =  graphView4.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: 0)
            rightAnchor4?.isActive = true
            widthAnchor4 = graphView4.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor4?.isActive = true
            
        case 4:
            topContainer.addSubview(graphView1)
            topContainer.addSubview(graphView2)
            bottomContainer.addSubview(graphView3)
            
            bottomContainer.bringSubview(toFront: graphView4)
            view.bringSubview(toFront: bottomContainer)
            
            topAnchor =  graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
            topAnchor?.isActive = true
            bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
            bottomAnchor?.isActive = true
            leftAnchor = graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0)
            leftAnchor?.isActive = true
            widthAnchor = graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor?.isActive = true
            
            
            topAnchor2 =  graphView2.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
            topAnchor2?.isActive = true
            bottomAnchor2 =  graphView2.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
            bottomAnchor2?.isActive = true
            rightAnchor2 = graphView2.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: 0)
            rightAnchor2?.isActive = true
            widthAnchor2 =  graphView2.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor2?.isActive = true
            
            
            topAnchor3 =  graphView3.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
            topAnchor3?.isActive = true
            bottomAnchor3 = graphView3.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
            bottomAnchor3?.isActive = true
            leftAnchor3 = graphView3.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0)
            leftAnchor3?.isActive = true
            widthAnchor3 = graphView3.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5, constant: -10)
            widthAnchor3?.isActive = true
            
        default:
            print("hello")
        }
        
    }
    
    @objc func didTapAgain() {
//        graphView1.removeFromSuperview()
//        graphView2.removeFromSuperview()
//        graphView3.removeFromSuperview()
//        graphView4.removeFromSuperview()
//        bottomContainer.removeFromSuperview()
//        topContainer.removeFromSuperview()
//        view.sendSubview(toBack: topContainer)
//        topContainer.sendSubview(toBack: graphView1)
       
        
        widthAnchor?.isActive = false
        topAnchor?.isActive = false
        leftAnchor?.isActive = false
        bottomAnchor?.isActive = false
        rightAnchor?.isActive = false

        topAnchor =  graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0)
        topAnchor?.isActive = true
        bottomAnchor = graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0)
        bottomAnchor?.isActive = true
        leftAnchor = graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0)
        leftAnchor?.isActive = true
        widthAnchor = graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5)
        widthAnchor?.isActive = true
        
        
        widthAnchor3?.isActive = false
        topAnchor3?.isActive = false
        leftAnchor3?.isActive = false
        bottomAnchor3?.isActive = false
        rightAnchor3?.isActive = false
        
        topAnchor3 =  graphView3.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 0)
        topAnchor3?.isActive = true
        bottomAnchor3 = graphView3.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: 0)
        bottomAnchor3?.isActive = true
        leftAnchor3 = graphView3.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0)
        leftAnchor3?.isActive = true
        widthAnchor3 = graphView3.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.5)
        widthAnchor3?.isActive = true
        
        
//        NSLayoutConstraint.activate([
//            graphView1.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 0),
//            graphView1.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 0),
//            graphView1.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 0),
//            graphView1.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.5)
//            ])
        
       // setupViews()
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()})
        //UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {self.view.layoutIfNeeded()}, completion: nil)
        
        }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//       setupViews()
//        self.updateViewConstraints()
//        UIView.animate(withDuration: 0.7, animations: {self.view.layoutIfNeeded()})
//
//        //UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {self.view.layoutIfNeeded()}, completion: nil)
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    
    
}


extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}
