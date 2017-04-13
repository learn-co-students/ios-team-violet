
import UIKit

class ProductiveTimeViewController: UIViewController, ProductiveTimeViewModelDelegate {

    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    
    var viewModel: ProductiveTimeViewModel!

    var productiveTimeLabel = UILabel()
    
    let coachWindowView = UIView()
    let coachIcon = UIImageView()
    let cancelSessionButton = UIButton()
    var propsLabel = UILabel()
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    let progressBar = UIView()
    var progressBarWidthAnchor: NSLayoutConstraint! {
        didSet {
            self.view.layoutIfNeeded()
        }
    }
    
    let characterMessageHeader = UILabel()
    let characterMessageBody = UILabel()
    let lockIconImageView = UIImageView()
    let lockLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProductiveTimeViewModel(vc: self)
        view.backgroundColor = Palette.darkHeader.color
        
        setupProgressBar()
        setupPropsLabel()
        setupLockImageView()
        setupLockLabel()
        
        setupCancelSessionButton()
        setupProductiveTimeLabel()
        setupCharacterMessageBody()
        setupCharacterMessageHeader()
        setupCoachWindow()
        setupCoachIcon()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: NSNotification.Name(rawValue: "appEnteredForeground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredBackground), name: NSNotification.Name(rawValue: "appEnteredBackground"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productiveTimeLabel.isHidden = true
        propsLabel.isHidden = true
        
        animateCoachPopup()
    }
    
    func appEnteredForeground() {
        viewModel.updateTimers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        
        viewModel.startTimer()
        
        if viewModel.dataStore.defaults.value(forKey: "sessionActive") as? Bool == false {
            viewModel.dataStore.user.currentSession?.startSessionTimer()
            viewModel.dataStore.defaults.set(Date(), forKey: "sessionTimerStartedAt")
            viewModel.dataStore.defaults.set(true, forKey: "sessionActive")
        }
    }
    
    func appEnteredBackground() {
        viewModel.dataStore.user.totalProps += viewModel.currentCyclePropsToScore
        viewModel.dataStore.defaults.set(viewModel.dataStore.user.totalProps, forKey: "totalProps")
        print(viewModel.dataStore.user.totalProps)
        viewModel.currentCyclePropsScored += viewModel.currentCyclePropsToScore
        viewModel.currentCyclePropsToScore = 0
    }
    
    func cancelSession() {
        viewModel.productivityTimer.invalidate()
        viewModel.dataStore.user.currentSession?.sessionTimer.invalidate()
        viewModel.dataStore.defaults.set(false, forKey: "sessionActive")
        
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in self.dismiss(animated: true, completion: nil)
        }
    }
    
    func moveToBreak() {
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in self.present(BreakTimeViewController(), animated: true, completion: nil)
        }
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
    
    func setupLockImageView() {
        lockIconImageView.image = UIImage(named: "IC_Lock")
        lockIconImageView.contentMode = .scaleAspectFill
        view.addSubview(lockIconImageView)
        lockIconImageView.translatesAutoresizingMaskIntoConstraints = false
        lockIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewWidth * (30/375)).isActive = true
        lockIconImageView.widthAnchor.constraint(equalToConstant: viewWidth * (20/375)).isActive = true
        lockIconImageView.heightAnchor.constraint(equalToConstant: viewHeight * (16/667)).isActive = true
        lockIconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: viewHeight * (104/667)).isActive = true
    }
    
    func setupLockLabel() {
        view.addSubview(lockLabel)
        lockLabel.text = "lock"
        lockLabel.font = UIFont(name: "Avenir-Heavy", size: 14)
        lockLabel.textColor = UIColor.white
        
        lockLabel.translatesAutoresizingMaskIntoConstraints = false
        lockLabel.centerYAnchor.constraint(equalTo: lockIconImageView.centerYAnchor).isActive = true
        lockLabel.trailingAnchor.constraint(equalTo: lockIconImageView.leadingAnchor, constant: -15).isActive = true
    }
    
    func setupCancelSessionButton() {
        view.addSubview(cancelSessionButton)
        cancelSessionButton.setTitle("cancel session", for: .normal)
        cancelSessionButton.titleLabel?.text = "cancel session"
        cancelSessionButton.titleLabel?.textColor = Palette.grey.color
        cancelSessionButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 13.0)
        cancelSessionButton.addTarget(self, action: #selector(cancelSession), for: .touchUpInside)
        
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
        characterMessageBody.text = viewModel.dataStore.user.currentCoach.productivityStatements[0].body
        
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
        characterMessageHeader.text = viewModel.dataStore.user.currentCoach.productivityStatements[0].header
        
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
    
    func animateCancelToSkip() {
        self.cancelSessionButton.setTitle("early break plz", for: .normal)
        self.cancelSessionButton.titleLabel?.text = "early break plz"
        self.cancelSessionButton.removeTarget(self, action: #selector(self.cancelSession), for: .touchUpInside)
        self.cancelSessionButton.addTarget(self, action: #selector(self.skipToBreak), for: .touchUpInside)
    }
}
