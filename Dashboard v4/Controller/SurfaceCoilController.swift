//
//  SurfaceCoilController.swift
//  Dashboard 2
//
//  Created by John Allen on 5/14/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import AVFoundation


class SurfaceCoilController: UIViewController, AreaDetector{
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
   
    let tableView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let coilView1: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coilView2: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
    
        
        return view
    }()
    
    let coilView3: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let coilView4: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coilView5: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coilView6: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coilView7: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coilView8: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coilView9: UIImageView = {
        let view = UIImageView()
        view.isHighlighted = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
       // view.layer.cornerRadius = 10
        //view.backgroundColor = UIColor.blue
        return view
    }()
    
    var timer: Timer?
    
    
    var coilViews: [UIImageView] = []
    
    override func viewWillAppear(_ animated: Bool) {
//         timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    let borderWidth: CGFloat = 2
    let borderColor = UIColor.white
    
    
    @objc func mute() {
        if OptionsController.muteIsOn == true {
            print("dannny")
        speechSynthesizer?.stopSpeaking(at: AVSpeechBoundary.immediate)
        speechSynthesizer = nil
        }
        else {
            speechSynthesizer = AVSpeechSynthesizer()
        }


    
        
        
  
    }
    
    @objc func resetLayout() {
        
        coilView1.image = UIImage(named: "ThreeCoilsInRow")
        coilView2.image = UIImage(named: "ThreeCoils")
        coilView3.image = UIImage(named: "ThreeCoilsInRow")
        coilView4.image = UIImage(named: "ThreeCoils")
        coilView5.image = UIImage(named: "ThreeCoilSmallCircle")
        coilView6.image = UIImage(named: "ThreeCoils")
        coilView7.image = UIImage(named: "ThreeCoilDiagnol")
        coilView8.image = UIImage(named: "ThreeCoils")
        coilView9.image = UIImage(named: "ThreeCoilBigCircle")
        
        resetColors()
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        speechSynthesizer = AVSpeechSynthesizer()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: NSNotification.Name(rawValue: "updateArea"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mute),
                                               name: NSNotification.Name(rawValue: "muteVoice"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetLayout),
                                               name: NSNotification.Name(rawValue: "noCoilsSeen"),
                                               object: nil)
        
       
        
        
        coilViews.append(coilView1)
        coilViews.append(coilView2)
        coilViews.append(coilView3)
        coilViews.append(coilView4)
        coilViews.append(coilView5)
        coilViews.append(coilView6)
        coilViews.append(coilView7)
        coilViews.append(coilView8)
        coilViews.append(coilView9)
        
        containerView.dropShadow()
        view.backgroundColor = UIColor.white
        //tableView.image = UIImage(named: "tablesquare")

        coilView1.layer.borderWidth = borderWidth
         coilView2.layer.borderWidth = borderWidth
         coilView3.layer.borderWidth = borderWidth
         coilView4.layer.borderWidth = borderWidth
         coilView5.layer.borderWidth = borderWidth
         coilView6.layer.borderWidth = borderWidth
         coilView7.layer.borderWidth = borderWidth
         coilView8.layer.borderWidth = borderWidth
         coilView9.layer.borderWidth = borderWidth
        
        resetColors()
        
        
        coilView1.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView2.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView3.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView4.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView5.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView6.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView7.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView8.backgroundColor = colorWithHexString(hexString: "#363636")
        coilView9.backgroundColor = colorWithHexString(hexString: "#363636")
        
        
        
        coilView1.image = UIImage(named: "ThreeCoilsInRow")
        coilView2.image = UIImage(named: "ThreeCoils")
        coilView3.image = UIImage(named: "ThreeCoilsInRow")
        coilView4.image = UIImage(named: "ThreeCoils")
        coilView5.image = UIImage(named: "ThreeCoilSmallCircle")
        coilView6.image = UIImage(named: "ThreeCoils")
        coilView7.image = UIImage(named: "ThreeCoilDiagnol")
        coilView8.image = UIImage(named: "ThreeCoils")
        coilView9.image = UIImage(named: "ThreeCoilBigCircle")
        
       
        
        let topStackView = UIStackView(arrangedSubviews: [coilView1, coilView4, coilView7])
        topStackView.distribution = .fillEqually
        topStackView.axis = .horizontal
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        //topStackView.backgroundColor = colorWithHexString(hexString: "#363636")
        let middleStackView = UIStackView(arrangedSubviews: [coilView2, coilView5, coilView8])
        middleStackView.axis = .horizontal
        middleStackView.distribution = .fillEqually
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        //middleStackView.backgroundColor = UIColor.clear

        let bottomStackView = UIStackView(arrangedSubviews: [coilView3, coilView6, coilView9])
        bottomStackView.distribution = .fillEqually
       bottomStackView.axis = .horizontal
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
       // bottomStackView.backgroundColor = UIColor.clear

        
        let totalStackView = UIStackView(arrangedSubviews: [topStackView,middleStackView,bottomStackView])
        totalStackView.axis = .vertical
        totalStackView.distribution = .fillEqually
        totalStackView.translatesAutoresizingMaskIntoConstraints = false 
        //totalStackView.backgroundColor = colorWithHexString(hexString: "#363636")

        
        
//        view.addSubview(topStackView)
//        view.addSubview(middleStackView)
//        view.addSubview(bottomStackView)
        view.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            totalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            totalStackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20)
            ])
        
        view.addSubview(containerView)
        //containerView.backgroundColor = UIColor.blue
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: totalStackView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 0)
            ])
        
        view.bringSubview(toFront: containerView)
        containerView.layer.zPosition = 1
        containerView.dropShadow(scale: true)
    
