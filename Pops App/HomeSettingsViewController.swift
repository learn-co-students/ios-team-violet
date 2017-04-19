import Foundation
import UIKit

class HomeSettingsViewController: UIViewController {
    
    lazy var viewWidth: CGFloat = self.view.frame.width  //375
    lazy var viewHeight: CGFloat = self.view.frame.height  //667
    
    var viewModel = SettingsViewModel()

    let divider1 = UIView()
    let divider2 = UIView()
    let divider3 = UIView()
    let divider4 = UIView()
    let propsHoursView = UIView()
    let totalPropsLabel = UILabel()
    let propsLabel = UILabel()
    let totalHoursLabel = UILabel()
    let hoursProductiveLabel = UILabel()
    let progressBar = UIView()
    var progressBarWidth = NSLayoutConstraint()
    
    var settingsStackView = UIStackView()
    
    let headerView = UIView()
    let dismissIcon = UIButton()
    
    var pops: CustomCharacterView!
    var chad: CustomCharacterView!
    var baba: CustomCharacterView!
    
    var usersCurrentCoach: String {
        return viewModel.dataStore.user.currentCoach.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupHeaderView()
        setupCancelSettingsButton()
        
        setupPropsHoursView()
        setupStackView()
        setupCharacterViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForSelectedCharacter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pops.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        pops.checkMarkIcon.alpha = 0.0
        
        chad.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        chad.checkMarkIcon.alpha = 0.0
        
        baba.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        baba.checkMarkIcon.alpha = 0.0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func checkForSelectedCharacter() {
        switch usersCurrentCoach {
        case "Pops":
            pops.circleBackgroundView.backgroundColor = Palette.salmon.color
            pops.checkMarkIcon.alpha = 1.0
        case "Chad":
            chad.circleBackgroundView.backgroundColor = Palette.salmon.color
            chad.checkMarkIcon.alpha = 1.0
        case "Baba":
            baba.circleBackgroundView.backgroundColor = Palette.salmon.color
            baba.checkMarkIcon.alpha = 1.0
        default:
            pops.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            chad.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            baba.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        }
    }
    
    func setupPropsHoursView() {
        propsHoursView.translatesAutoresizingMaskIntoConstraints = false
        propsHoursView.addSubview(totalPropsLabel)
        propsHoursView.addSubview(propsLabel)
        propsHoursView.addSubview(totalHoursLabel)
        propsHoursView.addSubview(hoursProductiveLabel)
        
        propsHoursView.heightAnchor.constraint(equalToConstant: viewHeight * (40/667)).isActive = true
        propsHoursView.widthAnchor.constraint(equalToConstant: viewWidth * (300/375)).isActive = true
        
        totalPropsLabel.text = String(viewModel.dataStore.user.totalProps)
        totalPropsLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        totalPropsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPropsLabel.topAnchor.constraint(equalTo: propsHoursView.topAnchor, constant: 2).isActive = true
        totalPropsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        
        propsLabel.text = "props"
        propsLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        propsLabel.textColor = Palette.aqua.color
        propsLabel.translatesAutoresizingMaskIntoConstraints = false
        propsLabel.topAnchor.constraint(equalTo: totalPropsLabel.bottomAnchor, constant: 0).isActive = true
        propsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        
        let totalHours = viewModel.dataStore.defaults.value(forKey: "totalHours") as? Int ?? 0
        totalHoursLabel.text = totalHours.description
        totalHoursLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        totalHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        totalHoursLabel.centerYAnchor.constraint(equalTo: totalPropsLabel.centerYAnchor, constant: 0).isActive = true
        totalHoursLabel.leadingAnchor.constraint(equalTo: propsHoursView.centerXAnchor, constant: -viewWidth * (125/667)).isActive = true
        
        hoursProductiveLabel.text = "hours being productive"
        hoursProductiveLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        hoursProductiveLabel.textColor = Palette.aqua.color
        hoursProductiveLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursProductiveLabel.centerYAnchor.constraint(equalTo: propsLabel.centerYAnchor, constant: 0).isActive = true
        hoursProductiveLabel.leadingAnchor.constraint(equalTo: totalHoursLabel.leadingAnchor, constant: 0).isActive = true
    }
    
    func setupStackView() {
        let contactUsBttn = CustomSettingsView(iconImage: #imageLiteral(resourceName: "IC_ContactUs"), text: "contact us")
        let shareBttn = CustomSettingsView(iconImage: #imageLiteral(resourceName: "IC_SharePops"), text: "share us")
        
        let dividers = [divider1, divider2, divider3, divider4]
        let stackedViews = [divider1, propsHoursView, divider2, contactUsBttn, divider3, shareBttn, divider4]
        
        dividers.forEach {
            $0.backgroundColor = Palette.lightGrey.color
            $0.heightAnchor.constraint(equalToConstant: 3).isActive = true
            $0.layer.cornerRadius = 2.0
        }
        
        stackedViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contactUsBttn.heightAnchor.constraint(equalToConstant: viewHeight * (25 / 667)).isActive = true
        contactUsBttn.addTarget(self, action: #selector(contactUsBttnPressed), for: .touchUpInside)
        shareBttn.heightAnchor.constraint(equalToConstant: viewHeight * (25 / 667)).isActive = true
        shareBttn.addTarget(self, action: #selector(shareBttnPressed), for: .touchUpInside)
        
        settingsStackView = UIStackView(arrangedSubviews: stackedViews)
        
        view.addSubview(settingsStackView)
        settingsStackView.axis = .vertical
        settingsStackView.distribution = .equalSpacing
        settingsStackView.alignment = .fill
        settingsStackView.spacing = viewHeight * (26 / 667)
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        settingsStackView.widthAnchor.constraint(equalToConstant: viewWidth * (300 / 375)).isActive = true
        settingsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: startButtonBottomConstraint()).isActive = true
    }
    
    func setupCharacterViews() {
 
        pops = CustomCharacterView(image: UIImage(named: "IC_POPS")!)
        let popsGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectPopsCharacter))
        pops.addGestureRecognizer(popsGesture)

        chad = CustomCharacterView(image: UIImage(named: "IC_CHAD")!)
        let chadGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectChadCharacter))
        chad.addGestureRecognizer(chadGesture)

        baba = CustomCharacterView(image: UIImage(named: "IC_BABA")!)
        let babaGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectBabaCharacter))
        baba.addGestureRecognizer(babaGesture)
        
        let chars = [pops, chad, baba]
        
        chars.forEach { (view) in
            view?.translatesAutoresizingMaskIntoConstraints = false
            view?.heightAnchor.constraint(equalToConstant: viewWidth * (86/375)).isActive = true
            view?.widthAnchor.constraint(equalToConstant: viewWidth * (86/375)).isActive = true
        }
        
        let stackView = UIStackView(arrangedSubviews: chars as! [UIView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = viewWidth * (20/375)
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: settingsStackView.topAnchor, constant: -20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: viewWidth * (300 / 375)).isActive = true
    }
    
    func didSelectChadCharacter() {
        let detailVC = CharacterDetailViewController()
        let chad = viewModel.dataStore.generateChadDetailView()
        detailVC.coach = chad
        present(detailVC, animated: true, completion: nil)
    }
    
    func didSelectPopsCharacter() {
        let detailVC = CharacterDetailViewController()
        let pops = viewModel.dataStore.generatePopsDetailView()
        detailVC.coach = pops
        present(detailVC, animated: true, completion: nil)
    }
    
    func didSelectBabaCharacter() {
        let detailVC = CharacterDetailViewController()
        let baba = viewModel.dataStore.generateBabaDetailView()
        detailVC.coach = baba
        present(detailVC, animated: true, completion: nil)
    }
    
}

extension HomeSettingsViewController {
    
    func setupHeaderView() {
        headerView.backgroundColor = Palette.salmon.color
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (5/viewHeight)).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func setupCancelSettingsButton() {
        self.dismissIcon.setBackgroundImage(#imageLiteral(resourceName: "IC_Quit"), for: .normal)
        self.dismissIcon.alpha = 1
        self.view.addSubview(self.dismissIcon)
        self.dismissIcon.translatesAutoresizingMaskIntoConstraints = false
        self.dismissIcon.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 22).isActive = true
        self.dismissIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26).isActive = true
        self.dismissIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        self.dismissIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        self.dismissIcon.addTarget(self, action: #selector(self.dismissSettingVC), for: .touchUpInside)
    }
    
    func dismissSettingVC() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func shareBttnPressed() {
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out this beer I liked using Beer Tracker."],
            applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func contactUsBttnPressed() {
        let mailURL = NSURL(string: "mailto:makepopsproud@gmail.com")!
        
        if UIApplication.shared.canOpenURL(mailURL as URL) {
            UIApplication.shared.open(mailURL as URL)
        }
    }
}
