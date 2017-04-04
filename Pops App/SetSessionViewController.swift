//
//  ViewController.swift
//  PopsSetSession
//
//  Created by Robert Rozenvasser on 4/3/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class SetSessionViewController: UIViewController {
    
    //Data sources for picker view
    let totalTimesForPicker = ["next hour", "next 2 hours", "next 3 hours"]
    let productiveTimesForPicker = ["every 30 min", "every 40 min", "every 50 min"]
    
    //Used to determine which picker data source to display
    var totalTimeButtonSelected = false
    var productiveButtonSelected = false
    
    //Used to adjust height of views when picker view appears
    var buttonPressedCounter = 1
    var startButtonBottomConstraint: NSLayoutConstraint!
    var headerViewTopConstraint: NSLayoutConstraint!
    
    let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = Palette.darkHeader.color
        return headerView
    }()
    
    let popsIconImageView: UIImageView = {
        let popsImageView = UIImageView()
        popsImageView.image = UIImage(named: "IC_POPS")
        popsImageView.contentMode = .scaleAspectFit
        return popsImageView
    }()
    
    let settingsButton: UIButton = {
        let settingsButton = UIButton()
        settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Settings"), for: .normal)
        return settingsButton
    }()
    
    let popsProudLabel: UILabel = {
        let popsProudLabel = UILabel()
        popsProudLabel.numberOfLines = 2
        popsProudLabel.textColor = UIColor.black
        let labelString = "I want to make\nPOPS PROUD for the"
        let normalFont = UIFont(name: "Avenir-Medium", size: 19.0)
        let boldFont = UIFont(name: "Avenir-Black", size: 19.0)
        popsProudLabel.attributedText = labelString.addBoldText(fullString: "I want to make\nPOPS PROUD for the", boldPartsOfString: ["POPS PROUD"], font: normalFont, boldFont: boldFont)
        return popsProudLabel
    }()
    
    let takeBreakLabel: UILabel = {
        let takeBreakLabel = UILabel()
        takeBreakLabel.numberOfLines = 2
        takeBreakLabel.textColor = UIColor.black
        let labelString = "Pops will understand if I\nTAKE A BREAK"
        let normalFont = UIFont(name: "Avenir-Medium", size: 19.0)
        let boldFont = UIFont(name: "Avenir-Black", size: 19.0)
        takeBreakLabel.attributedText = labelString.addBoldText(fullString: "Pops will understand if I\nTAKE A BREAK", boldPartsOfString: ["TAKE A BREAK"], font: normalFont, boldFont: boldFont)
        return takeBreakLabel
    }()
    
    lazy var totalTimeEntryButton: UIView = {
        let totalTimeEntryButton = UIView()
        totalTimeEntryButton.backgroundColor = Palette.lightGrey.color
        totalTimeEntryButton.layer.cornerRadius = 2.0
        totalTimeEntryButton.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didPressTotalTimeEntry))
        totalTimeEntryButton.addGestureRecognizer(gesture)
        return totalTimeEntryButton
    }()
    
    var totalTimeEntryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 14.0)
        label.textColor = Palette.grey.color
        return label
    }()
    
    lazy var productiveTimeEntryButton: UIView = {
        let productiveTimeEntryButton = UIView()
        productiveTimeEntryButton.backgroundColor = Palette.lightGrey.color
        productiveTimeEntryButton.layer.cornerRadius = 2.0
        productiveTimeEntryButton.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didPressProductiveTimeEntry))
        productiveTimeEntryButton.addGestureRecognizer(gesture)
        return productiveTimeEntryButton
    }()
    
    let productiveTimeEntryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 14.0)
        label.textColor = Palette.grey.color
        label.text = "every 30 minutes"
        return label
    }()
    
    lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.backgroundColor = Palette.aqua.color
        startButton.layer.cornerRadius = 2.0
        startButton.layer.masksToBounds = true
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        startButton.addTarget(self, action: #selector(presentProductiveTimeVC), for: .touchUpInside)
        return startButton
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupStartButton()
        
        setupProductiveTimeEntryButton()
        setupProductiveTimeEntryLabel()
        setupTakeBreakLabel()
        
        setupTotalTimeEntryButton()
        setupTotalTimeEntryLabel()
        setupPopsProudLabel()
        
        setupHeaderView()
        setupPopsImage()
        setupSettingsButton()
        
        setupPickerView()
        pickerView.isHidden = true
        
        totalTimeEntryLabel.text = totalTimesForPicker[0]
        productiveTimeEntryLabel.text = productiveTimesForPicker[0]
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayPickerView), name: Notification.Name("pickerViewWillAppear"), object: nil)
    }
    
    //figure this out
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("pickerViewWillAppear"), object: nil)
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func presentProductiveTimeVC() {
        let procutiveTimeVC = ProductiveTimeViewController()
        procutiveTimeVC.totalTime.text = totalTimeEntryLabel.text
        present(procutiveTimeVC, animated: true, completion: nil)
    }
    
