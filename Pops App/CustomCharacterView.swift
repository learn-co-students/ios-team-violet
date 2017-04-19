//
//  CustomCharacterView.swift
//  Pops App
//
//  Created by Robert Rozenvasser on 4/18/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

class CustomCharacterView: UIView {
    
    lazy var viewWidth: CGFloat = UIScreen.main.bounds.width //375
    lazy var viewHeight: CGFloat = UIScreen.main.bounds.height  //667
    
    let circleBackgroundView = UIView()
    let characterImageView = UIImageView()
    let checkMarkIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage) {
        super.init(frame: CGRect.zero)
        self.characterImageView.image = image
        setupView()
    }
    
    private func setupView() {
        setupCircleBackgroud()
        setupCharacterImage()
        setupCheckMarkIcon()
        backgroundColor = UIColor.clear
    }
    
    func setupCircleBackgroud() {
        circleBackgroundView.backgroundColor = Palette.lightGrey.color
        self.addSubview(circleBackgroundView)
        
        circleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        circleBackgroundView.heightAnchor.constraint(equalToConstant: viewWidth * (86/375)).isActive = true
        circleBackgroundView.widthAnchor.constraint(equalToConstant: viewWidth * (86/375)).isActive = true
        circleBackgroundView.layer.cornerRadius = (viewWidth * (86/375)) / 2
        circleBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circleBackgroundView.layer.masksToBounds = true
    }
    
    func setupCharacterImage() {
        circleBackgroundView.addSubview(characterImageView)
        characterImageView.contentMode = .scaleAspectFill
        
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.widthAnchor.constraint(equalToConstant: viewWidth * (52/375)).isActive = true
        characterImageView.heightAnchor.constraint(equalToConstant: viewHeight * (80/667)).isActive = true
        characterImageView.bottomAnchor.constraint(equalTo: circleBackgroundView.bottomAnchor, constant: 10).isActive = true
        characterImageView.centerXAnchor.constraint(equalTo: circleBackgroundView.centerXAnchor).isActive = true
    }
    
    func setupCheckMarkIcon() {
        checkMarkIcon.image = UIImage(named: "IC_CheckMark")
        checkMarkIcon.alpha = 0
        self.addSubview(checkMarkIcon)
        checkMarkIcon.translatesAutoresizingMaskIntoConstraints = false
        checkMarkIcon.widthAnchor.constraint(equalToConstant: viewWidth * (25/375)).isActive = true
        checkMarkIcon.heightAnchor.constraint(equalToConstant: viewHeight * (25/667)).isActive = true
        checkMarkIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        checkMarkIcon.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    
}
