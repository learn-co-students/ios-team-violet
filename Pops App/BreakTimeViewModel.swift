
import Foundation
import UIKit

protocol BreakTimeViewModelDelegate: class {
    func moveToProductivity()
    func moveToSessionEnded()
}

protocol BreakTimeViewModelProgressBarDelegate: class {
    var progressBarWidthAnchor: NSLayoutConstraint! {get set}
}

protocol DisplayBreakTimerDelegate: class {
    var breakTimerLabel: UILabel {get set}
    var settingsTimerCounter: Int {get set}
}

final class BreakTimeViewModel {
    
    let dataStore = DataStore.singleton
    weak var delegate: BreakTimeViewModelDelegate!
    weak var progressBarDelegate: BreakTimeViewModelProgressBarDelegate!
    weak var breakTimerDelegate: DisplayBreakTimerDelegate!
    
    var breakTimer: Timer
    var breakTimerCounter: Int = 0
    var breakIsOn: Bool = false
    
    var progressBarCounter = 0.0 {
        didSet {
            progressBarDelegate.progressBarWidthAnchor.constant = CGFloat(UIScreen.main.bounds.width * CGFloat(self.progressBarCounter) )
        }
    }
        
    init(delegate: BreakTimeViewModelDelegate, progressBarDelegate: BreakTimeViewModelProgressBarDelegate){
        self.delegate = delegate
        self.progressBarDelegate = progressBarDelegate
        self.breakTimer = dataStore.user.currentSession?.productivityTimer ?? Timer()
            }
    
    func startTimer() {
        self.breakTimerCounter = dataStore.user.currentCoach.difficulty.baseBreakLength
        dataStore.defaults.set(Date(), forKey: "breakTimerStartedAt")

        breakIsOn = true
        breakTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.breakTimerAction()
        })
    }
    
    func breakTimerAction() {
        print("break timer: \(breakTimerCounter)")
        breakTimerCounter -= 1
      
        if breakTimerCounter <= 0 {
            breakIsOn = false
            breakTimer.invalidate()
            delegate.moveToProductivity()
        }
        
        if dataStore.user.currentSession!.sessionTimerCounter <= 0 {
            breakTimer.invalidate()
            dataStore.user.currentSession = nil
            delegate.moveToSessionEnded()
        }
        
        if breakTimerDelegate != nil {
            breakTimerDelegate.breakTimerLabel.text = "\(formatTime(time: breakTimerCounter)) left"
            breakTimerDelegate.settingsTimerCounter -= 1
        }
        
        progressBarCounter += 1.0 / Double(dataStore.user.currentCoach.difficulty.baseBreakLength)
    }
    
    func updateTimers() {
        let timeTimerStarted = dataStore.defaults.value(forKey: "breakTimerStartedAt") as! Date
        let timeSinceTimerStarted = Date().timeIntervalSince(timeTimerStarted)
        
        breakTimerCounter = dataStore.user.currentCoach.difficulty.baseBreakLength - Int(timeSinceTimerStarted)
        dataStore.user.currentSession?.sessionTimerCounter = dataStore.user.currentSession!.sessionTimerStartCounter - Int(timeSinceTimerStarted)
        
        progressBarCounter = timeSinceTimerStarted / Double(dataStore.user.currentCoach.difficulty.baseBreakLength)
    }
}

extension BreakTimeViewModel {
    
    //helper method
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
