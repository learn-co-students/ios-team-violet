
import UIKit
import UserNotifications
import AudioToolbox

class ProductiveTimeViewController: UIViewController, ProductiveTimeViewModelDelegate {

    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    
    var viewModel: ProductiveTimeViewModel!
    
    let center = UNUserNotificationCenter.current()

    var productiveTimeLabel = UILabel()
    
    let coachWindowView = UIView()
    let coachIcon = UIImageView()
    let cancelSessionButton = UIButton()
    var propsLabel = UILabel()
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    var chargerLabel = UILabel()
    var chargerImage = UIImageView()
    
    var vibrateTimer = Timer()
    var flashlightTimer = Timer()
    
    var userMightCancel = false
    
    let progressBar = UIView()
    var progressBarWidthAnchor: NSLayoutConstraint! {
        didSet {
            self.view.layoutIfNeeded()
        }
    }
    
    var characterMessageHeader = UILabel()
    var characterMessageBody = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProductiveTimeViewModel(vc: self)
        view.backgroundColor = Palette.darkHeader.color
        
        setupProgressBar()
        setupPropsLabel()
        
        setupCancelSessionButton()
        setupProductiveTimeLabel()
        setupCharacterMessageBody()
        setupCharacterMessageHeader()
        setupCoachWindow()
        setupCoachIcon()
        
        //setupChargerLabel()
        //setupChargerImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: NSNotification.Name(rawValue: "appEnteredForeground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredBackground), name: NSNotification.Name(rawValue: "appEnteredBackground"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productiveTimeLabel.isHidden = true
        propsLabel.isHidden = true
        
