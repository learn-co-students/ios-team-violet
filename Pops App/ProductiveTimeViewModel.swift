
import Foundation

final class ProductiveTimeViewModel {
    
    
    let viewController: ProductiveTimeViewController
    let dataStore = CoachesDataStore.singleton

    init(vc: ProductiveTimeViewController){
    self.viewController = vc
    }
    
    var timer = Timer()
    var backgroundTimer = Timer()
    
    //counters: timerCounter, BackgroundCounter, progressBarCounter, props
    var timerCounter = (DifficultySetting.standard.baseProductivityLength * 60) { //this keeps track of the time. think of these counters as seconds left.
        didSet {
            viewController.totalTime = Int(timerCounter)
        }
    }
    var backgroundCounter = 7200 //we probably need a user model to store how long the session will last.
    
    var props = 0 {
        didSet {
            viewController.props = props
        }
    }
    
    var progressBarCounter = 0.0 {
        didSet {
            viewController.progress = progressBarCounter / 1500.00 //this is only for pops,
        }
    }
    
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
        progressBarCounter += 1
    }
    
    func backgroundTimerAction() {
        print("background timer action: \(backgroundCounter)")
        backgroundCounter -= 1
    }
    
    func formatTime(time: Int) -> String {
        if time >= 3600 {
            let hours = time / 3600
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
        } else if time >= 60 {
            
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i", minutes, seconds)
            
        } else {
            let seconds = time % 60
            return String(format:"%02i", seconds)
        }
    }

    
}

