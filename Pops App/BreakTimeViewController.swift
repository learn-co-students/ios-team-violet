
import UIKit
import UserNotifications

class BreakTimeViewController: UIViewController, BreakTimeViewModelDelegate, BreakTimeViewModelProgressBarDelegate, BreakButtonDelegate {

    var viewModel: BreakTimeViewModel!
    let center = UNUserNotificationCenter.current()
    
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    lazy var itemWidth: CGFloat = self.view.frame.width * (269/self.view.frame.width)
    lazy var itemHeight: CGFloat = self.view.frame.height * (45/self.view.frame.height)
    
    let entertainMeButton = UIButton()
    let lineDividerView = UIView()
    let characterMessageHeader = UILabel()
    let characterMessageBody = UILabel()
    let circleBackgroundForCharacterImageView = UIImageView()
    let userAppsBackgroundView = UIView()
    let settingsButton = UIButton()
    let leaderBoardButton = UIButton()
    let dismissIcon = UIButton()
    
    let contentView = UIView()
    let settingsVC = SettingsViewController()
    
    let progressBar = UIView()
    var progressBarWidthAnchor: NSLayoutConstraint! {
        didSet {
            self.view.layoutIfNeeded()
        }
    }
    
    let coachWindowView = UIView()
    let coachIcon = UIImageView()
    
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        viewModel = BreakTimeViewModel(delegate: self, progressBarDelegate: self)
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        leaderBoardButton.alpha = 0
        
        setupUserAppsBackground()
        setupUserApps()
        setupEntertainMeButton()
        setupLineDividerView()
        setupCharacterMessageBody()
        setupCharacterMessageHeader()
        setupCoachWindow()
        setupCoachIcon()
        setupProgressBar()
        setupSettingsButton()
        setupLeaderBoardButton()
        setupCancelSettingsButton()
        
        self.viewModel.breakTimerDelegate = settingsVC
        settingsVC.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: NSNotification.Name(rawValue: "appEnteredForeground"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.delegate = self
        animateCoachPopup()
        viewModel.dataStore.defaults.set(true, forKey: "returningUser")
    }
    
    func appEnteredForeground() {
        if viewModel.dataStore.user.currentSession != nil {
            viewModel.updateTimers()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.breakIsOn == false {
            viewModel.startTimer()
            breakTimeEndedUserNotificationRequest()
        }
    }
    
    func presentBreakEntertainmentVC() {
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        })      {_ in
            let breakEntertainmentVC = BreakEntertainmentViewController()
            breakEntertainmentVC.breakView = self.viewModel.dataStore.user.currentCoach.breakView
            self.viewModel.delegate = breakEntertainmentVC
            self.present(breakEntertainmentVC, animated: true, completion: nil)
        }
    }
    
    func moveToProductivity() {
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in
            self.present(ProductiveTimeViewController(), animated: true, completion: nil)
        }
    }
    
    func moveToSessionEnded() {
        viewModel.breakTimer.invalidate()
        
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in
            self.present(SessionEndedViewController(), animated: true, completion: nil)
        }
    }
    
    func openMessagesApp() {
        print("opening messages")
        
        let messagesURL =  NSURL(string: "sms:")!
        
        if UIApplication.shared.canOpenURL(messagesURL as URL) {
            UIApplication.shared.open(messagesURL as URL)
        }
    }
    
    func openEmailApp() {
        print("opening email")
        
        let mailURL = NSURL(string: "message://")!
        
        if UIApplication.shared.canOpenURL(mailURL as URL) {
            UIApplication.shared.open(mailURL as URL)
        }
    }
    
    func openFacebookApp() {
        print("opening facebook")
        
        let appURL = URL(string: "facebook://user?username=")!
        let webURL = URL(string: "https://facebook.com")!
        
        let app = UIApplication.shared
        
        if app.canOpenURL(appURL as URL) {
            app.open(appURL as URL)
        } else {
            app.open(webURL as URL)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func endBreakBttnPressed() {
        viewModel.breakIsOn = false
        viewModel.breakTimer.invalidate()
        viewModel.dataStore.user.currentSession?.cyclesRemaining -= 1
        if viewModel.dataStore.user.currentSession!.cyclesRemaining == 0 {
            moveToSessionEnded()
        }
        else {
            moveToProductivity()
        }
    }
    
    func getChadTip() {
        let chadBreakViewModel = ChadBreakViewModel()
        let randomIndex = Int(arc4random_uniform(UInt32(chadBreakViewModel.chadBreakTasks.count)))
        
        UIView.animate(withDuration: 0.3, animations: {
            self.characterMessageBody.alpha = 0
            self.characterMessageHeader.alpha = 0
            
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.characterMessageHeader.text = chadBreakViewModel.chadBreakTasks[randomIndex].header
                self.characterMessageBody.text = chadBreakViewModel.chadBreakTasks[randomIndex].body
                self.characterMessageBody.alpha = 1
                self.characterMessageHeader.alpha = 1
            }, completion: nil)
        }
    }
}

