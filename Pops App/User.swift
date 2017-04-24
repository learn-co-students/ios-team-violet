
import Foundation

struct User {
    let defaults = UserDefaults.standard
    
    let userName: String?
    var totalProps: Int {
        didSet {
            defaults.set(self.totalProps, forKey: "totalProps")
        }
    }
    let unlockedCoachNames: [String]
    let appNames: [String]
    var currentCoach: Coach
    var currentSession: Session?
}
