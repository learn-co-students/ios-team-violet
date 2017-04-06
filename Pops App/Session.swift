
import Foundation

struct Session {
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
    
    var cycleLength: Double {
        return sessionDifficulty.baseProductivityLength + sessionDifficulty.baseBreakLength
    }
    
}
