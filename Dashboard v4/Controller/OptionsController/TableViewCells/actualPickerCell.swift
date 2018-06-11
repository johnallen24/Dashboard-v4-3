//
//  actualPickerCell.swift
//  Dashboard 2
//
//  Created by John Allen on 5/17/18.
//  Copyright © 2018 jallen.studios. All rights reserved.
//


import UIKit

protocol PickerCellDelegate {
    func pickerChanged(cell: actualPickerCell)
}


class actualPickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    enum actualPickerCellType {
        case graph
        case color
    }
    
    var type: actualPickerCellType?
    
    var delegate: PickerCellDelegate?
    
    let pickerView: UIPickerView = {
    let view = UIPickerView()
        //view.backgroundColor = UIColor.orange
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    
    let colorView1: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "hello"))
        view.addSubview(imageView)
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let colorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let colorView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let colorView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var colorViews: [UIView] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.type == .color {
            return 4
        }
        return 6
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "hey"
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("mo")
        delegate?.pickerChanged(cell: self)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 400
//    }
//
    var pickerWidth = 400
    var pickerHeight = 100
    var colorNames = ["Blue", "Orange", "Pink", "Purple"]
    var colorImages = [UIImage(named: "blue"),UIImage(named: "orange"),UIImage(named: "pink"),UIImage(named: "purple")]
    var graphTypeNames = ["Cublic Line with Area", "Cublic Line", "Linear Line with Area", "Linear Line" ,"Bar Chart", "Step Chart"]
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if type == .color {
        let cview = UIView(frame: pickerView.frame)
        let label = UILabel()
        cview.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cview.topAnchor, constant: 0),
            label.widthAnchor.constraint(equalTo: cview.widthAnchor, multiplier: 0.2),
            label.leadingAnchor.constraint(equalTo: cview.leadingAnchor, constant: 300),
            label.bottomAnchor.constraint(equalTo: cview.bottomAnchor, constant: 0)
            ])
        
        label.font = UIFont(name: "AppleSDGothicNeo-Bold " , size: 24)
        label.text = colorNames[row]
        let imageView = UIImageView()
        cview.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = colorImages[row]
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cview.topAnchor, constant: 55),
            imageView.widthAnchor.constraint(equalTo: cview.widthAnchor, multiplier: 0.05),
            imageView.heightAnchor.constraint(equalTo: cview.heightAnchor, multiplier: 0.25),
            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 100)
            ])
        return cview
    }
    
        else if type == .graph {
        let cview = UIView(frame: pickerView.frame)
        let label = UILabel()
        cview.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cview.topAnchor, constant: 0),
            label.widthAnchor.constraint(equalTo: cview.widthAnchor, multiplier: 0.4),
            label.centerXAnchor.constraint(equalTo: cview.centerXAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: cview.bottomAnchor, constant: 0)
            ])
        
        label.font = UIFont(name: "AppleSDGothicNeo-Bold " , size: 24)
        label.text = graphTypeNames[row]
        return cview
    }
        else {
            print("errror")
            return UIView()
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        return UIImageView(image: UIImage(named: "hello"))
//    }
    
    override func prepareForReuse() {
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
    }
        
        

    
    
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        colorViews = [colorView1, colorView2, colorView3, colorView4]
        
        self.selectionStyle = .none
        contentView.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            pickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            pickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            pickerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