//        containerView.layer.shadowOpacity = 1
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOffset = CGSize.zero
//        containerView.layer.shadowRadius = 10
//        containerView.layer.masksToBounds = true
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0)
//            ])
        
    }
    
    var speechSynthesizer: AVSpeechSynthesizer?
    var selectedCoil: Int = 1
    
    func areaChanged(area: Int) {
        print("maryyyyyyyyyyyy")
       // update(area)
    }
    
    @objc func update() {
        
        let speechUtterance: AVSpeechUtterance
        let coilColor = colorWithHexString(hexString: "#fdf959")
        
        coilView1.image = UIImage(named: "ThreeCoilsInRow")
        coilView2.image = UIImage(named: "ThreeCoils")
        coilView3.image = UIImage(named: "ThreeCoilsInRow")
        coilView4.image = UIImage(named: "ThreeCoils")
        coilView5.image = UIImage(named: "ThreeCoilSmallCircle")
        coilView6.image = UIImage(named: "ThreeCoils")
        coilView7.image = UIImage(named: "ThreeCoilDiagnol")
        coilView8.image = UIImage(named: "ThreeCoils")
        coilView9.image = UIImage(named: "ThreeCoilBigCircle")
        
        var selectedColor = colorWithHexString(hexString: "#363636").withAlphaComponent(0.05)  //UIColor.blend(color1: UIColor.white, intensity1: 0.7, color2: colorWithHexString(hexString: "#fdf959"), intensity2: 0.3)//colorWithHexString(hexString: "#fb4434")//colorWithHexString(hexString: "#fdb062")
            //UIColor.blend(color1: UIColor.white, intensity1: 0.7, color2: colorWithHexString(hexString: "#fdf959"), intensity2: 0.3)
        
        //(color1: UIColor.white, color2: colorWithHexString(hexString: "#fdf959"))
        
        resetColors()
        let number = objecDetectorController.sarea
//        let number = Int(Double(arc4random_uniform(9) + 1)) - 1
        selectedCoil = number
//        let colorAnimation = CABasicAnimation(keyPath: "borderColor")
//        colorAnimation.fromValue = UIColor.red.cgColor
//        colorAnimation.toValue = UIColor.blue.cgColor
//        colorAnimation.duration = 0.5
        //colorAnimation.timingFunction = CAMediaTimingFunction(name: "kCAMediaTimingFunctionEaseInEaseOut")
        
        
        self.coilViews[number-1].image = self.coilViews[number-1].image?.imageWithColor(color1: coilColor)
        //self.coilViews[number].backgroundColor = colorWithHexString(hexString: "#363636").withAlphaComponent(0.9)
        self.coilViews[number-1].layer.borderColor = UIColor.white.cgColor
        //self.coilViews[number].layer.add(colorAnimation, forKey: "borderColor")
        
        
        if OptionsController.muteIsOn == false {
        speechUtterance = AVSpeechUtterance(string: "Area \(number) is charging")
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer?.speak(speechUtterance)
        }
        
//        switch number {
//        case 1:
//              speechUtterance = AVSpeechUtterance(string: "Coil 1")
//              coilView1.image = coilView1.image?.imageWithColor(color1: coilColor)
//              coilView1.layer.borderColor = UIColor.white.cgColor
//            coilView1.layer.borderColor?.alpha
//        case 2:
//             speechUtterance = AVSpeechUtterance(string: "Coil 2")
//            coilView2.image = coilView2.image?.imageWithColor(color1: coilColor)
//            coilView2.layer.borderColor = UIColor.white.cgColor
//        case 3:
//              speechUtterance = AVSpeechUtterance(string: "Coil 3")
//            coilView3.image = coilView3.image?.imageWithColor(color1: coilColor)
//            coilView3.layer.borderColor = UIColor.white.cgColor
//        case 4:
//              speechUtterance = AVSpeechUtterance(string: "Coil 4")
//            coilView4.image = coilView4.image?.imageWithColor(color1: coilColor)
//            coilView4.layer.borderColor = UIColor.white.cgColor
//        case 5:
//               speechUtterance = AVSpeechUtterance(string: "Coil 5")
//            coilView5.image = coilView5.image?.imageWithColor(color1: coilColor)
//            coilView5.layer.borderColor = UIColor.white.cgColor
//        case 6:
//               speechUtterance = AVSpeechUtterance(string: "Coil 6")
//            coilView6.image = coilView6.image?.imageWithColor(color1: coilColor)
//            coilView6.layer.borderColor = UIColor.white.cgColor
//        case 7:
//            speechUtterance = AVSpeechUtterance(string: "Coil 7")
//            coilView7.image = coilView7.image?.imageWithColor(color1: coilColor)
//            coilView7.layer.borderColor = UIColor.white.cgColor
//        case 8:
//               speechUtterance = AVSpeechUtterance(string: "Coil 8")
//            coilView8.image = coilView8.image?.imageWithColor(color1: coilColor)
//            coilView8.layer.borderColor = UIColor.white.cgColor
//        case 9:
//               speechUtterance = AVSpeechUtterance(string: "Coil 9")
//            coilView9.image = coilView9.image?.imageWithColor(color1: coilColor)
//            coilView9.layer.borderColor = UIColor.white.cgColor
//        default:
//            speechUtterance = AVSpeechUtterance(string: "Error")
//        }
//
//        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        speechSynthesizer.speak(speechUtterance)
    }
    
    func resetColors() {
        //coilViews[number].layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
//         coilView1.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView2.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView3.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView4.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView5.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView6.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView7.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView8.backgroundColor = colorWithHexString(hexString: "#363636")
//         coilView9.backgroundColor = colorWithHexString(hexString: "#363636")
//
        
        for view in coilViews {
            view.backgroundColor = colorWithHexString(hexString: "#363636")
        }
       
        
        coilView1.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView2.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView3.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView4.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView5.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView6.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView7.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView8.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
         coilView9.layer.borderColor = colorWithHexString(hexString: "#363636").cgColor
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        
        resetColors()
        
        coilView1.image = UIImage(named: "ThreeCoilsInRow")
        coilView2.image = UIImage(named: "ThreeCoils")
        coilView3.image = UIImage(named: "ThreeCoilsInRow")
        coilView4.image = UIImage(named: "ThreeCoils")
        coilView5.image = UIImage(named: "ThreeCoilSmallCircle")
        coilView6.image = UIImage(named: "ThreeCoils")
        coilView7.image = UIImage(named: "ThreeCoilDiagnol")
        coilView8.image = UIImage(named: "ThreeCoils")
        coilView9.image = UIImage(named: "ThreeCoilBigCircle")
    }
    
}




extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}



extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        //layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 100
        
        //layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        //layer.shouldRasterize = true
        //layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


