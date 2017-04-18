
import UIKit
import UserNotifications

class SetSessionViewController: UIViewController {
    
    let viewModel = SetSessionViewModel()
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    //Selected time for collection view
    var selectedTime: Time!
    var selectedIndexPath: IndexPath?
    
    //Helper properties
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    lazy var itemWidth: CGFloat = self.view.frame.width * (269/self.view.frame.width)
    lazy var itemHeight: CGFloat = self.view.frame.height * (45/self.view.frame.height)
    lazy var collectionViewYAnchor: CGFloat = self.view.frame.height * (403/self.view.frame.height)
    
    //General view properties
    let startButton = UIButton()
    let selectHourCollectionViewLayout = UICollectionViewFlowLayout()
    lazy var selectHourCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.selectHourCollectionViewLayout)
    let lineDividerView = UIView()
    let characterMessageBody = UILabel()
    let characterMessageHeader = UILabel()
    let coachWindowView = UIView()
    let coachIcon = UIImageView()
    let headerView = UIView()
    let settingsButton = UIButton()
    let leaderBoardButton = UIButton()
    let contentView = UIView()
    
    let coachTap = UITapGestureRecognizer()
    
    //Needed to animate pops
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    //First Onboarding Animation
    var collectionViewLeadingAnchor: NSLayoutConstraint!
    var startButtonCenterXAnchor: NSLayoutConstraint!
    var allowNotificationButtonsStackViewTopAnchor: NSLayoutConstraint!
    
    //Second Onboarding Animation
    var allowNotificationButtonsStackViewXAnchor: NSLayoutConstraint!
    var readyButtonsStackViewTopAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            settingsButton.alpha = 0
        }
        
        //no leaderboard yet
        leaderBoardButton.alpha = 0
        
        view.backgroundColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupStartButton()
        setupCollectionViewLayout()
        setupCollectionView()
        setupLineDividerView()
        setupCharacterMessageBody()
        setupCharacterMessageHeader()
        setupCoachWindow()
        setupCoachIcon()
        setupHeaderView()
        setupSettingsButton()
        setupLeaderBoardButton()
        setupGestureRecognizer()
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            setupAllowNotificationButtons()
            setupReadyButtons()
        }

        animateCoachPopup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let visibleCells = selectHourCollectionView.visibleCells as! [HourCollectionViewCell]
        visibleCells.forEach { $0.deselectCell() }
        if let selectedIndexPath = selectedIndexPath {
            selectHourCollectionView.deselectItem(at: selectedIndexPath, animated: false)
        }
    }
    
    func startButtonTapped()    {
        presentProductiveTimeVC()
        if let indexPath = selectHourCollectionView.indexPathsForSelectedItems?[0] {
            viewModel.startSessionOfLength((indexPath.row) + 1)
        }
    }
    
    func presentProductiveTimeVC() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
            
        }) { _ in
            let productiveTimeVC = ProductiveTimeViewController()
            self.present(productiveTimeVC, animated: true, completion: nil )
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension SetSessionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.timesForCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourTimeCell", for: indexPath) as! HourCollectionViewCell
        
        if cell.layer.cornerRadius != 2.0 {
            cell.layer.cornerRadius = 2.0
            cell.layer.masksToBounds = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewWidth * (10/viewWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentCell = cell as! HourCollectionViewCell
        currentCell.time = viewModel.timesForCollectionView[indexPath.row]
        
        if currentCell.isSelected == false {
            currentCell.deselectCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! HourCollectionViewCell
        
        guard !cell.timeIsSelected else { return }
        
        selectedTime?.isSelected = false
        let visibleCells = collectionView.visibleCells as! [HourCollectionViewCell]
        visibleCells.forEach { $0.deselectCell() }

        selectedTime = cell.time
        selectedIndexPath = indexPath
        
        cell.timeIsSelected = !cell.timeIsSelected
        UIView.animate(withDuration: 0.3, animations: {
            self.startButton.alpha = cell.timeIsSelected ? 1.0 : 0.3
            self.startButton.isEnabled = cell.timeIsSelected ? true : false
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.characterMessageBody.alpha = 0
            self.characterMessageHeader.alpha = 0
            
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.characterMessageHeader.text = self.viewModel.dataStore.user.currentCoach.setSessionStatements[indexPath.row][0].header
                self.characterMessageBody.text = self.viewModel.dataStore.user.currentCoach.setSessionStatements[indexPath.row][0].body
                self.characterMessageBody.alpha = 1
                self.characterMessageHeader.alpha = 1
            }, completion: nil)
            
        }
    }
}

//View Setups
extension SetSessionViewController {
    
    func setupStartButton() {
        startButton.backgroundColor = Palette.aqua.color
       
        startButton.alpha = 0.3
        startButton.isEnabled = false
        
        startButton.layer.cornerRadius = 2.0
        startButton.layer.masksToBounds = true
        startButton.setTitle("start", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            startButton.addTarget(self, action: #selector(animateAllowNotifications), for: .touchUpInside)
        } else {
           startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        }
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButtonCenterXAnchor = startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        startButtonCenterXAnchor.isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: startButtonBottomConstraint()).isActive = true
    }
    
    
    func setupCollectionViewLayout() {
        let leftInset = collectionViewLeftInset()
        let itemWidth = viewWidth * (83/viewWidth)
        let itemHeight = viewHeight * (45/viewHeight)
        selectHourCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: leftInset)
        selectHourCollectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        selectHourCollectionViewLayout.scrollDirection = .horizontal
    }
    
    func setupCollectionView() {
        selectHourCollectionView.backgroundColor = UIColor.white
        selectHourCollectionView.allowsMultipleSelection = false
        selectHourCollectionView.showsHorizontalScrollIndicator = false
        selectHourCollectionView.delegate = self
        selectHourCollectionView.dataSource = self
        selectHourCollectionView.register(HourCollectionViewCell.self, forCellWithReuseIdentifier: "HourTimeCell")
        
        view.addSubview(selectHourCollectionView)
        selectHourCollectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewLeadingAnchor = selectHourCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        collectionViewLeadingAnchor.isActive = true
        selectHourCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectHourCollectionView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        selectHourCollectionView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
    }
    
    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        view.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineDividerView.bottomAnchor.constraint(equalTo: selectHourCollectionView.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
    
    func setupCharacterMessageBody() {
        characterMessageBody.lineBreakMode = NSLineBreakMode.byWordWrapping
        characterMessageBody.numberOfLines = 0
        characterMessageBody.textColor = Palette.grey.color
        characterMessageBody.textAlignment = .left
        characterMessageBody.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            characterMessageBody.text = "I'll make sure you are super productive today. How long would you like to stay productive for?"
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageBody.text = viewModel.dataStore.user.currentCoach.introStatements[randomIndex].body
        }
        
        view.addSubview(characterMessageBody)
        characterMessageBody.translatesAutoresizingMaskIntoConstraints = false
        characterMessageBody.bottomAnchor.constraint(equalTo: lineDividerView.topAnchor, constant: -viewHeight * (20/viewHeight)).isActive = true
        characterMessageBody.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
        characterMessageBody.trailingAnchor.constraint(equalTo: lineDividerView.trailingAnchor).isActive = true
    }
    
    func setupCharacterMessageHeader() {
        characterMessageHeader.numberOfLines = 0
        characterMessageHeader.textColor = UIColor.black
        characterMessageHeader.textAlignment = .left
        characterMessageHeader.font = UIFont(name: "Avenir-Black", size: 14.0)
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            characterMessageHeader.text = "Hey there, I'm Pops!"
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageHeader.text = viewModel.dataStore.user.currentCoach.introStatements[randomIndex].header
        }
    
        view.addSubview(characterMessageHeader)
        characterMessageHeader.translatesAutoresizingMaskIntoConstraints = false
        characterMessageHeader.bottomAnchor.constraint(equalTo: characterMessageBody.topAnchor, constant: -viewHeight * (5/viewHeight)).isActive = true
        characterMessageHeader.leadingAnchor.constraint(equalTo: characterMessageBody.leadingAnchor).isActive = true
        characterMessageHeader.trailingAnchor.constraint(equalTo: characterMessageBody.trailingAnchor).isActive = true
    }
    
    func setupCoachWindow() {
        view.addSubview(coachWindowView)
        coachWindowView.translatesAutoresizingMaskIntoConstraints = false
        coachWindowView.backgroundColor = Palette.salmon.color
        coachWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coachWindowView.bottomAnchor.constraint(equalTo: characterMessageHeader.topAnchor, constant: -viewHeight * (40/667)).isActive = true
        coachWindowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.layer.cornerRadius = 50.0
        coachWindowView.layer.masksToBounds = true
    }
    
    func setupCoachIcon() {
        coachIcon.image = viewModel.dataStore.user.currentCoach.icon
        coachIcon.contentMode = .scaleAspectFill
    
        coachWindowView.addSubview(coachIcon)
        coachIcon.translatesAutoresizingMaskIntoConstraints = false
        
        coachBottomAnchorConstraint = coachIcon.bottomAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 100)
        coachBottomAnchorConstraint.isActive = true
        coachIcon.centerXAnchor.constraint(equalTo: coachWindowView.centerXAnchor, constant: 0).isActive = true
    }

    func setupHeaderView() {
        headerView.backgroundColor = Palette.salmon.color
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (5/viewHeight)).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func setupSettingsButton() {
        settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Settings-1"), for: .normal)
        
        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0).isActive = true
        settingsButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 21.0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 21.0).isActive = true
        settingsButton.addTarget(self, action: #selector(presentHomeSettingsVC), for: .touchUpInside)
    }
    
    func presentHomeSettingsVC() {
    
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
            
        })

        let homeSettingsVC = HomeSettingsViewController()
        self.present(homeSettingsVC, animated: true, completion: nil)
    }

    func setupLeaderBoardButton() {
        leaderBoardButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Leaderboard"), for: .normal)
        
        headerView.addSubview(leaderBoardButton)
        leaderBoardButton.translatesAutoresizingMaskIntoConstraints = false
        leaderBoardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.0).isActive = true
        leaderBoardButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 21.0).isActive = true
        leaderBoardButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        leaderBoardButton.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
    }
    
    func setupGestureRecognizer() {
        coachIcon.addGestureRecognizer(coachTap)
        coachIcon.isUserInteractionEnabled = true
        coachTap.numberOfTapsRequired = 1
        coachTap.addTarget(self, action: #selector(coachTapped))
    }
    
    func coachTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.characterMessageBody.alpha = 0
            self.characterMessageHeader.alpha = 0
            
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.characterMessageHeader.text = self.viewModel.dataStore.user.currentCoach.tapStatements[0].header
                self.characterMessageBody.text = self.viewModel.dataStore.user.currentCoach.tapStatements[0].body
                self.characterMessageBody.alpha = 1
                self.characterMessageHeader.alpha = 1
            }, completion: nil)
            
        }
    }
    
    func animateCoachPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.coachBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
    
}

