
import Foundation

struct User {
    let userName: String?
    let totalProps: Int
    let unlockedCoachNames: [String]
    let appNames: [String]
    var currentCoach: Coach
    var currentSession: Session?
}
