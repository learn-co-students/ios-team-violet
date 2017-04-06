
import UIKit

class BreakTimeViewController: UIViewController {

    let viewModel = BreakTimeViewModel.singleton
    
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    lazy var itemWidth: CGFloat = self.view.frame.width * (269/self.view.frame.width)
    lazy var itemHeight: CGFloat = self.view.frame.height * (45/self.view.frame.height)
    
    let entertainMeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupEntertainMeButton()
    }
    
    func presentBreakEntertainmentVC() {
        let breakEntertainmentVC = BreakEntertainmentViewController()
        present(breakEntertainmentVC, animated: true, completion: nil)
    }
    
    func setupEntertainMeButton() {
        entertainMeButton.backgroundColor = Palette.aqua.color
        entertainMeButton.layer.cornerRadius = 2.0
        entertainMeButton.layer.masksToBounds = true
        entertainMeButton.setTitle("entertain me", for: .normal)
        entertainMeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        entertainMeButton.addTarget(self, action: #selector(presentBreakEntertainmentVC), for: .touchUpInside)
        
        view.addSubview(entertainMeButton)
        entertainMeButton.translatesAutoresizingMaskIntoConstraints = false
        entertainMeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        entertainMeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        entertainMeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        entertainMeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewHeight * (149.0/667.0)).isActive = true
    }
    
    

}
