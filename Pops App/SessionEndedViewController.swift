
import UIKit

class SessionEndedViewController: UIViewController {

    let viewModel = SessionEndedViewModel()
    
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    
    let doneButton = UIButton()
    let extendHourButton = UIButton()
    let lineDividerView = UIView()
    let characterMessageHeader = UILabel()
    let characterMessageBody = UILabel()
    
    let popsWindowView = UIView()
    let popsIcon = UIImageView()
    
    let headerView = UIView()
    
    var popsBottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePopsPopup()
    }
    
    func setupDoneButton() {
        doneButton.backgroundColor = Palette.lightBlue.color
        doneButton.layer.cornerRadius = 2.0
        doneButton.layer.masksToBounds = true
        doneButton.setTitle("extend for 1 hour", for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        doneButton.addTarget(self, action: #selector(presentSetSesssionVC), for: .touchUpInside)
        
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        doneButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewHeight * (150/667.0)).isActive = true
    }
    
    func presentSetSesssionVC() {
        let setSesssionVC = ProductiveTimeViewController()
        present(setSesssionVC, animated: true, completion: nil)
    }
    
    func setupExtendHourButton() {
        extendHourButton.backgroundColor = Palette.lightBlue.color
        extendHourButton.layer.cornerRadius = 2.0
        extendHourButton.layer.masksToBounds = true
        extendHourButton.setTitle("extend for 1 hour", for: .normal)
        extendHourButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        extendHourButton.addTarget(self, action: #selector(presentProductiveTimeVC), for: .touchUpInside)
        
        view.addSubview(extendHourButton)
        extendHourButton.translatesAutoresizingMaskIntoConstraints = false
        extendHourButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extendHourButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        extendHourButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        extendHourButton.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -viewHeight * (15/667.0)).isActive = true
    }
    
    func presentProductiveTimeVC() {
        let productiveTimeVC = ProductiveTimeViewController()
        present(productiveTimeVC, animated: true, completion: nil)
    }
    
    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        view.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineDividerView.bottomAnchor.constraint(equalTo: extendHourButton.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
    
    func setupCharacterMessageBody() {
        characterMessageBody.numberOfLines = 0
        characterMessageBody.textColor = Palette.grey.color
        characterMessageBody.textAlignment = .left
        characterMessageBody.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        characterMessageBody.text = "Wanna make me super proud and extend your productivity for another hour?"
        
        view.addSubview(characterMessageBody)
        characterMessageBody.translatesAutoresizingMaskIntoConstraints = false
        characterMessageBody.bottomAnchor.constraint(equalTo: lineDividerView.topAnchor, constant: -viewHeight * (20/viewHeight)).isActive = true
        characterMessageBody.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
        characterMessageBody.trailingAnchor.constraint(equalTo: lineDividerView.trailingAnchor).isActive = true
    }
    
    func setupCharacterMessageHeader() {
        characterMessageHeader.numberOfLines = 0
        characterMessageHeader.textColor = UIColor.black
        characterMessageHeader.textAlignment = .left
        characterMessageHeader.font = UIFont(name: "Avenir-Black", size: 14.0)
        characterMessageHeader.text = "Woah 2 hours went by fast!"
        
        view.addSubview(characterMessageHeader)
        characterMessageHeader.translatesAutoresizingMaskIntoConstraints = false
        characterMessageHeader.bottomAnchor.constraint(equalTo: characterMessageBody.topAnchor, constant: -viewHeight * (5/viewHeight)).isActive = true
        characterMessageHeader.leadingAnchor.constraint(equalTo: characterMessageBody.leadingAnchor).isActive = true
        characterMessageHeader.trailingAnchor.constraint(equalTo: characterMessageBody.trailingAnchor).isActive = true
    }
    
    func setupPopsWindow() {
        view.addSubview(popsWindowView)
        popsWindowView.translatesAutoresizingMaskIntoConstraints = false
        popsWindowView.backgroundColor = Palette.salmon.color
        popsWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popsWindowView.bottomAnchor.constraint(equalTo: characterMessageHeader.topAnchor, constant: -viewHeight * (40/667)).isActive = true
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
    
    func setupHeaderView() {
        headerView.backgroundColor = Palette.salmon.color
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (5/viewHeight)).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func animatePopsPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.popsBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }

}
