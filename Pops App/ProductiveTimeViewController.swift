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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(totalTime)
        totalTime.translatesAutoresizingMaskIntoConstraints = false
        totalTime.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalTime.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        let backButton = UIButton(frame: frame)
        backButton.backgroundColor = UIColor.red
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
