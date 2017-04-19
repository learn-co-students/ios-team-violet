//
//  BabaBreakViewNew.swift
//  Pops App
//
//  Created by Robert Rozenvasser on 4/19/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

class BabaBreakViewNew: UIView, UITableViewDataSource, UITableViewDelegate  {
    
    lazy var viewWidth: CGFloat = UIScreen.main.bounds.width //375
    lazy var viewHeight: CGFloat = UIScreen.main.bounds.height  //667
    
    let tableView = UITableView()
    let coachWindowView = UIView()
    let mainLabel = UILabel()
    
    let coachIcon = UIImageView()
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    init(){
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        setupCoachWindow()
        setupCoachIcon()
        setupMainLabel()
        setupTableView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babaCell", for: indexPath) as! BabaEntertainmentCell
        cell.titleLabel.text = "Insomnia Cookies"
        cell.addressLabel.text = "670 WALL ST., NEW YORK, NY"
        cell.distanceLabel.text = "0.2 miles away"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108.0
    }
    
}

extension BabaBreakViewNew {
    
    func setupCoachWindow() {
        self.addSubview(coachWindowView)
        coachWindowView.translatesAutoresizingMaskIntoConstraints = false
        coachWindowView.backgroundColor = Palette.salmon.color
        coachWindowView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        coachWindowView.topAnchor.constraint(equalTo: self.topAnchor, constant: viewHeight * (90/667)).isActive = true
        coachWindowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.layer.cornerRadius = 50.0
        coachWindowView.layer.masksToBounds = true
    }
    
    func setupCoachIcon() {
        coachIcon.image = #imageLiteral(resourceName: "IC_BABA")
        coachIcon.contentMode = .scaleAspectFill
        
        coachWindowView.addSubview(coachIcon)
        coachIcon.translatesAutoresizingMaskIntoConstraints = false
        
        coachBottomAnchorConstraint = coachIcon.bottomAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 10)
        coachBottomAnchorConstraint.isActive = true
        coachIcon.centerXAnchor.constraint(equalTo: coachWindowView.centerXAnchor).isActive = true
    }
    
    func setupMainLabel() {
        self.addSubview(mainLabel)
        mainLabel.font = UIFont(name: "Avenir-Black", size: 14)
        mainLabel.textColor = UIColor.black
        mainLabel.text = "Baba's Local Guide"
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 15).isActive = true
    }

    func setupTableView() {
        tableView.register(BabaEntertainmentCell.self, forCellReuseIdentifier: "babaCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        tableView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 50).isActive = true
    }
    
}
