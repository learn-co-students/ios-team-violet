
import Foundation
import UIKit

class CustomSettingsView: UIView {
    
    let iconImgView = UIImageView()
    let textLabel = UILabel()
    let arrowImgView = UIImageView()
    var settings: SettingsObj! {
        didSet {
            setupView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(settings: SettingsObj) {
        self.settings = settings
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    func setupView() {
        iconImgView.image = settings.icon
        textLabel.text = settings.text
        setupTextLabel()
        setupIcon()
        setupArrowIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextLabel() {
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        textLabel.textAlignment = .left
        
        textLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        textLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupIcon() {
        self.addSubview(iconImgView)
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.contentMode = .scaleAspectFit
        
        iconImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        iconImgView.heightAnchor.constraint(equalTo: textLabel.heightAnchor, constant: 0).isActive = true
        iconImgView.widthAnchor.constraint(equalTo: iconImgView.heightAnchor, constant: 0).isActive = true
        iconImgView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor, constant: 0).isActive = true
        
    }
    
    func setupArrowIcon() {
        self.addSubview(arrowImgView)
        arrowImgView.translatesAutoresizingMaskIntoConstraints = false
        arrowImgView.contentMode = .scaleAspectFit
        arrowImgView.image = #imageLiteral(resourceName: "IC_ContactUs")
        
        arrowImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        arrowImgView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        arrowImgView.widthAnchor.constraint(equalTo: arrowImgView.heightAnchor, multiplier: 1).isActive = true
        arrowImgView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
    }
}
