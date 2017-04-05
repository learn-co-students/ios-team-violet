
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
            return 1800
        case .hard:
            return 28_800
        }
    }
    
    var baseProductivityLength: Double {
        switch self {
        case .easy:
            return 20.00
        case .standard:
            return 25.00
        case .hard:
            return 55.00
        }
    }
    
    var baseBreakLength: Double {
        switch self {
        case .easy:
            return 10.00
        case .standard:
            return 5.00
        case .hard:
            return 5.00
        }
    }
}
