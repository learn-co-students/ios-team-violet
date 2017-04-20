
import UIKit


class BreakEntertainmentViewController: UIViewController, BreakTimeViewModelDelegate {
    
    var dataStore = DataStore.singleton
    
    var breakView = UIView()
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentiCloudAlert), name: NSNotification.Name(rawValue: "iCloudError"), object: nil)
        
        self.view.addSubview(breakView)
        breakView.center = self.view.center
        
        setUpBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if dataStore.isInternetAvailable() != true {
            presentInternetAlert()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setUpBackButton(){
        print("name \(dataStore.user.currentCoach.name)")
        if dataStore.user.currentCoach.name == "Baba" {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Back Arrow Black"), for: .normal)
        } else {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "IC_BackButton"), for: .normal)
        }
   
        backButton.addTarget(self, action: #selector(dismissCoachBreakView), for: .touchUpInside)
        
        breakView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: breakView.leadingAnchor, constant: 25.0).isActive = true
        backButton.topAnchor.constraint(equalTo: breakView.topAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
    func moveToProductivity() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "coachBreakViewIsBeingDismissed"), object: self)
        self.present(ProductiveTimeViewController(), animated: true, completion: nil)
    }
    
    func moveToSessionEnded() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "coachBreakViewIsBeingDismissed"), object: self)
        self.present(SessionEndedViewController(), animated: true, completion: nil)
    }
    
    func dismissCoachBreakView() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "coachBreakViewIsBeingDismissed"), object: self)
        self.dismiss(animated: true)
    }
    
    func presentiCloudAlert() {
        let iCloudAlert = UIAlertController(title: "You must be signed into iCloud to use this feature.", message: "Please enable iCloud in your Settings application before proceeding.", preferredStyle: .alert)
        let iCloudAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        iCloudAlert.addAction(iCloudAction)
        self.present(iCloudAlert, animated: true, completion: nil)
    }
    
    func presentInternetAlert() {
        let internetAlert = UIAlertController(title: "Pops was unable to connect to the internet.", message: "Please check your internet settings and relaunch Pops.", preferredStyle: .alert)
        let internetAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
            internetAlert.addAction(internetAction)
        self.present(internetAlert, animated: true, completion: nil )
    }
}
