
import UIKit

class SettingsViewController: UIViewController {

    let viewModel = SettingsViewModel()
    
    
    
    let containerViewOne = UIView()
    let containerViewTwo = UIView()
    
    let settingsOne = SettingsObj(icon: #imageLiteral(resourceName: "IC_ContactUs"), text: "contact us")
    let settingsTwo = SettingsObj(icon: #imageLiteral(resourceName: "IC_SharePops"), text: "share pops")
    
    let stackView = UIStackView()
    //let settingsCustomCell = CustomSettingsView(settings: <#T##SettingsObj#>, containerView: <#T##UIView#>)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        
        stackView.frame = view.frame
        
        setupContainerViewOne()
        setupContainerViewTwo()
        
    }
    
    func setupContainerViewOne() {
        stackView.addSubview(containerViewOne)
        let settingsCustomView = CustomSettingsView(settings: settingsOne, containerView: containerViewOne)
        containerViewOne.addSubview(settingsCustomView)
    }
    
    func setupContainerViewTwo() {
        stackView.addSubview(containerViewTwo)
        let settingsCustomView = CustomSettingsView(settings: settingsTwo, containerView: containerViewTwo)
        containerViewTwo.addSubview(settingsCustomView)
    }
    
    
    
    

}


















class CustomSettingsView: UIView {

    let iconImgView = UIImageView()
    let textLabel = UILabel()
    let arrowImgView = UIImageView()
    //var settingsObj: SettingsObj!
    
    init(settings: SettingsObj, containerView: UIView) {
        super.init(frame: containerView.bounds)
        iconImgView.image = settings.icon
        textLabel.text = settings.text
        arrowImgView.image = #imageLiteral(resourceName: "IC_Lock")
        setupTextLabel()
        setupIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextLabel() {
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: "AvenirHeavy", size: 13)
        textLabel.textAlignment = .left
        
        textLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        textLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        
    }
    
    func setupIcon() {
        self.addSubview(iconImgView)
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.contentMode = .scaleAspectFit
        
        iconImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        iconImgView.heightAnchor.constraint(equalTo: textLabel.heightAnchor, constant: 0).isActive = true
        iconImgView.widthAnchor.constraint(equalTo: iconImgView.heightAnchor, constant: 0).isActive = true
        iconImgView.centerYAnchor.constraint(equalTo: iconImgView.centerYAnchor, constant: 0).isActive = true
        
    }
    
    func setupArrowIcon() {
        self.addSubview(arrowImgView)
        arrowImgView.translatesAutoresizingMaskIntoConstraints = false
        arrowImgView.contentMode = .scaleAspectFit
        
        arrowImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        arrowImgView.heightAnchor.constraint(equalTo: textLabel.heightAnchor, constant: 0).isActive = true
        arrowImgView.widthAnchor.constraint(equalTo: arrowImgView.heightAnchor, multiplier: 0).isActive = true
        arrowImgView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
    }

    
    
}

struct SettingsObj {
    let icon: UIImage
    let text: String
}
