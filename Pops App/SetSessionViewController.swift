
import UIKit

class SetSessionViewController: UIViewController {
    
    let viewModel = SetSessionViewModel.singleton
    
    var startButtonBottomConstraint: NSLayoutConstraint!
    var headerViewTopConstraint: NSLayoutConstraint!
 
    let headerView = UIView()
    let coachImageView = UIImageView()
    let settingsButton = UIButton()
    let setSessionLabel = UILabel()
    lazy var totalTimeEntryButton = UIView()
    var totalTimeEntryLabel = UILabel()
    lazy var startButton = UIButton()
    lazy var timePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupStartButton()
        setupTotalTimeEntryButton()
        setupTotalTimeEntryLabel()
        setupSetSessionLabel()
        setupHeaderView()
        setupCoachImageView()
        setupSettingsButton()
        
        setupPickerView()
        timePicker.isHidden = true
        
        totalTimeEntryLabel.text = viewModel.totalTimesForPicker[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func presentProductiveTimeVC() {
        let productiveTimeVC = ProductiveTimeViewController()
        productiveTimeVC.totalTime.text = totalTimeEntryLabel.text
        present(productiveTimeVC, animated: true, completion: nil)
    }
}


//View Setups
extension SetSessionViewController {
    func setupStartButton() {
        startButton.backgroundColor = Palette.aqua.color
        startButton.layer.cornerRadius = 2.0
        startButton.layer.masksToBounds = true
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        startButton.addTarget(self, action: #selector(presentProductiveTimeVC), for: .touchUpInside)
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        self.startButtonBottomConstraint = startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65.0)
        startButtonBottomConstraint.isActive = true
    }
    
    func setupTotalTimeEntryButton() {
        totalTimeEntryButton.backgroundColor = Palette.lightGrey.color
        totalTimeEntryButton.layer.cornerRadius = 2.0
        totalTimeEntryButton.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.displayPickerView))
        totalTimeEntryButton.addGestureRecognizer(gesture)
        
        view.addSubview(totalTimeEntryButton)
        totalTimeEntryButton.translatesAutoresizingMaskIntoConstraints = false
        totalTimeEntryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        totalTimeEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
        totalTimeEntryButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        totalTimeEntryButton.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -100.00).isActive = true
    }
    
    func setupTotalTimeEntryLabel() {
        totalTimeEntryLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        totalTimeEntryLabel.textColor = Palette.grey.color
        
        totalTimeEntryButton.addSubview(totalTimeEntryLabel)
        totalTimeEntryLabel.translatesAutoresizingMaskIntoConstraints = false
        totalTimeEntryLabel.leadingAnchor.constraint(equalTo: totalTimeEntryButton.leadingAnchor, constant: 15.0).isActive = true
        totalTimeEntryLabel.centerYAnchor.constraint(equalTo: totalTimeEntryButton.centerYAnchor).isActive = true
    }
    
    func setupSetSessionLabel() {
        setSessionLabel.numberOfLines = 2
        setSessionLabel.textColor = UIColor.black
        let labelString = "I want to make\nPOPS PROUD for the"
        let normalFont = UIFont(name: "Avenir-Medium", size: 19.0)
        let boldFont = UIFont(name: "Avenir-Black", size: 19.0)
        setSessionLabel.attributedText = labelString.addBoldText(fullString: "I want to make\nPOPS PROUD for the", boldPartsOfString: ["POPS PROUD"], font: normalFont, boldFont: boldFont)
        
        view.addSubview(setSessionLabel)
        setSessionLabel.translatesAutoresizingMaskIntoConstraints = false
        setSessionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
        setSessionLabel.bottomAnchor.constraint(equalTo: totalTimeEntryButton.topAnchor, constant: -15.0).isActive = true
    }
    
    func setupHeaderView() {
        headerView.backgroundColor = Palette.darkHeader.color

        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 185.0).isActive = true
        headerViewTopConstraint = headerView.topAnchor.constraint(equalTo: view.topAnchor)
        headerViewTopConstraint.isActive = true
    }
    
    func setupCoachImageView() {
        coachImageView.image = UIImage(named: "IC_POPS")
        coachImageView.contentMode = .scaleAspectFit
        
        headerView.addSubview(coachImageView)
        coachImageView.translatesAutoresizingMaskIntoConstraints = false
        coachImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coachImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        coachImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        coachImageView.widthAnchor.constraint(equalToConstant: 52.0).isActive = true
    }
    
    func setupSettingsButton() {
        settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Settings"), for: .normal)
        
        headerView.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.0).isActive = true
        settingsButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20.0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 21.0).isActive = true
    }
    
    func setupPickerView() {
        timePicker.delegate = self
        timePicker.dataSource = self
        
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 220.0).isActive = true
    }
}


//Picker View Delegate & DataSource Functionality
extension SetSessionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func displayPickerView() {
        timePicker.isHidden = false
   
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.hidePickerView))
        self.view.addGestureRecognizer(tap)
    }
    
    func hidePickerView() {
        timePicker.isHidden = true
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.totalTimesForPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.totalTimesForPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        totalTimeEntryLabel.text = viewModel.totalTimesForPicker[row]
    }
    
}
