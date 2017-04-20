//
//  BabaEntertainmentCell.swift
//  Pops App
//
//  Created by Robert Rozenvasser on 4/19/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class BabaEntertainmentCell: UITableViewCell {
    
    lazy var viewWidth: CGFloat = UIScreen.main.bounds.width //375
    lazy var viewHeight: CGFloat = UIScreen.main.bounds.height  //667
    
    let lineDividerView = UIView()
    let titleLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    let circleContainerView = UIView()
    let yelpImageView = UIImageView()
    
    var location: Location! {
        didSet {
            loadImage()
            print("\(location.name)")
            titleLabel.text = location.name
            addressLabel.text = location.address
            distanceLabel.text = String(location.distance)
        }
    }
    
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
        setupYelpImageView()
        setupLabelStackView()
    }
    
    func loadImage() {
        
        self.location.loadLocationImage { (didDownloadImage) in
            if didDownloadImage {
                self.yelpImageView.image = self.location.image
            }
        }
        
    }

    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        contentView.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        lineDividerView.widthAnchor.constraint(equalToConstant: viewWidth * (300/375)).isActive = true
        lineDividerView.heightAnchor.constraint(equalToConstant: viewHeight * (3/667)).isActive = true
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
        circleContainerView.heightAnchor.constraint(equalToConstant: viewWidth * (70/375)).isActive = true
        circleContainerView.widthAnchor.constraint(equalToConstant: viewWidth * (70/375)).isActive = true
        circleContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        circleContainerView.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
    }
    
    func setupYelpImageView() {
        circleContainerView.addSubview(yelpImageView)
        yelpImageView.contentMode = .scaleAspectFill
        
        yelpImageView.translatesAutoresizingMaskIntoConstraints = false
        yelpImageView.centerYAnchor.constraint(equalTo: circleContainerView.centerYAnchor).isActive = true
        yelpImageView.centerXAnchor.constraint(equalTo: circleContainerView.centerXAnchor).isActive = true
        yelpImageView.heightAnchor.constraint(equalTo: circleContainerView.heightAnchor).isActive = true
        yelpImageView.widthAnchor.constraint(equalTo: circleContainerView.widthAnchor).isActive = true
    }
    
    func setupLabelStackView() {
        let labels = [titleLabel, addressLabel, distanceLabel]
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = viewWidth * (8/375)
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: viewWidth * (215/375)).isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: circleContainerView.trailingAnchor, constant: viewWidth * (10/375)).isActive = true
    }

}
