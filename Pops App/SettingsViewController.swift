
import UIKit

struct SettingsObj {
    let icon: UIImage
    let text: String
}

class SettingsViewController: UIViewController {

    let viewModel = SettingsViewModel()
    
    //view properties
    let endBreakView = UIView()
    let endBreakViewLabelLeft = UILabel()
    let endBreakViewLabelRight = UILabel()
    let endSessionView = UIView()
    let endSessionLabelLeft = UILabel()
    let endSessionLabelRight = UILabel()

    let settingsOne = SettingsObj(icon: #imageLiteral(resourceName: "IC_ContactUs"), text: "contact us")
    let settingsTwo = SettingsObj(icon: #imageLiteral(resourceName: "IC_SharePops"), text: "share pops")
    let divider1 = UIView()
    let divider2 = UIView()
    let divider3 = UIView()
    let divider4 = UIView()
    let propsHoursView = UIView()
    let totalPropsLabel = UILabel()
    let propsLabel = UILabel()
    let totalHoursLabel = UILabel()
    let hoursProductiveLabel = UILabel()
    let dismissIcon = UIButton()
    let progressBar = UIView()
    var progressBarWidth = NSLayoutConstraint()
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupProgressBar()
        setupDismissIcon()
        setupPropsHoursView()
        setupStackView()
        setupEndSessionView()
        setupEndBreakView()
        
    }

    func dismissCurrentView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//view setups
extension SettingsViewController {
    
    
    func setupProgressBar() {
        view.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.backgroundColor = Palette.salmon.color
        progressBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        progressBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 4).isActive = true
        progressBarWidth = progressBar.widthAnchor.constraint(equalToConstant: 10)
        progressBarWidth.isActive = true
    }
    
    func setupDismissIcon() {
        view.addSubview(dismissIcon)
        dismissIcon.translatesAutoresizingMaskIntoConstraints = false
        dismissIcon.setBackgroundImage(#imageLiteral(resourceName: "IC_SharePops"), for: .normal)
        dismissIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        dismissIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        dismissIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        dismissIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        dismissIcon.addTarget(self, action: #selector(dismissCurrentView), for: .touchUpInside)
    }
    
    func setupPropsHoursView() {
        propsHoursView.translatesAutoresizingMaskIntoConstraints = false
        propsHoursView.addSubview(totalPropsLabel)
        propsHoursView.addSubview(propsLabel)
        propsHoursView.addSubview(totalHoursLabel)
        propsHoursView.addSubview(hoursProductiveLabel)
        
        propsHoursView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        totalPropsLabel.text = "10.000"
        totalPropsLabel.font = UIFont(name: "Avenir-Heavy", size: 17)
        totalPropsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPropsLabel.topAnchor.constraint(equalTo: propsHoursView.topAnchor, constant: 0).isActive = true
        totalPropsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        totalPropsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        propsLabel.text = "props"
        propsLabel.font = UIFont(name: "Avenir-Heavy", size: 17)
        propsLabel.textColor = Palette.aqua.color
        propsLabel.translatesAutoresizingMaskIntoConstraints = false
        propsLabel.topAnchor.constraint(equalTo: totalPropsLabel.bottomAnchor, constant: 0).isActive = true
        propsLabel.widthAnchor.constraint(equalTo: totalPropsLabel.widthAnchor, constant: 0).isActive = true
        propsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        
        totalHoursLabel.text = "200"
        totalHoursLabel.font = UIFont(name: "Avenir-Heavy", size: 17)
        totalHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        totalHoursLabel.centerYAnchor.constraint(equalTo: totalPropsLabel.centerYAnchor, constant: 0).isActive = true
        totalHoursLabel.leadingAnchor.constraint(equalTo: totalPropsLabel.trailingAnchor, constant: 20).isActive = true
        totalHoursLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        totalHoursLabel.heightAnchor.constraint(equalTo: totalPropsLabel.heightAnchor, constant: 0).isActive = true
        
        hoursProductiveLabel.text = "hours being productive"
        hoursProductiveLabel.font = UIFont(name: "Avenir-Heavy", size: 17)
        hoursProductiveLabel.textColor = Palette.aqua.color
        hoursProductiveLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursProductiveLabel.centerYAnchor.constraint(equalTo: propsLabel.centerYAnchor, constant: 0).isActive = true
        hoursProductiveLabel.leadingAnchor.constraint(equalTo: totalHoursLabel.leadingAnchor, constant: 0).isActive = true
        hoursProductiveLabel.heightAnchor.constraint(equalTo: propsLabel.heightAnchor, constant: 0).isActive = true
        hoursProductiveLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
    }
    
    func setupStackView() {
        let customView = CustomSettingsView(settings: settingsOne)
        let secondView = CustomSettingsView(settings: settingsTwo)
        divider1.backgroundColor = Palette.lightGrey.color
        divider2.backgroundColor = Palette.lightGrey.color
        divider3.backgroundColor = Palette.lightGrey.color
        let stackedViews = [divider1, propsHoursView, divider2, customView, divider3, secondView, divider4]
        
        stackedViews.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        customView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        secondView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        divider1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        divider2.heightAnchor.constraint(equalToConstant: 2).isActive = true
        divider3.heightAnchor.constraint(equalToConstant: 2).isActive = true
        divider4.heightAnchor.constraint(equalToConstant: 2).isActive = true
        divider1.layer.cornerRadius = 3.0
        divider2.layer.cornerRadius = 3.0
        divider3.layer.cornerRadius = 3.0
        divider4.layer.cornerRadius = 3.0
        
        //secondView.backgroundColor = UIColor.gray
        stackView = UIStackView(arrangedSubviews: stackedViews)
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
    }
    
    func setupEndSessionView() {
        view.addSubview(endSessionView)
        endSessionView.backgroundColor = Palette.lightGrey.color
        endSessionView.translatesAutoresizingMaskIntoConstraints = false
        endSessionView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        endSessionView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        endSessionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20).isActive = true
        endSessionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        endSessionView.layer.cornerRadius = 5
        
        endSessionView.addSubview(endSessionLabelLeft)
        endSessionLabelLeft.font = UIFont(name: "Avenir-Heavy", size: 15)
        endSessionLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        endSessionLabelLeft.text = "end my session"
        endSessionLabelLeft.textColor = UIColor.black
        
        endSessionLabelLeft.leadingAnchor.constraint(equalTo: endSessionView.leadingAnchor, constant: 10).isActive = true
        endSessionLabelLeft.heightAnchor.constraint(equalToConstant: 17).isActive = true
        endSessionLabelLeft.widthAnchor.constraint(equalTo: endSessionView.widthAnchor, multiplier: 0.4).isActive = true
        endSessionLabelLeft.centerYAnchor.constraint(equalTo: endSessionView.centerYAnchor, constant: 0).isActive = true
        
        
        endSessionView.addSubview(endSessionLabelRight)
        endSessionLabelRight.font = UIFont(name: "Avenir-Heavy", size: 15)
        endSessionLabelRight.translatesAutoresizingMaskIntoConstraints = false
        endSessionLabelRight.text = "1:00:00 left"
        endSessionLabelRight.textColor = UIColor.black
        endSessionLabelRight.textAlignment = .right
        
        endSessionLabelRight.trailingAnchor.constraint(equalTo: endSessionView.trailingAnchor, constant: -10).isActive = true
        endSessionLabelRight.heightAnchor.constraint(equalToConstant: 17).isActive = true
        endSessionLabelRight.widthAnchor.constraint(equalTo: endSessionView.widthAnchor, multiplier: 0.4).isActive = true
        endSessionLabelRight.centerYAnchor.constraint(equalTo: endSessionView.centerYAnchor, constant: 0).isActive = true
        
    }
    
    func setupEndBreakView() {
        view.addSubview(endBreakView)
        endBreakView.backgroundColor = Palette.navy.color
        endBreakView.translatesAutoresizingMaskIntoConstraints = false
        endBreakView.widthAnchor.constraint(equalTo: endSessionView.widthAnchor, multiplier: 1).isActive = true
        endBreakView.heightAnchor.constraint(equalTo: endSessionView.heightAnchor, multiplier: 1).isActive = true
        endBreakView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        endBreakView.bottomAnchor.constraint(equalTo: endSessionView.topAnchor, constant: -20).isActive = true
        endBreakView.layer.cornerRadius = 5
        
        endBreakView.addSubview(endBreakViewLabelLeft)
        endBreakViewLabelLeft.font = UIFont(name: "Avenir-Heavy", size: 15)
        endBreakViewLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        endBreakViewLabelLeft.text = "end my break"
        endBreakViewLabelLeft.textColor = UIColor.white
        
        endBreakViewLabelLeft.leadingAnchor.constraint(equalTo: endBreakView.leadingAnchor, constant: 10).isActive = true
        endBreakViewLabelLeft.heightAnchor.constraint(equalToConstant: 17).isActive = true
        endBreakViewLabelLeft.widthAnchor.constraint(equalTo: endBreakView.widthAnchor, multiplier: 0.4).isActive = true
        endBreakViewLabelLeft.centerYAnchor.constraint(equalTo: endBreakView.centerYAnchor, constant: 0).isActive = true
        
        endBreakView.addSubview(endBreakViewLabelRight)
        endBreakViewLabelRight.font = UIFont(name: "Avenir-Heavy", size: 15)
        endBreakViewLabelRight.translatesAutoresizingMaskIntoConstraints = false
        endBreakViewLabelRight.text = "3:51 left"
        endBreakViewLabelRight.textColor = UIColor.white
        endBreakViewLabelRight.textAlignment = .right
        
        endBreakViewLabelRight.trailingAnchor.constraint(equalTo: endBreakView.trailingAnchor, constant: -10).isActive = true
        endBreakViewLabelRight.heightAnchor.constraint(equalToConstant: 17).isActive = true
        endBreakViewLabelRight.widthAnchor.constraint(equalTo: endBreakView.widthAnchor, multiplier: 0.4).isActive = true
        endBreakViewLabelRight.centerYAnchor.constraint(equalTo: endBreakView.centerYAnchor, constant: 0).isActive = true
    }
}
