
import UIKit

class ChadBreakView: UIView {

    //Not Being Used In Current Iteration Of Chad's Break
    //let viewModel = ChadBreakViewModel()

    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewIsBeingDismissed), name: NSNotification.Name(rawValue: "coachBreakViewIsBeingDismissed"), object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewIsBeingDismissed() {
    }
}
