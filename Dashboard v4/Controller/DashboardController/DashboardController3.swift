//
//  DashboardController3.swift
//  Dashboard 2
//
//  Created by John Allen on 5/21/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//

import UIKit
import DropDownMenuKit

extension DashBoardController: dropDownButtonsCellDelegate, deviceSelectionDelegate {
   
    
   
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateMenuContentInsets()
}

func prepareNavigationBarMenuTitleView() -> String {

    titleView = DropDownTitleView()
    titleView.addTarget(self,
                        action: #selector(DashBoardController.willToggleNavigationBarMenu(_:)),
                        for: .touchUpInside)
    titleView.addTarget(self,
                        action: #selector(DashBoardController.didToggleNavigationBarMenu(_:)),
                        for: .valueChanged)
    titleView.titleLabel.textColor = UIColor.black
    titleView.title = "hey"
    navigationItem.titleView = titleView
    print(titleView.title!)
    return titleView.title!
}

   
    
//     @objc func updateMenuCells() {
//        titleView.title = DevicesController.peerIDS.last?.displayName
//        for peer in DevicesController.peerIDS {
//            let cell = DropDownMenuCell()
//            cell.textLabel?.text = peer.displayName
//            cell.menuAction = #selector(DashBoardController.choose(_:))
//            cell.menuTarget = self
//            menucells.append(cell)
//
//        }
//        navigationBarMenu.menuCells = menucells
//        if DevicesController.peerIDS.count > 0 {
//            print("hello")
//        titleView.title = DevicesController.peerIDS.last?.displayName
//        navigationBarMenu.selectMenuCell(menucells.last!)
//
//        }
//    }
//
    
    func deviceSelected(view: DeviceView) {
        if view.tag <= peerIDS.count {
        selectedDevice = view.tag
            
        }
    }
   
    func buttonPressed(view: customButtonView) {
        
        switch view.tag {
        case 1:
            self.joinSession()
        case 2:
            if let peripheral = sensorTagPeripheral {
             self.centralManager.connect(peripheral)
            }
            else {
                print("dude hello")
                let alert = UIAlertController(title: "Cannot Connect", message: nil, preferredStyle: .alert)
                print("horford")
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        default:
            break
        }
    }
    
    
    
 
    @objc func connect(_ sender: AnyObject) {
        
        if buttonsCellisShowing {
            navigationBarMenu.menuView.beginUpdates()
            let path = IndexPath(row: 1, section: 0)
             navigationBarMenu.menuCells.remove(at: 1)
              navigationBarMenu.menuView.deleteRows(at: [path], with: .bottom)
            
             navigationBarMenu.menuView.endUpdates()
            buttonsCellisShowing = false
        }
        else {
            navigationBarMenu.menuView.beginUpdates()
        let cell = dropDownButtonsCell()
        cell.rowHeight = 200
        cell.isUserInteractionEnabled = true
        cell.menuAction = nil
        cell.menuTarget = nil
        cell.delegate = self
            cell.isHidden = true
        navigationBarMenu.menuCells.insert(cell, at: 1)
        let path = IndexPath(row: 1, section: 0)
        
       //let path = navigationBarMenu.menuView.indexPathForRow(at: (sender as! DropDownMenuCell).center)!
            navigationBarMenu.menuView.reloadData()
            navigationBarMenu.menuView.insertRows(at: [path], with: .automatic)
      UIView.animate(withDuration: 0.4, animations: {cell.isHidden = false})
        navigationBarMenu.menuView.endUpdates()
            buttonsCellisShowing = true
            }
        
    }
    
    
    func prepareNavigationBarMenu(_ currentChoice: String) {
        navigationBarMenu = DropDownMenu(frame: coverContainer.bounds)
        navigationBarMenu.delegate = self
        let connectCell = dropDownOverrideCell()
        connectCell.rowHeight = 60
        connectCell.showsCheckmark = false
        
        let buttonCell = dropDownButtonsCell()
        buttonCell.rowHeight = 200
        buttonCell.isUserInteractionEnabled = true
        buttonCell.menuAction = nil
        buttonCell.menuTarget = nil
        buttonCell.delegate = self
       
        
        let phonesCell = connectedPhonesCell()
        phonesCell.rowHeight = 400
        phonesCell.isUserInteractionEnabled = true
        phonesCell.menuAction = nil
        phonesCell.menuTarget = nil
        phonesCell.delegate = self
        
    navigationBarMenu.menuCells = [connectCell, buttonCell, phonesCell]
    
//    if peerIDS.count == 0 {
//
//        let connectCell = dropDownOverrideCell()
//        connectCell.rowHeight = 60
//        connectCell.menuAction = #selector(connect(_:))
//        connectCell.menuTarget = self
//        connectCell.showsCheckmark = false
//        navigationBarMenu.menuCells = [connectCell]
//   // navigationBarMenu.selectMenuCell(dropCell)
//    }
//    else {
//        navigationBarMenu.menuCells = menucells
//        if menucells.count > 0 {
//            print("dude")
//            navigationBarMenu.selectMenuCell(menucells[menucells.count-1])
//        }
    
    
    
    
  
    
    // For a simple gray overlay in background
    navigationBarMenu.layer.zPosition = 1
    view.bringSubview(toFront: navigationBarMenu)
    navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
    navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
    navigationBarMenu.backgroundAlpha = 0.7
}

func prepareToolbarMenu() {
    toolbarMenu = DropDownMenu(frame: view.bounds)
    toolbarMenu.delegate = self
    
    let selectCell = DropDownMenuCell()
    
    selectCell.textLabel!.text = "Change Title Icons"
    selectCell.imageView!.image = UIImage(named: "Ionicons-ios-checkmark-outline")
    selectCell.showsCheckmark = false
    selectCell.menuAction = #selector(DashBoardController.changeTitleIcons as (DashBoardController) -> () -> ())
    selectCell.menuTarget = self
    
    let sortKeys = ["Name", "Date", "Size"]
    let sortCell = DropDownMenuCell()
    let sortSwitcher = UISegmentedControl(items: sortKeys)
    
    sortSwitcher.selectedSegmentIndex = sortKeys.index(of: "Name")!
    sortSwitcher.addTarget(self, action: #selector(DashBoardController.sort(_:)), for: .valueChanged)
    
    sortCell.customView = sortSwitcher
    sortCell.textLabel!.text = "Sort"
    sortCell.imageView!.image = UIImage(named: "Ionicons-ios-search")
    sortCell.showsCheckmark = false
    
    toolbarMenu.menuCells = [selectCell, sortCell]
    toolbarMenu.direction = .up
    
    // For a simple gray overlay in background
    toolbarMenu.backgroundView = UIView(frame: toolbarMenu.bounds)
    toolbarMenu.backgroundView!.backgroundColor = UIColor.black
    toolbarMenu.backgroundAlpha = 0.7
}

// MARK: - Layout

func updateMenuContentInsets() {
    var visibleContentInsets: UIEdgeInsets
    
    if #available(iOS 11, *) {
        visibleContentInsets = view.safeAreaInsets
    } else {
        visibleContentInsets =
            UIEdgeInsets(top: navigationController!.navigationBar.frame.size.height + statusBarHeight(),
                         left: 0,
                         bottom: navigationController!.toolbar.frame.size.height,
                         right: 0)
    }
    
    navigationBarMenu.visibleContentInsets = visibleContentInsets
    toolbarMenu.visibleContentInsets = visibleContentInsets
}

override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    coordinator.animate(alongsideTransition: { _ in
        // If we put this only in -viewDidLayoutSubviews, menu animation is
        // messed up when selecting an item
        self.updateMenuContentInsets()
    }, completion: nil)
}

