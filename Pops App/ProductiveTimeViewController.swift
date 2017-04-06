
import UIKit

class ProductiveTimeViewController: UIViewController {

    var viewModel: ProductiveTimeViewModel!
    var progressBarWidthAnchor: NSLayoutConstraint!

    let totalTimeLabel = UILabel()
    let popsWindowView = UIView()
    let pepTalkLabel = UILabel()
    let popsIcon = UIImageView()
    let cancelSessionButton = UIButton()
    let progressBar = UIView()
    let propsLabel = UILabel()
    //Timers
    let timer = Timer()
    let backgroundTimer = Timer()
    //changing constraints
    var progressBarWidthAnchorConstraint: NSLayoutConstraint!
    var popsBottomAnchorConstraint: NSLayoutConstraint!
    
    
    //properties that handle displaying data
    var totalTime = 0 {
        didSet {
            totalTimeLabel.text = viewModel.formatTime(time: totalTime)
        }
    }
    var props = 0 {
        didSet {
            propsLabel.text = "\(props) props"
        }
    }
    var progress = 0.0 {
        didSet {
                self.progressBarWidthAnchor.constant = CGFloat(self.view.frame.width * CGFloat(self.progress) )
                self.view.layoutIfNeeded()
        }
    }
    
    
    override func viewDidLoad() { //remember to call the setup function here!
        super.viewDidLoad()
        viewModel = ProductiveTimeViewModel(vc: self)
        view.backgroundColor = Palette.darkHeader.color
        setupProgressBar()
        setupPropsLabel()
        setupPopsWindow()
        setupPopsIcon()
        setupPepTalkLabel()
        setupCancelSessionButton()
        setupTotalTimeLabel()
        viewModel.startTimers()
        
        
        //this is the back button.
        let frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        let backButton = UIButton(frame: frame)
        backButton.backgroundColor = UIColor.clear
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        //delete ifyou don't need it.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePopsPopup()
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
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
        propsLabel.text = "\(props) props"
        propsLabel.font = UIFont(name: "AvenirNext", size: 10)
        propsLabel.textColor = UIColor.white
        
        propsLabel.translatesAutoresizingMaskIntoConstraints = false
        propsLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 25).isActive = true
        propsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        propsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        propsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    
    func setupPopsWindow() {
        view.addSubview(popsWindowView)
        popsWindowView.translatesAutoresizingMaskIntoConstraints = false
        popsWindowView.backgroundColor = Palette.salmon.color
        popsWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        popsWindowView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        popsWindowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        popsWindowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        popsWindowView.layer.cornerRadius = 50.0
        popsWindowView.layer.masksToBounds = true
    }
    
    func setupPopsIcon() {
        popsIcon.image = UIImage(named: "IC_POPS")
        popsIcon.contentMode = .scaleAspectFit
        
        popsWindowView.addSubview(popsIcon)
        popsIcon.translatesAutoresizingMaskIntoConstraints = false
        popsIcon.backgroundColor = UIColor.clear
        
        popsBottomAnchorConstraint = popsIcon.bottomAnchor.constraint(equalTo: popsWindowView.bottomAnchor, constant: 100)
        popsBottomAnchorConstraint.isActive = true
        popsIcon.centerXAnchor.constraint(equalTo: popsWindowView.centerXAnchor, constant: 0).isActive = true
        popsIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        popsIcon.widthAnchor.constraint(equalToConstant: 52).isActive = true
        popsIcon.layer.masksToBounds = true
    }
    
    func setupPepTalkLabel() {
        pepTalkLabel.numberOfLines = 3
        pepTalkLabel.textColor = UIColor.white
        let labelString = "Stay focused. The useless stuff on the internet can wait."
        let normalFont = UIFont(name: "AvenirNext-MediumItalic", size: 15.0)
        
        pepTalkLabel.text = labelString
        pepTalkLabel.font = normalFont
        
        view.addSubview(pepTalkLabel)
        pepTalkLabel.translatesAutoresizingMaskIntoConstraints = false
        pepTalkLabel.topAnchor.constraint(equalTo: popsWindowView.bottomAnchor, constant: 0).isActive = true
        pepTalkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pepTalkLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pepTalkLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupTotalTimeLabel() {
        view.addSubview(totalTimeLabel)
        totalTimeLabel.text = "\(viewModel.formatTime(time: totalTime))"
        totalTimeLabel.textAlignment = .center
        totalTimeLabel.font = UIFont(name: "Avenir-Medium", size: 25)
        totalTimeLabel.textColor = UIColor.white
        
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalTimeLabel.topAnchor.constraint(equalTo: pepTalkLabel.bottomAnchor, constant: 12).isActive = true
        totalTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        totalTimeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        totalTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupCancelSessionButton() {
        view.addSubview(cancelSessionButton)
        cancelSessionButton.setTitle("im weak", for: .normal)
        cancelSessionButton.titleLabel?.text = "im weak"
        cancelSessionButton.titleLabel?.textColor = UIColor.white
        cancelSessionButton.titleLabel?.font = UIFont(name: "AvenirNext-MediumItalic", size: 12.0)
        
        cancelSessionButton.translatesAutoresizingMaskIntoConstraints = false
        cancelSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        cancelSessionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        cancelSessionButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelSessionButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func animatePopsPopup() {
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.popsBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
}
