
import Foundation
import UIKit

protocol ProductiveTimeViewModelDelegate: class {
    var productiveTimeLabel: UILabel {get set}
    var propsLabel: UILabel {get set}
    var progress: Double {get set}
}


final class ProductiveTimeViewModel {
    
    weak var delegate: ProductiveTimeViewModelDelegate!
    let dataStore = DataStore.singleton
    let defaults = UserDefaults.standard

    //timers and counters
    var productivityTimer: Timer
    var totalTimer: Timer
    
    var productivityTimerCounter: Int {
        didSet {
            delegate.productiveTimeLabel.text = formatTime(time: Int(productivityTimerCounter))
        }
    }
    
    var props: Int {
        didSet {
            delegate.propsLabel.text = "Props: \(props)"
        }
    }
    
    init(vc: ProductiveTimeViewController){
        self.delegate = vc
        self.productivityTimer = dataStore.user.currentSession?.productivityTimer ?? Timer()
        self.totalTimer = dataStore.user.currentSession?.totalTimer ?? Timer()
        self.props = dataStore.user.totalProps
        self.productivityTimerCounter = dataStore.user.currentCoach.difficulty.baseProductivityLength
        self.totalTimerCounter = (dataStore.user.currentSession?.cycles ?? 0) * (dataStore.user.currentSession?.cycleLength ?? 0)
    }
    
    var totalTimerCounter: Int
    
    var progressBarCounter = 0.0 {
        didSet {
            delegate.progress = progressBarCounter / 1500.00 //this is only for pops,
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
        defaults.set(props, forKey: "totalProps")
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

