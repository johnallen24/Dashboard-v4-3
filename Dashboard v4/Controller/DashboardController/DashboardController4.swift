//
//  DashboardController4.swift
//  Dashboard 2
//
//  Created by John Allen on 5/23/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import DropDownMenuKit

extension DashBoardController: MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceBrowserDelegate {
    
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found em")
    }
    
    
    
    
    
    
    var numDevices: Int {
        get {
            return mcSession.connectedPeers.count
        }
    }
    
    
    func createDeviceView() -> UIView {
        
        let view = DeviceView()
        return view
        
        
    }
    
    @objc func connectWearable() {
        
    }
    
    @objc func showConnectivity(_ sender: UIButton) {
        self.joinSession()
    }
    
    func startHosting() {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    
    func joinSession() {
//                print("hey")
//                browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "hws-kb")
//               browser.startBrowsingForPeers()
//                browser.delegate = self
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: self.mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    
    //    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    //        print(peerID.displayName)
    //        browser.invitePeer(peerID, to: self.mcSession, withContext: nil, timeout: 10)
    //    }
    //
    //    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    //        print("dude hello there")
    //    }
    
    
    
    @objc func graphTemp() {
        print("freddie")
        if let batTemp = batteryTemp {
            if let dbatTemp = Double(batTemp) {
                graphView4.update(number: dbatTemp)
            }
        }
        else {
            print("no battery temp available")
        }
    }
    
    //    @objc func HasSentPacket() {
    //        if hasRecievedPacket == true {
    //            hasRecievedPacket = false
    //            return
    //        }
    //
    //        //        if hasRecievedPacket == false {
    //        //            var i = 0
    //        //            var j = 0
    //        //            var p: MCPeerID? = nil
    //        //            while i < self.peerIDS.count {
    //        //                while j < self.peerIDS.count {
    //        //                if peerIDS[i] == mcSession.connectedPeers[j]
    //        //                    peerID
    //        //                    j = j +1
    //        //                }
    //        //            }
    //
    //        if hasRecievedPacket == false {
    //            if selectedDevice != nil {
    //                let peerID = peerIDS[selectedDevice! - 1]
    //                let alert = UIAlertController(title: "\(peerID.displayName) Disconnected", message: nil, preferredStyle: .alert)
    //                print("jamie")
    //                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    //                self.present(alert, animated: true)
    //                for cell in self.navigationBarMenu.menuCells {
    //
    //                    if cell is connectedPhonesCell {
    //                        let view = (cell as! connectedPhonesCell).overStackView.arrangedSubviews[selectedDevice! - 1] as! DeviceView
    //
    //                        view.phoneImageView.image = nil
    //                        view.nameLabel.text = ""
    //                        view.deviceInfoTextView.text = ""
    //                    }
    //                }
    //                self.peerIDS.remove(at: selectedDevice! - 1)
    //                if self.peerIDS.count == 0
    //                {
    //                    print("joke")
    //                    self.selectedDevice = nil
    //                }
    //                else {
    //                    self.selectedDevice = self.peerIDS.count
    //                }
    //                if self.peerIDS.count == 0 {
    //                    self.timerForBatteryTemp?.invalidate()
    //                    self.timerForBatteryTemp = nil
    //                }
    //            }
    //        }
    //
    //
    //    }
    
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            DispatchQueue.main.async { [unowned self] in
                //                self.timer2 = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.HasSentPacket), userInfo: nil, repeats: true)
                //self.timerForBatteryTemp = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.graphTemp), userInfo: nil, repeats: true)
                self.peerIDS.append(peerID)
                
                self.selectedDevice = self.peerIDS.count
                self.dismiss(animated: true, completion: nil)
                //addPhoneToCell()
                //updateMenuCells()
            }
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            DispatchQueue.main.async { [unowned self] in
                print("Not Connected: \(peerID.displayName)")
                var i = 0
                for p in self.peerIDS {
                    if p == peerID {
                        let alert = UIAlertController(title: "\(peerID.displayName) Disconnected", message: nil, preferredStyle: .alert)
                        print("horford")
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        for cell in self.navigationBarMenu.menuCells {
                            
                            if cell is connectedPhonesCell {
                                let view = (cell as! connectedPhonesCell).overStackView.arrangedSubviews[i] as! DeviceView
                                
                                view.phoneImageView.image = nil
                                view.nameLabel.text = ""
                                view.deviceInfoTextView.text = ""
                            }
                        }
                        self.peerIDS.remove(at: i)
                        if self.selectedDevice != nil {
                            if (i+1) == self.selectedDevice! {
                                if self.peerIDS.count == 0
                                {
                                    print("joke")
                                    self.selectedDevice = nil
                                }
                                else {
                                    self.selectedDevice = self.peerIDS.count
                                }
                            }
                        }
                        
                    }
                    i = i + 1
                }
                if self.peerIDS.count == 0 {
                    self.timerForBatteryTemp?.invalidate()
                    self.timerForBatteryTemp = nil
                }
            }
            
        }
    }
    
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! Dictionary<String, String>
        DispatchQueue.main.async { [unowned self] in
            //self.hasRecievedPacket = true
            var i = 0
            
            while i < self.peerIDS.count
            {
                if self.peerIDS[i] == peerID {
                    
                    if let name = dictionary["name"] {
                        print(name)
                        self.deviceNames[i] = name
                    }
                    
                    if let level = dictionary["level"] {
                        print(level)
                        self.batteryLevels[i] = level
                    }
                    
                    if let batteryState = dictionary["batteryState"] {
                        let num = Int(batteryState)
                        if num == 1 {
                            self.batteryStates[i] = "No"
                        }
                        else if num == 2 || num == 3 {
                            self.batteryStates[i] = "Yes"
                        }
                        else {
                            self.batteryStates[i] = "Unknown"
                        }
                        
                    }
                    
                    if let voltage = dictionary["voltage"] {
                        self.voltages[i] = voltage
                    }
                    
                    if let capacity = dictionary["capacity"] {
                        self.capacitys[i] = capacity
                    }
                    
                }
                i = i + 1
            }
            self.updateConnectedPhones()
        }
    }
    
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    
    func updateConnectedPhones() {
        
        
        if let device = selectedDevice {
            for cell in navigationBarMenu.menuCells {
                
                if cell is connectedPhonesCell {
                    let view = (cell as! connectedPhonesCell).overStackView.arrangedSubviews[device - 1] as! DeviceView
                    
                    view.phoneImageView.image = UIImage(named: "Iphone 8")
                    view.nameLabel.text = deviceNames[numDevices - 1]
                    view.deviceInfoTextView.text = "Battery: \(batteryLevels[numDevices - 1])%\nCharging: \(batteryStates[numDevices - 1])\nVoltage: \(voltages[numDevices-1]) V\nCapacity: \(capacitys[numDevices-1]) mAh"
                    
                    //                let fullString = NSMutableAttributedString(string: "Battery: \(batteryLevels[numDevices - 1])%\n Charging: ")
                    //
                    //                // create our NSTextAttachment
                    //                let image1Attachment = NSTextAttachment()
                    //                image1Attachment.image = UIImage(named: "GreenCheckIcon")
                    //                let iconsSize = CGRect(x: 0, y: 0, width: 15, height: 15)
                    //                image1Attachment.bounds = iconsSize
                    //                // wrap the attachment in its own attributed string so we can append it
                    //                let image1String = NSAttributedString(attachment: image1Attachment)
                    //
                    //                // add the NSTextAttachment wrapper to our full string, then add some more text.
                    //                fullString.append(image1String)
                    //
                    //                view.deviceInfoTextView.attributedText = fullString
                    //                // draw the result in a label
                    //
                    //                view.deviceInfoTextView.attributedText = fullString
                    
                    if let dvoltage = Double(voltages[device - 1]) {
                        graphView2.update(number: dvoltage)
                    }
                    if let dcapacity = Double(capacitys[device - 1]) {
                        graphView3.update(number: dcapacity)
                    }
                    
                    if let dBatteryPercent = Double(batteryLevels[device - 1]) {
                        graphView1.update(number: dBatteryPercent)
                    }
                    
                    self.graphTemp()
                    
                    
                    
                }
            }
        }
    }
    
    //    func setupConnectedPhonesCell() {
    //        let cell = connectedPhonesCell()
    //        cell.rowHeight = 400
    //        cell.isUserInteractionEnabled = true
    //        cell.menuAction = nil
    //        cell.menuTarget = nil
    //        //cell.delegate = self
    //        navigationBarMenu.menuCells.append(cell)
    //
    //    }
    
    //    func addPhoneToCell() {
    //
    //        for cell in navigationBarMenu.menuCells {
    //
    //            if cell is connectedPhonesCell {
    //                let view = (cell as! connectedPhonesCell).overStackView.arrangedSubviews[peerIDS.count - 1] as! DeviceView
    //                view.phoneImageView.image = UIImage(named: "Iphone 8")
    //                view.phoneImageView.backgroundColor = UIColor.purple
    //                view.nameLabel.text = deviceNames[numDevices - 1]
    //                view.deviceInfoTextView.text = "Battery Level: \(batteryLevels[numDevices - 1])\nIs Connected: \(batteryStates[numDevices - 1])"
    //            }
    //        }
    //
    //    }
    //
    
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        if firstTimeConnecting {
            //setupConnectedPhonesCell()
            firstTimeConnecting = false
        }
        //        if mcSession.connectedPeers.count > 0 {
        //            addPhoneToCell()
        //        }
        
        //var i = 0
        
        buttonsCellisShowing = false
        dismiss(animated: true, completion: nil)
        
        //        for cell in navigationBarMenu.menuCells {
        //
        //            if cell is dropDownButtonsCell {
        //                navigationBarMenu.menuView.beginUpdates()
        //
        //                navigationBarMenu.menuCells.remove(at: i)
        //                let path = navigationBarMenu.menuView.indexPathForRow(at: (cell as! DropDownMenuCell).center)!
        //                navigationBarMenu.menuView.deleteRows(at: [path], with: .automatic)
        //                navigationBarMenu.menuView.endUpdates()
        //
        //            }
        //            i = i + 1
        //
        //        }
        
    }
    
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}




