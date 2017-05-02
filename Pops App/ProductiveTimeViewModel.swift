
import Foundation
import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation

protocol ProductiveTimeViewModelDelegate: class {
    var productiveTimeLabel: UILabel {get set}
    var propsLabel: UILabel {get set}
    var progressBarWidthAnchor: NSLayoutConstraint! {get set}
    var characterMessageHeader: UILabel {get set}
    var characterMessageBody: UILabel {get set}
    
    func animateCancelToWeak()
    func moveToBreak()
}


final class ProductiveTimeViewModel {
    
    weak var delegate: ProductiveTimeViewModelDelegate!
    let dataStore = DataStore.singleton
    let motionManager = CMMotionManager()
    
    //timers and counters
    var sessionTimeRemaining: Int = 0
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
    
    var userWasPenalized = false
    
    init(vc: ProductiveTimeViewController){
        self.delegate = vc
        self.productivityTimer = dataStore.user.currentSession?.productivityTimer ?? Timer()
        self.productivityTimerCounter = 0
        self.props = 0
        
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates()
    }
    
    func startTimer() {
        currentCyclePropsScored = 0
        currentCyclePropsToScore = 0
        
        motionManager.startAccelerometerUpdates()
        
        delegate.productiveTimeLabel.isHidden = false
        delegate.propsLabel.isHidden = false
        
        dataStore.user.currentSession?.sessionTimer.invalidate()
        dataStore.user.currentSession?.sessionTimerCounter = dataStore.user.currentSession!.cycleLength * dataStore.user.currentSession!.cyclesRemaining
        sessionTimeRemaining = dataStore.user.currentSession!.sessionTimerCounter
        
        self.productivityTimerCounter = dataStore.user.currentCoach.difficulty.baseProductivityLength
        dataStore.defaults.set(Date(), forKey: "productivityTimerStartedAt")
        
        self.props = dataStore.user.totalProps
        
        productivityTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
           self.productivityTimerAction()
        })
        dataStore.user.currentSession?.startSessionTimer()
        
    }
    
    func productivityTimerAction() {

        productivityTimerCounter -= 1
        print("productivity timer: \(productivityTimerCounter)")
        
        if motionManager.accelerometerData!.acceleration.z > 0.25 {
            props += 1
            dataStore.user.totalProps += 1
            currentCyclePropsToScore += 1
            delegate.characterMessageHeader.text = dataStore.user.currentCoach.productivityStatements[0].header
            delegate.characterMessageBody.text = dataStore.user.currentCoach.productivityStatements[0].body
            userWasPenalized = false
            UIScreen.main.brightness = 0.01
        }
        
        if motionManager.accelerometerData!.acceleration.z < 0.25 {
            UIScreen.main.brightness = 0.75
        }
        
        if motionManager.accelerometerData!.acceleration.z < 0.25 &&
            productivityTimerCounter > 65 &&
            productivityTimerCounter < (dataStore.user.currentCoach.difficulty.baseProductivityLength - 60) &&
            userWasPenalized == false {
            
            delegate.characterMessageHeader.text = dataStore.user.currentCoach.productivityReprimands[0].header
            delegate.characterMessageBody.text = dataStore.user.currentCoach.productivityReprimands[0].body
            
            props -= dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
            dataStore.user.totalProps -= dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
            
            if dataStore.user.totalProps < 0 {
                props = 0
                dataStore.user.totalProps = 0
            }
            
            userWasPenalized = true
        }
        
        if cancelCountdown > 0 {
            cancelCountdown -= 1
        }
        
        if cancelCountdown <= 25 {
            delegate.animateCancelToWeak()
        }
        
        progressBarCounter += 1.0 / Double(dataStore.user.currentCoach.difficulty.baseProductivityLength)
        
        if (60...65).contains(productivityTimerCounter) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            toggleTorch(on: true)
            toggleTorch(on: false)
            toggleTorch(on: true)
            toggleTorch(on: false)
        }
        
        if productivityTimerCounter <= 65 {
            delegate.characterMessageHeader.text = "It's almost break time!"
            delegate.characterMessageBody.text = "Wrap up your final thoughts, your break will start in less than 1 minute."
        }
        
        if productivityTimerCounter <= 0 {
            productivityTimer.invalidate()
            motionManager.stopAccelerometerUpdates()
            delegate.moveToBreak()
        }
    }
    
    func toggleTorch(on: Bool) {
        
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
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
        propsPenalty()
    }
    
    func propsPenalty() {
        dataStore.user.totalProps += currentCyclePropsToScore
        dataStore.user.totalProps -= dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
        
        if dataStore.user.totalProps < 0 {
            props = 0
            dataStore.user.totalProps = 0
        }
    }
    
    func updateTimers() {
        
        let timeTimerStarted = dataStore.defaults.value(forKey: "productivityTimerStartedAt") as! Date
        let timeSinceTimerStarted = Date().timeIntervalSince(timeTimerStarted)
        
        productivityTimerCounter = dataStore.user.currentCoach.difficulty.baseProductivityLength - Int(timeSinceTimerStarted)
        
        if productivityTimerCounter <= 0 {
            productivityTimerCounter = 1
        }
        
        if productivityTimerCounter > 1 && motionManager.accelerometerData!.acceleration.z < 0.0 {
            
            if !(dataStore.user.currentSession?.mightCancelSession)! {
                delegate.characterMessageHeader.text = dataStore.user.currentCoach.productivityReprimands[0].header
                delegate.characterMessageBody.text = dataStore.user.currentCoach.productivityReprimands[0].body
                
                props -= dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
                dataStore.user.totalProps -= dataStore.user.currentCoach.difficulty.basePenaltyForLeavingProductivityScreen
            }
            
        }
        
        dataStore.user.currentSession?.sessionTimerCounter = sessionTimeRemaining - Int(timeSinceTimerStarted)
        
        currentCyclePropsToScore = Int(timeSinceTimerStarted) - currentCyclePropsScored
        dataStore.user.totalProps += currentCyclePropsToScore
        props = dataStore.user.totalProps
        currentCyclePropsScored += currentCyclePropsToScore
        currentCyclePropsToScore = 0
        
        
        if props < 0 {
            props = 0
            dataStore.user.totalProps = 0
        }
        
        progressBarCounter = timeSinceTimerStarted / Double(dataStore.user.currentCoach.difficulty.baseProductivityLength)
    }
}


