//
//  BabaEntertainmentCell.swift
//  Pops App
//
//  Created by Robert Rozenvasser on 4/19/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class BabaEntertainmentCell: UITableViewCell {
    
    let lineDividerView = UIView()
    let titleLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    let circleContainerView = UIView()
    let yelpImageView = UIImageView()
    
  
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupLineDividerView()
        setupTitleLabel()
        setupAddressLabel()
        setupDistanceLabel()
        setupCircleImageViewContainer()
        setupLabelStackView()
    }
    
    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        contentView.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lineDividerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        lineDividerView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        lineDividerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont(name: "Avenir-Black", size: 14)
        titleLabel.textColor = UIColor.black
    }
    
    func setupAddressLabel() {
        contentView.addSubview(addressLabel)
        addressLabel.font = UIFont(name: "Avenir-Medium", size: 13)
        addressLabel.textColor = UIColor.gray
    }
    
    
    func setupDistanceLabel() {
        contentView.addSubview(distanceLabel)
        distanceLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        distanceLabel.textColor = Palette.grey.color
    }
    
    func setupCircleImageViewContainer() {
        circleContainerView.layer.cornerRadius = 35
        circleContainerView.layer.masksToBounds = true
        circleContainerView.backgroundColor = Palette.lightGrey.color
        
        contentView.addSubview(circleContainerView)
        circleContainerView.translatesAutoresizingMaskIntoConstraints = false
        circleContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        circleContainerView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        circleContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        circleContainerView.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
    }
    
    func setupLabelStackView() {
        let labels = [titleLabel, addressLabel, distanceLabel]
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 8.0
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: 215).isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: circleContainerView.trailingAnchor, constant: 10).isActive = true
    }

}