// MARK: - Updating UI

func validateBarItems() {
    navigationItem.leftBarButtonItem?.isEnabled = titleView.isUp && !navigationBarMenu.menuCells.isEmpty
    navigationItem.rightBarButtonItem?.isEnabled = titleView.isUp
}

// MARK: - Actions

@IBAction func choose(_ sender: AnyObject) {
    titleView.title = (sender as! DropDownMenuCell).textLabel!.text
}

@IBAction func removeNavigationBarMenuCell() {
    navigationBarMenu.menuCells = Array(navigationBarMenu.menuCells.dropLast())
    validateBarItems()
}

@IBAction func addNavigationBarMenuCell() {
    let cell = DropDownMenuCell()
    
    cell.textLabel!.text = String(navigationBarMenu.menuCells.count)
    cell.menuAction = #selector(DashBoardController.choose(_:))
    cell.menuTarget = self
    
    navigationBarMenu.menuCells += [cell]
    validateBarItems()
}

@IBAction func changeTitleIcons() {
    titleView.iconSize = CGSize(width: 24, height: 24)
    titleView.menuDownImageView.image = UIImage(named: "Ionicons-ios-checkmark-outline")
    titleView.menuDownImageView.transform = CGAffineTransform.identity
    titleView.menuDownImageView.tintColor = UIColor.green
    titleView.menuUpImageView.image = UIImage(named: "Ionicons-ios-search")
}

@IBAction func sort(_ sender: AnyObject) {
    print("Sent sort action")
}

@IBAction func showToolbarMenu() {
    if titleView.isUp {
        titleView.toggleMenu()
    }
    toolbarMenu.show()
}

@IBAction func willToggleNavigationBarMenu(_ sender: DropDownTitleView) {
    toolbarMenu.hide()
    
    if sender.isUp {
        navigationBarMenu.hide()
    } else {
        navigationBarMenu.show()
    }
}

@IBAction func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
    print("hello")
    print("Sent did toggle navigation bar menu action")
    validateBarItems()
}

func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
    if menu == navigationBarMenu {
        titleView.toggleMenu()
    } else {
        menu.hide()
    }
}

}
func statusBarHeight() -> CGFloat {
    let statusBarSize = UIApplication.shared.statusBarFrame.size
    return min(statusBarSize.width, statusBarSize.height)
}
