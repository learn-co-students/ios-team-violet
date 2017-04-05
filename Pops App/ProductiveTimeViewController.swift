
import UIKit

class ProductiveTimeViewController: UIViewController {

    let viewModel = ProductiveTimeViewModel.singleton
    
    let totalTime = UILabel()
    let popsWindowView = UIView()
    let pepTalkLabel = UILabel()
    let popsIcon = UIImageView()
    
    
    
    
    override func viewDidLoad() { //remember to call the setup function here!
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupPopsWindow()
        setupPopsIcon()
//        view.addSubview(totalTime)
//        totalTime.translatesAutoresizingMaskIntoConstraints = false
//        totalTime.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        totalTime.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        let backButton = UIButton(frame: frame)
        backButton.backgroundColor = UIColor.red
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupPopsWindow() {
        view.addSubview(popsWindowView)
        popsWindowView.translatesAutoresizingMaskIntoConstraints = false
        popsWindowView.backgroundColor = Palette.salmon.color
        popsWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        popsWindowView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        popsWindowView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        popsWindowView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        popsWindowView.layer.cornerRadius = 100.0
        popsWindowView.layer.masksToBounds = true
        
    }
    
    func setupPopsIcon() {
        popsIcon.image = UIImage(named: "IC_POPS")
        popsIcon.contentMode = .scaleAspectFit
        
        popsWindowView.addSubview(popsIcon)
        popsIcon.translatesAutoresizingMaskIntoConstraints = false
        popsIcon.backgroundColor = UIColor.clear
        popsIcon.bottomAnchor.constraint(equalTo: popsWindowView.bottomAnchor, constant: 20).isActive = true
        popsIcon.centerXAnchor.constraint(equalTo: popsWindowView.centerXAnchor, constant: 0).isActive = true
        popsIcon.heightAnchor.constraint(equalToConstant: 170).isActive = true
        popsIcon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        popsIcon.layer.masksToBounds = true
        
    }
    
    func setupPepTalkLabel() {
        view.addSubview(pepTalkLabel)
        pepTalkLabel.translatesAutoresizingMaskIntoConstraints = false
        pepTalkLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        pepTalkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
    }

}
