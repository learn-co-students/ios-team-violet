
import Foundation

struct User {
    let userName: String?
    let totalProps: Int
    let unlockedCoachNames: [String]
    let currentCoach: Coach
    var currentSession: Session?
}
