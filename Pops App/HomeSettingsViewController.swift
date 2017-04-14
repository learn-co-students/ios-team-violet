import Foundation
import UIKit

class HomeSettingsViewController: UIViewController {
    
    lazy var viewWidth: CGFloat = self.view.frame.width  //375
    lazy var viewHeight: CGFloat = self.view.frame.height  //667
    
    var viewModel: SettingsViewModel!

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
    var stackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel()
        view.backgroundColor = UIColor.white
        setupPropsHoursView()
        setupStackView()
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
        totalPropsLabel.topAnchor.constraint(equalTo: propsHoursView.topAnchor, constant: -2).isActive = true
        totalPropsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        
        propsLabel.text = "props"
        propsLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        propsLabel.textColor = Palette.aqua.color
        propsLabel.translatesAutoresizingMaskIntoConstraints = false
        propsLabel.topAnchor.constraint(equalTo: totalPropsLabel.bottomAnchor, constant: 0).isActive = true
        propsLabel.leadingAnchor.constraint(equalTo: propsHoursView.leadingAnchor, constant: 0).isActive = true
        
        totalHoursLabel.text = "200"
        totalHoursLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        totalHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        totalHoursLabel.centerYAnchor.constraint(equalTo: totalPropsLabel.centerYAnchor, constant: 0).isActive = true
        totalHoursLabel.leadingAnchor.constraint(equalTo: propsHoursView.centerXAnchor, constant: -viewWidth * (100/667)).isActive = true
        
        hoursProductiveLabel.text = "hours being productive"
        hoursProductiveLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        hoursProductiveLabel.textColor = Palette.aqua.color
        hoursProductiveLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursProductiveLabel.centerYAnchor.constraint(equalTo: propsLabel.centerYAnchor, constant: 0).isActive = true
        hoursProductiveLabel.leadingAnchor.constraint(equalTo: totalPropsLabel.trailingAnchor, constant: 10).isActive = true
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
        
        stackView = UIStackView(arrangedSubviews: stackedViews)
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = viewHeight * (26 / 667)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: viewWidth * (300 / 375)).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
