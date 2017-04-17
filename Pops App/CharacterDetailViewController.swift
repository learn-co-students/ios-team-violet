//
//  CharacterDetailViewController.swift
//  Pops App
//
//  Created by Robert Rozenvasser on 4/17/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    lazy var viewWidth: CGFloat = self.view.frame.width  //375
    lazy var viewHeight: CGFloat = self.view.frame.height  //667
    
    let characterView = UIView()
    var viewModel = SettingsViewModel()
    
    let headerView = UIView()
    let characterNameLabel = UILabel()
    
    let selectButton = UIButton()
    let lineDividerView = UIView()
    let characterBio = UILabel()
    let difficultySetting = UILabel()
    
    var usersCurrentCoach: String = ""
    
    var coach: CoachProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        usersCurrentCoach = viewModel.dataStore.user.currentCoach.name
        
        if let coach = coach {
            characterBio.text = coach.bio
            difficultySetting.text = coach.difficulty
            characterNameLabel.text = coach.name.uppercased()
        }
        
        setupHeaderView()
        setupCharacterView()
        setupCharacterNameLabel()

        setupStartButton()
        setupLineDividerView()
        setupCharacterBio()
        setupDifficultyLabel()
    }
    

    func setupHeaderView() {
        headerView.backgroundColor = Palette.darkHeader.color
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (230/667)).isActive = true
    }
    
    func setupCharacterView() {
        headerView.addSubview(characterView)
        characterView.translatesAutoresizingMaskIntoConstraints = false
        characterView.backgroundColor = Palette.salmon.color
        characterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        characterView.topAnchor.constraint(equalTo: headerView.topAnchor, constant:viewHeight * (56/667)).isActive = true
        characterView.heightAnchor.constraint(equalToConstant: viewWidth * (100/375)).isActive = true
        characterView.widthAnchor.constraint(equalToConstant: viewWidth * (100/375)).isActive = true
        characterView.layer.cornerRadius = (viewWidth * (50/375))
        characterView.layer.masksToBounds = true
    }
    
    func setupCharacterNameLabel() {
        characterNameLabel.textColor = UIColor.white
        characterNameLabel.textAlignment = .center
        characterNameLabel.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        headerView.addSubview(characterNameLabel)
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        characterNameLabel.topAnchor.constraint(equalTo: characterView.bottomAnchor, constant: viewHeight * (15/viewHeight)).isActive = true
        characterNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        characterNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setupStartButton() {
        selectButton.backgroundColor = Palette.lightBlue.color
     
        selectButton.layer.cornerRadius = 2.0
        selectButton.layer.masksToBounds = true
        
        if usersCurrentCoach == coach?.name {
            selectButton.setTitle("currently selected", for: .normal)
            selectButton.alpha = 0.3
            selectButton.isEnabled = false
        } else {
            selectButton.setTitle("select", for: .normal)
            selectButton.alpha = 1.0
            selectButton.isEnabled = true
            selectButton.addTarget(self, action: #selector(didSelectCharacter), for: .touchUpInside)
        }
        
        selectButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        view.addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        selectButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: startButtonBottomConstraint()).isActive = true
    }
    
    func didSelectCharacter() {
        let coachName = coach?.name
        viewModel.dataStore.defaults.set(coachName, forKey: "coachName")
        viewModel.dataStore.user.currentCoach = viewModel.dataStore.getCurrentCoach()
        selectButton.backgroundColor = Palette.darkHeader.color
        selectButton.setTitle("selected", for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        view.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineDividerView.bottomAnchor.constraint(equalTo: selectButton.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
    
    func setupCharacterBio() {
        characterBio.lineBreakMode = NSLineBreakMode.byWordWrapping
        characterBio.numberOfLines = 0
        characterBio.textColor = Palette.grey.color
        characterBio.textAlignment = .left
        characterBio.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        view.addSubview(characterBio)
        characterBio.translatesAutoresizingMaskIntoConstraints = false
        characterBio.bottomAnchor.constraint(equalTo: lineDividerView.topAnchor, constant: -viewHeight * (20/viewHeight)).isActive = true
        characterBio.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
        characterBio.trailingAnchor.constraint(equalTo: lineDividerView.trailingAnchor).isActive = true
    }
    
    func setupDifficultyLabel() {
        difficultySetting.numberOfLines = 0
        difficultySetting.textColor = UIColor.black
        difficultySetting.textAlignment = .left
        difficultySetting.font = UIFont(name: "Avenir-Black", size: 14.0)
        
        view.addSubview(difficultySetting)
        difficultySetting.translatesAutoresizingMaskIntoConstraints = false
        difficultySetting.bottomAnchor.constraint(equalTo: characterBio.topAnchor, constant: -viewHeight * (5/viewHeight)).isActive = true
        difficultySetting.leadingAnchor.constraint(equalTo: characterBio.leadingAnchor).isActive = true
        difficultySetting.trailingAnchor.constraint(equalTo: characterBio.trailingAnchor).isActive = true
    }


}
