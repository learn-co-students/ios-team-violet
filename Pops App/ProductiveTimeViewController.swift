
import UIKit

class ProductiveTimeViewController: UIViewController {

    let viewModel = ProductiveTimeViewModel.singleton
    
    let totalTime = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(totalTime)
        totalTime.translatesAutoresizingMaskIntoConstraints = false
        totalTime.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalTime.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        let backButton = UIButton(frame: frame)
        backButton.backgroundColor = UIColor.red
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
