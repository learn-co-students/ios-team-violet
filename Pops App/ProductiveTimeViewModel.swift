
import Foundation

final class ProductiveTimeViewModel {
    
    let viewController: ProductiveTimeViewController
    let dataStore = DataStore.singleton

    var productivityTimer: Timer
    var totalTimer: Timer
    
    init(vc: ProductiveTimeViewController){
        self.viewController = vc
        self.productivityTimer = dataStore.user.currentSession?.productivityTimer ?? Timer()
        self.totalTimer = dataStore.user.currentSession?.totalTimer ?? Timer()
        self.productivityTimerCounter = dataStore.user.currentCoach.difficulty.baseProductivityLength
        self.totalTimerCounter = (dataStore.user.currentSession?.cycles ?? 0) * (dataStore.user.currentSession?.cycleLength ?? 0)
    }
    
    //counters: timerCounter, BackgroundCounter, progressBarCounter, props
    var productivityTimerCounter = (DifficultySetting.standard.baseProductivityLength * 60) { //this keeps track of the time. think of these counters as seconds left.
        didSet {
            viewController.totalTimeLabel.text = formatTime(time: Int(productivityTimerCounter))
        }
    }
    
    var totalTimerCounter = 7200 //we probably need a user model to store how long the session will last.
    
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
        productivityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
           self.productivityTimerAction()
        })
        totalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.totalTimerAction()
        })
        
    }
    
    func stopTimers() {
        productivityTimer.invalidate()
        totalTimer.invalidate()
    }
    
    func productivityTimerAction() {
        print("timer action: \(productivityTimerCounter)")
        productivityTimerCounter -= 1
        props += 1
        progressBarCounter += 1
    }
    
    func totalTimerAction() {
        print("background timer action: \(totalTimerCounter)")
        totalTimerCounter -= 1
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

