
import Foundation

enum DifficultySetting {
    case easy
    case standard
    case hard
    
    var basePropsPerMinute: Int {
        switch self {
        case .easy:
            return 30
        case .standard:
            return 60
        case .hard:
            return 90
        }
    }
    
    var basePenaltyForLeavingProductivityScreen: Int {
        switch self {
        case .easy:
            return 0
        case .standard:
            return 500
        case .hard:
            return 5000
        }
    }
    
    var baseProductivityLength: Int {
        switch self {
        case .easy:
            return 1200
        case .standard:
            return 1500
        case .hard:
            return 3300
        }
    }
    
    var baseBreakLength: Int {
        switch self {
        case .easy:
            return 600
        case .standard:
            return 300
        case .hard:
            return 300
        }
    }
}