extension BreakTimeViewController {
    func setupProgressBar() {
        view.addSubview(progressBar)
        progressBar.backgroundColor = Palette.salmon.color
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        progressBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        progressBarWidthAnchor = progressBar.widthAnchor.constraint(equalToConstant: 0.0)
        progressBarWidthAnchor.isActive = true
    }
    
    func setupEntertainMeButton() {
        entertainMeButton.backgroundColor = Palette.lightBlue.color
        entertainMeButton.layer.cornerRadius = 2.0
        entertainMeButton.layer.masksToBounds = true
        entertainMeButton.setTitle(viewModel.dataStore.user.currentCoach.breakButtonText, for: .normal)
        entertainMeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        if viewModel.dataStore.user.currentCoach.name == "Chad" {
            entertainMeButton.addTarget(self, action: #selector(getChadTip), for: .touchUpInside)
        }
        else {
            entertainMeButton.addTarget(self, action: #selector(presentBreakEntertainmentVC), for: .touchUpInside)
        }
        
        view.addSubview(entertainMeButton)
        entertainMeButton.translatesAutoresizingMaskIntoConstraints = false
        entertainMeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        entertainMeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        entertainMeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        entertainMeButton.bottomAnchor.constraint(equalTo: userAppsBackgroundView.topAnchor, constant: -viewHeight * (90.0/667.0)).isActive = true
    }
    
    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        view.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineDividerView.bottomAnchor.constraint(equalTo: entertainMeButton.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
    
    func setupCharacterMessageBody() {
        characterMessageBody.numberOfLines = 0
        characterMessageBody.textColor = Palette.grey.color
        characterMessageBody.textAlignment = .left
        characterMessageBody.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            characterMessageBody.text = "I thought you may want to catch up on texts, email, and Facebook, so I gave you easy access to those apps below. If you have nothing else to do, I can entertain you."
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageBody.text = viewModel.dataStore.user.currentCoach.breakStatements[randomIndex].body
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
            characterMessageHeader.text = "Time for a 5 minute break!"
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageHeader.text = viewModel.dataStore.user.currentCoach.breakStatements[randomIndex].header
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
        coachIcon.contentMode = .scaleAspectFit
        
        coachWindowView.addSubview(coachIcon)
        coachIcon.translatesAutoresizingMaskIntoConstraints = false
        coachIcon.backgroundColor = UIColor.clear
        
        coachBottomAnchorConstraint = coachIcon.bottomAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 100)
        coachBottomAnchorConstraint.isActive = true
        coachIcon.centerXAnchor.constraint(equalTo: coachWindowView.centerXAnchor, constant: 0).isActive = true
        coachIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coachIcon.widthAnchor.constraint(equalToConstant: 52).isActive = true
        coachIcon.layer.masksToBounds = true
    }
    
    func setupUserAppsBackground() {
        userAppsBackgroundView.backgroundColor = Palette.lightGrey.color
        view.addSubview(userAppsBackgroundView)
        
        userAppsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        userAppsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        userAppsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userAppsBackgroundView.heightAnchor.constraint(equalToConstant: viewHeight * (110/667)).isActive = true
        userAppsBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupUserApps() {
        let messagesApp = UIView()
        let messagesGesture = UITapGestureRecognizer(target: self, action: #selector(self.openMessagesApp))
        messagesApp.addGestureRecognizer(messagesGesture)
        messagesApp.backgroundColor = Palette.green.color
        
        let messagesIconView = UIImageView()
        messagesIconView.image = UIImage(named: "IC_messageApp")
        messagesApp.addSubview(messagesIconView)
        messagesIconView.translatesAutoresizingMaskIntoConstraints = false
        messagesIconView.widthAnchor.constraint(equalToConstant: viewWidth * (22/375)).isActive = true
        messagesIconView.heightAnchor.constraint(equalToConstant: viewWidth * (22/375)).isActive = true
        messagesIconView.centerYAnchor.constraint(equalTo: messagesApp.centerYAnchor).isActive = true
        messagesIconView.centerXAnchor.constraint(equalTo: messagesApp.centerXAnchor).isActive = true
        
        let emailApp = UIView()
        let emailGesture = UITapGestureRecognizer(target: self, action: #selector(self.openEmailApp))
        emailApp.addGestureRecognizer(emailGesture)
        emailApp.tag = 2
        emailApp.backgroundColor = Palette.purple.color
        
        let emailIconView = UIImageView()
        emailIconView.image = UIImage(named: "IC_emailApp")
        emailApp.addSubview(emailIconView)
        emailIconView.translatesAutoresizingMaskIntoConstraints = false
        emailIconView.widthAnchor.constraint(equalToConstant: viewWidth * (23/375)).isActive = true
        emailIconView.heightAnchor.constraint(equalToConstant: viewWidth * (20/375)).isActive = true
        emailIconView.centerYAnchor.constraint(equalTo: emailApp.centerYAnchor).isActive = true
        emailIconView.centerXAnchor.constraint(equalTo: emailApp.centerXAnchor).isActive = true
        
        let facebookApp = UIView()
        let facebookGesture = UITapGestureRecognizer(target: self, action: #selector(self.openFacebookApp))
        facebookApp.addGestureRecognizer(facebookGesture)
        facebookApp.tag = 3
        facebookApp.backgroundColor = Palette.navy.color
        
        let facebookIconView = UIImageView()
        facebookIconView.image = UIImage(named: "IC_facebookApp")
        facebookApp.addSubview(facebookIconView)
        facebookIconView.translatesAutoresizingMaskIntoConstraints = false
        facebookIconView.widthAnchor.constraint(equalToConstant: viewWidth * (13/375)).isActive = true
        facebookIconView.heightAnchor.constraint(equalToConstant: viewWidth * (21/375)).isActive = true
        facebookIconView.centerYAnchor.constraint(equalTo: facebookApp.centerYAnchor).isActive = true
        facebookIconView.centerXAnchor.constraint(equalTo: facebookApp.centerXAnchor).isActive = true
        
        let apps = [messagesApp, emailApp, facebookApp]
        
        apps.forEach { (app) in
            app.translatesAutoresizingMaskIntoConstraints = false
            app.heightAnchor.constraint(equalToConstant: viewWidth * (70/375)).isActive = true
            app.widthAnchor.constraint(equalToConstant: viewWidth * (70/375)).isActive = true
            app.layer.cornerRadius = (viewWidth * (70/375)) / 2
            app.layer.masksToBounds = true
        }
        
        let stackView = UIStackView(arrangedSubviews: apps)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        
        userAppsBackgroundView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: userAppsBackgroundView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: userAppsBackgroundView.centerYAnchor).isActive = true
    }
    
    func setupSettingsButton() {
        settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Settings-1"), for: .normal)
        
        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0).isActive = true
        settingsButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 21.0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 21.0).isActive = true
        
        settingsButton.addTarget(self, action: #selector(presentSettingsVC), for: .touchUpInside)
    }
    
    func setupLeaderBoardButton() {
        leaderBoardButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Leaderboard"), for: .normal)
        
        view.addSubview(leaderBoardButton)
        leaderBoardButton.translatesAutoresizingMaskIntoConstraints = false
        leaderBoardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.0).isActive = true
        leaderBoardButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 21.0).isActive = true
        leaderBoardButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        leaderBoardButton.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
    }
    
    func animateCoachPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.coachBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
}

extension BreakTimeViewController {
    
    func setupCancelSettingsButton() {
        self.dismissIcon.setBackgroundImage(#imageLiteral(resourceName: "IC_Quit"), for: .normal)
        self.dismissIcon.alpha = 0
        self.view.addSubview(self.dismissIcon)
        self.dismissIcon.translatesAutoresizingMaskIntoConstraints = false
        self.dismissIcon.centerYAnchor.constraint(equalTo: self.settingsButton.centerYAnchor).isActive = true
        self.dismissIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26).isActive = true
        self.dismissIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        self.dismissIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        self.dismissIcon.addTarget(self, action: #selector(self.dismissSettingVC), for: .touchUpInside)
    }
    
    func presentSettingsVC() {
        
        view.insertSubview(self.contentView, aboveSubview: coachIcon)
        self.contentView.backgroundColor = UIColor.red
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        // moe: changed constant below from 20 to 0, bug resolved.
        self.contentView.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 0).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.settingsButton.alpha = 0
            self.dismissIcon.alpha = 1
            
            self.addChildViewController(self.settingsVC)
            self.settingsVC.view.frame = self.contentView.bounds
            self.contentView.addSubview(self.settingsVC.view)
            self.settingsVC.didMove(toParentViewController: self)
        })
        
    }
    
    func dismissSettingVC() {
        self.contentView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.dismissIcon.alpha = 0
            self.settingsButton.alpha = 1
        })
    }

}

extension BreakTimeViewController {
    
    func breakTimeEndedUserNotificationRequest() {
        
        let content = UNMutableNotificationContent()
        content.title = viewModel.dataStore.user.currentCoach.breakNotificationStatements[0].header
        content.body = viewModel.dataStore.user.currentCoach.breakNotificationStatements[0].body
        
        content.sound = UNNotificationSound.default()
        
        let breakTimerLength = (viewModel.dataStore.user.currentCoach.difficulty.baseBreakLength)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(breakTimerLength), repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func userDidNotComeBackNotification() {
       
        let content = UNMutableNotificationContent()
        content.title = "Come back now."
        content.body = "Pops is getting impatient. He sees you still have not come back to the app yet."
        
        content.sound = UNNotificationSound.default()
        
        let breakTimerLength = (viewModel.dataStore.user.currentCoach.difficulty.baseBreakLength + 30)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(breakTimerLength), repeats: false)
        
        let identifier = "UYLLocalNotification2"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        
    }
}