//Setup pops proud entry
    
    func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 185.0).isActive = true
        headerViewTopConstraint = headerView.topAnchor.constraint(equalTo: view.topAnchor)
        headerViewTopConstraint.isActive = true
    }
    
    func setupPopsImage() {
        headerView.addSubview(popsIconImageView)
        popsIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popsIconImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        popsIconImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        popsIconImageView.widthAnchor.constraint(equalToConstant: 52.0).isActive = true
    }
    
    func setupSettingsButton() {
        headerView.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.0).isActive = true
        settingsButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20.0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 21.0).isActive = true
    }
    
    func setupPopsProudLabel() {
        view.addSubview(popsProudLabel)
        popsProudLabel.translatesAutoresizingMaskIntoConstraints = false
        popsProudLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        popsProudLabel.bottomAnchor.constraint(equalTo: totalTimeEntryButton.topAnchor, constant: -15.0).isActive = true
    }
    
    func setupTotalTimeEntryButton() {
        view.addSubview(totalTimeEntryButton)
        totalTimeEntryButton.translatesAutoresizingMaskIntoConstraints = false
        totalTimeEntryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        totalTimeEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        totalTimeEntryButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        totalTimeEntryButton.bottomAnchor.constraint(equalTo: takeBreakLabel.topAnchor, constant: -35.0).isActive = true
    }
    
    func setupTotalTimeEntryLabel() {
        totalTimeEntryButton.addSubview(totalTimeEntryLabel)
        totalTimeEntryLabel.translatesAutoresizingMaskIntoConstraints = false
        totalTimeEntryLabel.leadingAnchor.constraint(equalTo: totalTimeEntryButton.leadingAnchor, constant: 15.0).isActive = true
        totalTimeEntryLabel.centerYAnchor.constraint(equalTo: totalTimeEntryButton.centerYAnchor).isActive = true
    }
    
//Setup break Label 
    
    func setupTakeBreakLabel() {
        view.addSubview(takeBreakLabel)
        takeBreakLabel.translatesAutoresizingMaskIntoConstraints = false
        takeBreakLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        takeBreakLabel.bottomAnchor.constraint(equalTo: productiveTimeEntryButton.topAnchor, constant: -15.0).isActive = true
    }
    
    func setupProductiveTimeEntryLabel() {
        productiveTimeEntryButton.addSubview(productiveTimeEntryLabel)
        productiveTimeEntryLabel.translatesAutoresizingMaskIntoConstraints = false
        productiveTimeEntryLabel.leadingAnchor.constraint(equalTo: productiveTimeEntryButton.leadingAnchor, constant: 15.0).isActive = true
        productiveTimeEntryLabel.centerYAnchor.constraint(equalTo: productiveTimeEntryButton.centerYAnchor).isActive = true
    }
    
    func setupProductiveTimeEntryButton() {
        view.addSubview(productiveTimeEntryButton)
        productiveTimeEntryButton.translatesAutoresizingMaskIntoConstraints = false
        productiveTimeEntryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        productiveTimeEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        productiveTimeEntryButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        productiveTimeEntryButton.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -50.0).isActive = true
    }
    
    func setupStartButton() {
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.startButtonBottomConstraint = startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65.0)
        startButtonBottomConstraint.isActive = true
    }
    
}

extension SetSessionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func didPressTotalTimeEntry() {
        totalTimeButtonSelected = true
        productiveButtonSelected = false
        NotificationCenter.default.post(name: Notification.Name("pickerViewWillAppear"), object: nil)
    }
    
    func didPressProductiveTimeEntry() {
        productiveButtonSelected = true
        totalTimeButtonSelected = false
        NotificationCenter.default.post(name: Notification.Name("pickerViewWillAppear"), object: nil)
    }
    
    func displayPickerView() {
        pickerView.reloadComponent(0)
        pickerView.isHidden = false

        if buttonPressedCounter <= 1 {
            self.startButtonBottomConstraint.constant -= 200.0
            self.headerViewTopConstraint.constant -= 185.0
            buttonPressedCounter += 1
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.hidePickerView))
        self.view.addGestureRecognizer(tap)
    }
    
    func hidePickerView() {
        totalTimeButtonSelected = false
        productiveButtonSelected = false
        pickerView.isHidden = true
        
        if buttonPressedCounter != 1 {
            self.startButtonBottomConstraint.constant += 200.0
            self.headerViewTopConstraint.constant += 185.0
            buttonPressedCounter = 1
        }
    }
    
    func setupPickerView() {
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 220.0).isActive = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if totalTimeButtonSelected { return totalTimesForPicker.count }
        else { return productiveTimesForPicker.count }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if totalTimeButtonSelected {
            return totalTimesForPicker[row]
        } else {
           return productiveTimesForPicker[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if totalTimeButtonSelected {
            totalTimeEntryLabel.text = totalTimesForPicker[row]
        } else {
            productiveTimeEntryLabel.text = productiveTimesForPicker[row]
        }
    }
    
}



