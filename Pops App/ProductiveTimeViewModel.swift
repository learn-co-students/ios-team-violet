
import Foundation
import UIKit

protocol ProductiveTimeViewModelDelegate: class {
    var productiveTimeLabel: UILabel {get set}
    var propsLabel: UILabel {get set}
    var progress: Double {get set}
    
    func animateCancelToSkip()
    func moveToBreak()
}


final class ProductiveTimeViewModel {
    
    weak var delegate: ProductiveTimeViewModelDelegate!
    let dataStore = DataStore.singleton
    let defaults = UserDefaults.standard

    //timers and counters
    var productivityTimer: Timer
    var productivityTimerCounter: Int = 0 {
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
        self.props = dataStore.user.totalProps
    }
        
    var progressBarCounter = 0.0 {
        didSet {
            delegate.progress = progressBarCounter / 1500.00 //this is only for standard difficulty.
        }
    }
    
    func startTimer() {
        self.productivityTimerCounter = dataStore.user.currentCoach.difficulty.baseProductivityLength

        productivityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
           self.productivityTimerAction()
        })
    }
    
    func productivityTimerAction() {
        print("productivity timer: \(productivityTimerCounter)")
        productivityTimerCounter -= 1
        props += 1
        defaults.set(props, forKey: "totalProps")
        
        progressBarCounter += 1
        if progressBarCounter == 5 {
            delegate.animateCancelToSkip()
        }
        
        if productivityTimerCounter == 0 {
            productivityTimer.invalidate()
            delegate.moveToBreak()
        }
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
        
    func skipToBreak() {
        productivityTimer.invalidate()
        dataStore.user.currentSession?.sessionTimerCounter -= productivityTimerCounter
        dataStore.user.totalProps -= dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
        defaults.set(dataStore.user.totalProps, forKey: "totalProps")
    }
}

