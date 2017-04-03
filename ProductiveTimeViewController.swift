//
//  ProductiveTimeViewController.swift
//  PopsSetSession
//
//  Created by Robert Rozenvasser on 4/3/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class ProductiveTimeViewController: UIViewController {

    let totalTime = UILabel()
    let productiveTime = UILabel()
    
    var time: String! {
        didSet {
            totalTime.text = time
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(totalTime)
        totalTime.translatesAutoresizingMaskIntoConstraints = false
        totalTime.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalTime.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }


}
