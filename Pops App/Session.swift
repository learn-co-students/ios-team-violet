
import Foundation

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
    
    let productivityTimer = Timer()
    let breakTimer = Timer()
    var sessionTimer = Timer()
    var sessionTimerCounter = 0

    var sessionTimerStartCounter: Int {
            return cycles * cycleLength
    }
    
    init(sessionHours: Int, sessionDifficulty: DifficultySetting) {
        self.sessionHours = sessionHours
        self.sessionDifficulty = sessionDifficulty
    }
    
    func startSessionTimer() {
        sessionTimerCounter = sessionTimerStartCounter
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
        self.sessionTimerAction()
        })
    }
    
    func sessionTimerAction() {
        print("total timer action: \(sessionTimerCounter)")
        sessionTimerCounter -= 1
        
        if sessionTimerCounter == 0 {
            sessionTimer.invalidate()
        }
    }
}