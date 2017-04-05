import Foundation
import UIKit

final class CoachesDataStore {
    
    static let singleton = CoachesDataStore()
    let defaults = UserDefaults.standard
    private init(){}
    
    func getCurrentCoach() -> Coach {
        let coachName = defaults.value(forKey: "coachName") as? String ?? "Pops"
        let currentCoach = generateCoachFrom(name: coachName)
        return currentCoach
    }
    
    private func generateCoachFrom(name coachName: String) -> Coach {
        switch coachName {
        case "Pops":
            return generatePops()
        default:
            return generatePops()
        }
    }
    
    private func generatePops() -> Coach {
        let name = "Pops"
        let icon = UIImage(named: "IC_POPS")
        let difficulty = DifficultySetting.standard
        let tapStatement = "Hands off, pal!"
        let setSessionStatements = [
            "Only an hour?",
            "Two hours is respectable.",
            "Three hours, good for you!",
            "Impressive!",
            "You're really going for it today, huh?",
            "As long as you take your breaks, this should be doable.",
            "Seven hours, what an odd choice.",
            "Don't hurt yourself, sonny.",
        ]
        let pops = Coach(name: name, icon: icon, difficulty: difficulty, tapStatement: tapStatement, setSessionStatements: setSessionStatements)
        return pops
    }
    
}
