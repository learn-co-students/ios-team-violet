
import Foundation
import UIKit


final class Session {
    let sessionHours: Int
    let sessionDifficulty: DifficultySetting
    
    var cycles: Int {
        switch sessionDifficulty {
        case .easy, .standard:
            return sessionHours * 2
        case .hard:
            return sessionHours
        }
    }
    
    var cycleLength: Int {
        return sessionDifficulty.baseProductivityLength + sessionDifficulty.baseBreakLength
    }
    
    var cyclesRemaining = 0
    
    var productivityTimer = Timer()
    var breakTimer = Timer()
   
    var sessionTimer = Timer()
    var sessionTimerCounter = 0
    var sessionTimerStartCounter: Int {
            return cycles * cycleLength
    }
    
    init(sessionHours: Int, sessionDifficulty: DifficultySetting) {
        self.sessionHours = sessionHours
        self.sessionDifficulty = sessionDifficulty
        self.cyclesRemaining = cycles
        self.sessionTimerCounter = sessionTimerStartCounter
    }
    
    func startSessionTimer() {
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
        self.sessionTimerAction()
        })
    }
    
    func sessionTimerAction() {
        sessionTimerCounter -= 1
        print("total timer action: \(sessionTimerCounter)")
        
        if sessionTimerCounter <= 0 {
            sessionTimer.invalidate()
        }
        
    }
}
