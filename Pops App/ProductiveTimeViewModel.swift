
import Foundation
import UIKit
import CoreMotion

protocol ProductiveTimeViewModelDelegate: class {
    var productiveTimeLabel: UILabel {get set}
    var propsLabel: UILabel {get set}
    var progressBarWidthAnchor: NSLayoutConstraint! {get set}
    var characterMessageHeader: UILabel {get set}
    var characterMessageBody: UILabel {get set}
    
    func animateCancelToSkip()
    func moveToBreak()
}


final class ProductiveTimeViewModel {
    
    weak var delegate: ProductiveTimeViewModelDelegate!
    let dataStore = DataStore.singleton
    let motionManager = CMMotionManager()
    

    //timers and counters
    var productivityTimer: Timer
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
    var currentCyclePropsToScore = 0
    var currentCyclePropsScored = 0
    
    var cancelCountdown = 30
    
    var progressBarCounter = 0.0 {
        didSet {
            delegate.progressBarWidthAnchor.constant = CGFloat(UIScreen.main.bounds.width * CGFloat(self.progressBarCounter) )
        }
    }
    
    init(vc: ProductiveTimeViewController){
        self.delegate = vc
        self.productivityTimer = dataStore.user.currentSession?.productivityTimer ?? Timer()
        self.productivityTimerCounter = 0
        self.props = 0
        
        motionManager.accelerometerUpdateInterval = 0.5
    }
    
    func startTimer() {
        currentCyclePropsScored = 0
        currentCyclePropsToScore = 0
        
        motionManager.startAccelerometerUpdates()
        
        delegate.productiveTimeLabel.isHidden = false
        delegate.propsLabel.isHidden = false
        
        self.productivityTimerCounter = dataStore.user.currentCoach.difficulty.baseProductivityLength
        dataStore.defaults.set(Date(), forKey: "productivityTimerStartedAt")
        
        self.props = dataStore.user.totalProps
        
        productivityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
           self.productivityTimerAction()
        })
    }
    
    func productivityTimerAction() {
        print("productivity timer: \(productivityTimerCounter)")

        productivityTimerCounter -= 1
        
        if motionManager.accelerometerData!.acceleration.z > 0.0 {
            props += 1
            currentCyclePropsToScore += 1
        }
        
        if cancelCountdown > 0 {
            cancelCountdown -= 1
        }
        if cancelCountdown <= 25 {
            delegate.animateCancelToSkip()
        }
        
        progressBarCounter += 1.0 / Double(dataStore.user.currentCoach.difficulty.baseProductivityLength)
        
        if productivityTimerCounter <= 0 {
            productivityTimer.invalidate()
            motionManager.stopAccelerometerUpdates()
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
        
        dataStore.user.totalProps += currentCyclePropsToScore
        dataStore.user.totalProps -= dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
        
        if dataStore.user.totalProps < 0 {
            dataStore.user.totalProps = 0
            dataStore.defaults.set(dataStore.user.totalProps, forKey: "totalProps")
        }
        
        if dataStore.user.totalProps < 0 {
            dataStore.user.totalProps = 0
        }
        
        dataStore.defaults.set(dataStore.user.totalProps, forKey: "totalProps")
    }
    
    func updateTimers() {        
        let timeTimerStarted = dataStore.defaults.value(forKey: "productivityTimerStartedAt") as! Date
        let timeSinceTimerStarted = Date().timeIntervalSince(timeTimerStarted)
        
        productivityTimerCounter = dataStore.user.currentCoach.difficulty.baseProductivityLength - Int(timeSinceTimerStarted)
        
        if productivityTimerCounter <= 0 {
            productivityTimerCounter = 1
        }
        
        if productivityTimerCounter > 1 && motionManager.accelerometerData!.acceleration.z < 0.0 {
            delegate.characterMessageHeader.text = dataStore.user.currentCoach.productivityReprimands[0].header
            delegate.characterMessageBody.text = dataStore.user.currentCoach.productivityReprimands[0].body
            props -= 100
            dataStore.user.totalProps -= 100
            dataStore.defaults.set(dataStore.user.totalProps, forKey: "totalProps")
        }
        
        dataStore.user.currentSession?.sessionTimerCounter = dataStore.user.currentSession!.sessionTimerStartCounter - Int(timeSinceTimerStarted)
        
        currentCyclePropsToScore = Int(timeSinceTimerStarted) - currentCyclePropsScored
        props = dataStore.user.totalProps + currentCyclePropsToScore
        
        if props < 0 {
            props = 0
            dataStore.user.totalProps = 0
            dataStore.defaults.set(dataStore.user.totalProps, forKey: "totalProps")
        }
        
        progressBarCounter = timeSinceTimerStarted / Double(dataStore.user.currentCoach.difficulty.baseProductivityLength)
    }
}


