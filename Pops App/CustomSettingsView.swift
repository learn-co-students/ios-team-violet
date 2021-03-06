
import Foundation
import UIKit

class CustomSettingsView: UIButton {
    
    let iconImgView = UIImageView()
    let textLabel = UILabel()
    let arrowImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(iconImage: UIImage, text: String) {
        super.init(frame: CGRect.zero)
        self.iconImgView.image = iconImage
        self.textLabel.text = text
        setupView()
    }
    
    func setupView() {
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
        
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupIcon() {
        self.addSubview(iconImgView)
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.contentMode = .scaleAspectFill
        
        if iconImgView.image == #imageLiteral(resourceName: "IC_ContactUs") {
            iconImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            iconImgView.heightAnchor.constraint(equalToConstant: 11).isActive = true
            iconImgView.widthAnchor.constraint(equalToConstant: 11).isActive = true
            iconImgView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor, constant: 0).isActive = true
        }
        
        if iconImgView.image == #imageLiteral(resourceName: "IC_SharePops") {
            iconImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            iconImgView.heightAnchor.constraint(equalToConstant: 11).isActive = true
            iconImgView.widthAnchor.constraint(equalToConstant: 13).isActive = true
            iconImgView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor, constant: 0).isActive = true
        }
        
    }
    
    func setupArrowIcon() {
        self.addSubview(arrowImgView)
        arrowImgView.translatesAutoresizingMaskIntoConstraints = false
        arrowImgView.contentMode = .scaleAspectFit
        arrowImgView.image = #imageLiteral(resourceName: "IC_SettingsArrow")
        
        arrowImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        arrowImgView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        arrowImgView.widthAnchor.constraint(equalToConstant: 6).isActive = true
        arrowImgView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor).isActive = true
    }
}
