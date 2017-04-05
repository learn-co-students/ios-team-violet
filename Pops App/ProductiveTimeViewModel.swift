
import Foundation

final class ProductiveTimeViewModel {
    
    
    let viewController: ProductiveTimeViewController

    init(vc: ProductiveTimeViewController){
    self.viewController = vc
    }
    
    
    var timer = Timer()
    var backgroundTimer = Timer()
    
    var timerCounter = 1800 { //this keeps track of the time. think of these counters as seconds left.
        didSet {
            viewController.totalTime = timerCounter
        }
    }
    var backgroundCounter = 7200 //this is the total time.
    
    var props = 0 {
        didSet {
            viewController.props = props
        }
    }//this is the number of props
    
    var progressBarCounter = 0 
    
    func startTimers() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
           self.timerAction()
        })
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.backgroundTimerAction()
        })
        
    }
    
    func stopTimers() {
        timer.invalidate()
        backgroundTimer.invalidate()
    }
    
    func timerAction() {
        print("timer action: \(timerCounter)")
        timerCounter -= 1
        props += 1
        viewController.progress += 1
    }
    
    func backgroundTimerAction() {
        print("background timer action: \(backgroundCounter)")
        backgroundCounter -= 1
    }
    
    
}