        animateCoachPopup()
        productiveTimeEndedUserNotificationRequest()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func appEnteredForeground() {
        if viewModel.dataStore.user.currentSession != nil {
            print("updating timers")
            viewModel.updateTimers()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        
        productiveTimeEndedUserNotificationRequest()
        
        if (viewModel.dataStore.user.currentSession?.mightCancelSession)! {
            appEnteredForeground()
            viewModel.dataStore.user.currentSession?.mightCancelSession = false
        } else {
            viewModel.startTimer()
        }
        
        if viewModel.dataStore.defaults.value(forKey: "sessionActive") as? Bool == false {
            viewModel.dataStore.defaults.set(true, forKey: "sessionActive")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (viewModel.dataStore.user.currentSession?.mightCancelSession)! {
            appEnteredBackground()
        }
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func appEnteredBackground() {
        viewModel.currentCyclePropsScored += viewModel.currentCyclePropsToScore
        viewModel.currentCyclePropsToScore = 0
    }
    
    func cancelSession() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if !(viewModel.dataStore.user.currentSession?.mightCancelSession)! {
            viewModel.productivityTimer.invalidate()
            viewModel.dataStore.user.currentSession?.sessionTimer.invalidate()
        }
        
        viewModel.dataStore.defaults.set(false, forKey: "sessionActive")
        
        if (viewModel.dataStore.user.currentSession?.mightCancelSession)! {
            UIView.animate(withDuration: 0.7, animations: {
                self.coachBottomAnchorConstraint.constant = 100
                self.view.layoutIfNeeded()
                
            }) { _ in self.present(SessionEndedViewController(), animated: true, completion: nil)
            }
        } else {
            present(SetSessionViewController(), animated: true, completion: nil)
        }
    }
    
    func cancelSessionWithPenalty() {
        viewModel.dataStore.user.currentSession?.mightCancelSession = true
        cancelSession()
    }
    
    func moveToBreak() {        
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in self.present(BreakTimeViewController(), animated: true, completion: nil)
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func skipToBreak() {
       viewModel.skipToBreak()
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in self.present(BreakTimeViewController(), animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension ProductiveTimeViewController {
    
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
    
    func setupPropsLabel() {
        view.addSubview(propsLabel)
        self.propsLabel.isHidden = true
        propsLabel.font = UIFont(name: "Avenir-Heavy", size: 14)
        propsLabel.textColor = UIColor.white
        
        propsLabel.translatesAutoresizingMaskIntoConstraints = false
        propsLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 25).isActive = true
        propsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        propsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        propsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupCancelSessionButton() {
        view.addSubview(cancelSessionButton)
        
        if viewModel.dataStore.defaults.value(forKey: "sessionActive") as? Bool == false {
            cancelSessionButton.setTitle("cancel session", for: .normal)
            cancelSessionButton.addTarget(self, action: #selector(cancelSession), for: .touchUpInside)
        } else {
            cancelSessionButton.setTitle("im weak", for: .normal)
            cancelSessionButton.addTarget(self, action: #selector(cancelSessionWithPenalty), for: .touchUpInside)
        }
    
        cancelSessionButton.titleLabel?.textColor = Palette.white.color
        cancelSessionButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 13.0)
      
        cancelSessionButton.translatesAutoresizingMaskIntoConstraints = false
        cancelSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        cancelSessionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        cancelSessionButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupProductiveTimeLabel() {
        view.addSubview(productiveTimeLabel)
        productiveTimeLabel.isHidden = true
        productiveTimeLabel.textAlignment = .center
        productiveTimeLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        productiveTimeLabel.textColor = UIColor.white
        
        productiveTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        productiveTimeLabel.topAnchor.constraint(equalTo: cancelSessionButton.topAnchor, constant: -viewHeight * (120/667)).isActive = true
        productiveTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        productiveTimeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        productiveTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupCharacterMessageBody() {
        characterMessageBody.numberOfLines = 0
        characterMessageBody.textColor = Palette.grey.color
        characterMessageBody.textAlignment = .left
        characterMessageBody.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            characterMessageBody.text = "You won’t earn props unless it’s face down. When the timer hits 0, your camera will flash signaling that it’s time for a break."
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageBody.text = viewModel.dataStore.user.currentCoach.productivityStatements[randomIndex].body
        }
        
        view.addSubview(characterMessageBody)
        characterMessageBody.translatesAutoresizingMaskIntoConstraints = false
        characterMessageBody.bottomAnchor.constraint(equalTo: productiveTimeLabel.topAnchor, constant: -viewHeight * (30/667)).isActive = true
        characterMessageBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewWidth * (53/375)).isActive = true
        characterMessageBody.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewWidth * (53/375)).isActive = true
    }
    
    func setupCharacterMessageHeader() {
        characterMessageHeader.numberOfLines = 0
        characterMessageHeader.textColor = UIColor.white
        characterMessageHeader.textAlignment = .left
        characterMessageHeader.font = UIFont(name: "Avenir-Black", size: 14.0)
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            characterMessageHeader.text = "Plug your phone into a charger and flip it face down. Then get to work!"
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageHeader.text = viewModel.dataStore.user.currentCoach.productivityStatements[randomIndex].header
        }
        
        view.addSubview(characterMessageHeader)
        characterMessageHeader.translatesAutoresizingMaskIntoConstraints = false
        characterMessageHeader.bottomAnchor.constraint(equalTo: characterMessageBody.topAnchor, constant: -viewHeight * (5/667)).isActive = true
        characterMessageHeader.leadingAnchor.constraint(equalTo: characterMessageBody.leadingAnchor).isActive = true
        characterMessageHeader.trailingAnchor.constraint(equalTo: characterMessageBody.trailingAnchor).isActive = true
    }

    func setupCoachWindow() {
        view.addSubview(coachWindowView)
        coachWindowView.translatesAutoresizingMaskIntoConstraints = false
        coachWindowView.backgroundColor = Palette.salmon.color
        coachWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        coachWindowView.bottomAnchor.constraint(equalTo: characterMessageHeader.topAnchor, constant: -viewHeight * (35/667)).isActive = true
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
        coachIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coachIcon.widthAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    func setupChargerLabel() {
        chargerLabel.numberOfLines = 0
        chargerLabel.textAlignment = .center
        chargerLabel.textColor = UIColor.white
        chargerLabel.font = UIFont(name: "Avenir-Medium", size: 13)
        chargerLabel.text = "*for the best experience, plug your phone into charger"
        
        view.addSubview(chargerLabel)
        chargerLabel.translatesAutoresizingMaskIntoConstraints = false
        chargerLabel.widthAnchor.constraint(equalToConstant: viewWidth * (200/375)).isActive = true
        chargerLabel.bottomAnchor.constraint(equalTo: coachWindowView.topAnchor, constant: -viewHeight * (64/667)).isActive = true
        chargerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupChargerImage() {
        chargerImage.image = #imageLiteral(resourceName: "IC_charger")
        chargerImage.contentMode = .scaleAspectFit
        view.addSubview(chargerImage)
        chargerImage.translatesAutoresizingMaskIntoConstraints = false
        chargerImage.centerXAnchor.constraint(equalTo: chargerLabel.centerXAnchor).isActive = true
        chargerImage.bottomAnchor.constraint(equalTo: chargerLabel.topAnchor, constant: -viewHeight * (2/667)).isActive = true
        chargerImage.heightAnchor.constraint(equalToConstant: viewHeight * (23/667)).isActive = true
        chargerImage.widthAnchor.constraint(equalToConstant: viewHeight * (23/667)).isActive = true
    }
    
    func animateCoachPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.coachBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }) { _ in
            self.propsLabel.isHidden = false
            self.productiveTimeLabel.isHidden = false
        }
    }
    
    func animateCancelToWeak() {
        self.cancelSessionButton.setTitle("im weak", for: .normal)
        self.cancelSessionButton.titleLabel?.text = "im weak"
        self.cancelSessionButton.titleLabel?.textColor = Palette.lightGrey.color
        
        self.cancelSessionButton.removeTarget(self, action: #selector(self.cancelSession), for: .touchUpInside)
        //TODO: Uncomment for production
        self.cancelSessionButton.addTarget(self, action: #selector(self.cancelSessionWithPenalty), for: .touchUpInside)
        //self.cancelSessionButton.addTarget(self, action: #selector(self.skipToBreak), for: .touchUpInside)
    }
}

extension ProductiveTimeViewController {
    
    func productiveTimeEndedUserNotificationRequest() {
        
        let content = UNMutableNotificationContent()
        content.title = viewModel.dataStore.user.currentCoach.productivityNotificationStatements[0].header
        content.body = viewModel.dataStore.user.currentCoach.productivityNotificationStatements[0].body
        content.sound = UNNotificationSound.default()
        
        let productivityTimerLength = viewModel.dataStore.user.currentCoach.difficulty.baseProductivityLength
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(productivityTimerLength), repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error) }})
    }
}
