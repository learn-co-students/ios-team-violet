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
    let popsCharacterView = UIView()
    let chadCharacterView = UIView()
    let babaCharacterView = UIView()
    
    let checkIcon = UIImageView()
    
    var currentlySelectedCharacter: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupPropsHoursView()
        setupStackView()
        setupCharacterViews()
        
        let usersCurrentCoach = viewModel.dataStore.user.currentCoach.name
        
        switch usersCurrentCoach {
        case "Pops":
            popsCharacterView.backgroundColor = Palette.salmon.color
            checkIcon.image = UIImage(named: "IC_CheckMark")
            
            view.addSubview(checkIcon)
            checkIcon.translatesAutoresizingMaskIntoConstraints = false
            checkIcon.widthAnchor.constraint(equalToConstant: viewWidth * (25/375)).isActive = true
            checkIcon.heightAnchor.constraint(equalToConstant: viewHeight * (25/667)).isActive = true
            checkIcon.trailingAnchor.constraint(equalTo: popsCharacterView.trailingAnchor).isActive = true
            checkIcon.topAnchor.constraint(equalTo: popsCharacterView.topAnchor).isActive = true
            
            currentlySelectedCharacter = popsCharacterView
            
        case "chad":
            chadCharacterView.backgroundColor = Palette.salmon.color
            
            currentlySelectedCharacter = chadCharacterView
        case "Baba":
            babaCharacterView.backgroundColor = Palette.salmon.color
            
            currentlySelectedCharacter = babaCharacterView
        default:
            popsCharacterView.backgroundColor = Palette.lightGrey.color
            chadCharacterView.backgroundColor = Palette.lightGrey.color
            babaCharacterView.backgroundColor = Palette.lightGrey.color
        }
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
        settingsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupCharacterViews() {
     
        //let popsGesture = UITapGestureRecognizer(target: self, action: #selector(self.openMessagesApp))
        //popsCharacterView.addGestureRecognizer(popsGesture)
        popsCharacterView.backgroundColor = Palette.lightGrey.color
        
        let popsImageView = UIImageView()
        popsImageView.image = UIImage(named: "IC_POPS")
        popsCharacterView.addSubview(popsImageView)
        popsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        popsImageView.widthAnchor.constraint(equalToConstant: viewWidth * (52/375)).isActive = true
        popsImageView.heightAnchor.constraint(equalToConstant: viewHeight * (80/667)).isActive = true
        popsImageView.bottomAnchor.constraint(equalTo: popsCharacterView.bottomAnchor, constant: 10).isActive = true
        popsImageView.centerXAnchor.constraint(equalTo: popsCharacterView.centerXAnchor).isActive = true
        
        
        let chadGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectChadCharacter))
        chadCharacterView.addGestureRecognizer(chadGesture)
        chadCharacterView.backgroundColor = Palette.lightGrey.color
        
//        let emailIconView = UIImageView()
//        emailIconView.image = UIImage(named: "IC_emailApp")
//        emailApp.addSubview(emailIconView)
//        emailIconView.translatesAutoresizingMaskIntoConstraints = false
//        emailIconView.widthAnchor.constraint(equalToConstant: viewWidth * (23/375)).isActive = true
//        emailIconView.heightAnchor.constraint(equalToConstant: viewWidth * (20/375)).isActive = true
//        emailIconView.centerYAnchor.constraint(equalTo: emailApp.centerYAnchor).isActive = true
//        emailIconView.centerXAnchor.constraint(equalTo: emailApp.centerXAnchor).isActive = true
        
        
//        let facebookGesture = UITapGestureRecognizer(target: self, action: #selector(self.openFacebookApp))
//        facebookApp.addGestureRecognizer(facebookGesture)
//        facebookApp.tag = 3
        babaCharacterView.backgroundColor = Palette.lightGrey.color
        
//        let facebookIconView = UIImageView()
//        facebookIconView.image = UIImage(named: "IC_facebookApp")
//        facebookApp.addSubview(facebookIconView)
//        facebookIconView.translatesAutoresizingMaskIntoConstraints = false
//        facebookIconView.widthAnchor.constraint(equalToConstant: viewWidth * (13/375)).isActive = true
//        facebookIconView.heightAnchor.constraint(equalToConstant: viewWidth * (21/375)).isActive = true
//        facebookIconView.centerYAnchor.constraint(equalTo: facebookApp.centerYAnchor).isActive = true
//        facebookIconView.centerXAnchor.constraint(equalTo: facebookApp.centerXAnchor).isActive = true
        
        let apps = [popsCharacterView, chadCharacterView, babaCharacterView]
        
        apps.forEach { (app) in
            app.translatesAutoresizingMaskIntoConstraints = false
            app.heightAnchor.constraint(equalToConstant: viewWidth * (86/375)).isActive = true
            app.widthAnchor.constraint(equalToConstant: viewWidth * (86/375)).isActive = true
            app.layer.cornerRadius = (viewWidth * (86/375)) / 2
            app.layer.masksToBounds = true
        }
        
        let stackView = UIStackView(arrangedSubviews: apps)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: settingsStackView.topAnchor, constant: -20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func didSelectChadCharacter() {
        
        let detailVC = CharacterDetailViewController()
        let chad = viewModel.dataStore.generateChadDetailView()
        detailVC.coach = chad
        present(detailVC, animated: true, completion: {
            self.view.removeFromSuperview()
        })
    }
    
}