//Onboarding Setups and Animations
extension SetSessionViewController {
    
    func setupAllowNotificationButtons() {
        let allowNotificationsButton = UIButton()
        allowNotificationsButton.tag = 1
        allowNotificationsButton.backgroundColor = Palette.aqua.color
        allowNotificationsButton.layer.cornerRadius = 2.0
        allowNotificationsButton.layer.masksToBounds = true
        allowNotificationsButton.setTitle("notify me", for: .normal)
        allowNotificationsButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        allowNotificationsButton.addTarget(self, action: #selector(notifyMeButtonPressed), for: .touchUpInside)
        
        let disallowNotificationsButton = UIButton()
        disallowNotificationsButton.tag = 2
        disallowNotificationsButton.backgroundColor = Palette.lightGrey.color
        disallowNotificationsButton.layer.cornerRadius = 2.0
        disallowNotificationsButton.layer.masksToBounds = true
        disallowNotificationsButton.setTitle("mute pops", for: .normal)
        disallowNotificationsButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        disallowNotificationsButton.setTitleColor(Palette.darkText.color, for: .normal)
        disallowNotificationsButton.addTarget(self, action: #selector(notifyMeButtonPressed), for: .touchUpInside)
        
        let buttons = [allowNotificationsButton, disallowNotificationsButton]
        
        buttons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: viewHeight * (45/viewHeight)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: viewWidth * (269/viewWidth)).isActive = true
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 18
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        allowNotificationButtonsStackViewXAnchor = stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        allowNotificationButtonsStackViewXAnchor.isActive = true
        allowNotificationButtonsStackViewTopAnchor = stackView.topAnchor.constraint(equalTo: view.bottomAnchor)
        allowNotificationButtonsStackViewTopAnchor.isActive = true
    }
    
    func setupReadyButtons() {
        
        let readyButton = UIButton()
        readyButton.backgroundColor = Palette.aqua.color
        readyButton.layer.cornerRadius = 2.0
        readyButton.layer.masksToBounds = true
        readyButton.setTitle("ready", for: .normal)
        readyButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        readyButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let notReadyButton = UIButton()
        notReadyButton.backgroundColor = Palette.lightGrey.color
        notReadyButton.layer.cornerRadius = 2.0
        notReadyButton.layer.masksToBounds = true
        notReadyButton.setTitle("not ready yet", for: .normal)
        notReadyButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        notReadyButton.setTitleColor(Palette.darkText.color, for: .normal)
        notReadyButton.addTarget(self, action: #selector(animateBackToSetSession), for: .touchUpInside)
        
        let buttons = [readyButton, notReadyButton]
        
        buttons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: viewHeight * (45/viewHeight)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: viewWidth * (269/viewWidth)).isActive = true
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 18
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        readyButtonsStackViewTopAnchor = stackView.topAnchor.constraint(equalTo: view.bottomAnchor)
        readyButtonsStackViewTopAnchor.isActive = true
    }
    
    func animateAllowNotifications() {
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.8, animations: {
            self.startButtonCenterXAnchor.constant += self.viewWidth
            self.collectionViewLeadingAnchor.constant += self.viewWidth
            self.characterMessageBody.alpha = 0
            self.characterMessageHeader.alpha = 0
            self.settingsButton.alpha = 0
            self.leaderBoardButton.alpha = 0
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
                self.characterMessageBody.text = "It’s simple. You’ll focus on work that doesn’t require your phone for blocks of 25 minutes. In between each block, I’ll notify you to take a 5 minute break."
                self.characterMessageHeader.text = "Wondering how this will work?"
                self.characterMessageBody.alpha = 1
                self.characterMessageHeader.alpha = 1
                self.allowNotificationButtonsStackViewTopAnchor.constant -= self.stackViewContraint()
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
   
    func animateBackToSetSession() {
        
        UIView.animate(withDuration: 0.8, animations: {
            self.readyButtonsStackViewTopAnchor.constant += self.stackViewContraint()
            self.characterMessageBody.alpha = 0
            self.characterMessageHeader.alpha = 0
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: { 
                self.characterMessageBody.text = "Just press start back whenever you are ready to start being productive."
                self.characterMessageHeader.text = "No worries!"
                self.characterMessageBody.alpha = 1
                self.characterMessageHeader.alpha = 1
                self.settingsButton.alpha = 1
                self.setupStartButton()
                self.setupCollectionViewLayout()
                self.setupCollectionView()
                self.view.layoutIfNeeded()
            }, completion: { _ in
                let visibleCells = self.selectHourCollectionView.visibleCells as! [HourCollectionViewCell]
                visibleCells.forEach { $0.deselectCell() }
                self.selectHourCollectionView.deselectItem(at: self.selectedIndexPath!, animated: false)
            })
            
        }

    }
    
    func notifyMeButtonPressed(_ sender: UIButton) {
    
            print("pressed notify me")
            
            self.center.requestAuthorization(options: options) { (granted, error) in
                
                DispatchQueue.main.async {
                    if granted {
                        self.animateReadyButtons()
                    } else {
                        self.animateReadyButtons()
                        //what happens if user doesn't allow notifications
                    }
                }
                
            }

    }
    
    func animateReadyButtons() {
        
        UIView.animate(withDuration: 1, animations: {
            self.allowNotificationButtonsStackViewXAnchor.constant += self.viewWidth
            self.characterMessageBody.alpha = 0
            self.characterMessageHeader.alpha = 0
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
                self.characterMessageBody.text = "As long as you don’t touch your phone when you shouldn’t, I’ll give you props! Your goal is to collect as many of my props as possible."
                self.characterMessageHeader.text = "Ready to be super productive?"
                self.characterMessageBody.alpha = 1
                self.characterMessageHeader.alpha = 1
                self.readyButtonsStackViewTopAnchor.constant -= self.stackViewContraint()
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
        
    }

}

//Device Specific Constraints
extension UIViewController {
    
    func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    
    func startButtonBottomConstraint() -> CGFloat {
        switch(self.screenHeight()) {
        case 568:
            return -100
        case 667:
            return -149
        default:
            return -149
        }
    }
    
    func stackViewContraint() -> CGFloat {
        switch(self.screenHeight()) {
        case 568:
            return 210
        case 667:
            return 260
        default:
            return 260
        }
    }
    
    func collectionViewLeftInset() -> CGFloat {
        switch(self.screenHeight()) {
        case 568:
            return 26
        case 667:
            return 53
        default:
            return 72
        }
    }
}


