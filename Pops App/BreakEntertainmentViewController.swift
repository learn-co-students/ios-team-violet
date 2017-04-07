
import UIKit

class BreakEntertainmentViewController: UIViewController {

    let viewModel = BreakEntertainmentViewModel.singleton
    var breakView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakView = viewModel.dataStore.user.currentCoach.breakView
        
        self.view.addSubview(breakView)
        breakView.center = self.view.center
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
