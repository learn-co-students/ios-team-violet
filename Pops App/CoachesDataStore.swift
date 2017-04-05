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
        let tapStatements = [
            ("Hey!", "Hands off, buddy!"),
            ("Hey!", "Get off of me!")
        ]
        let introStatements = [
            ("Hey there, I'm Pops!", "Make me proud by putting in a hard day's work!")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.")],
            [("Two hours.", "That's respectable.")],
            [("Three hours!", "Good for you!")],
            [("Four hours, huh?", "I'm Impressive!")],
            [("Five hours?", "You're really going for it today!")],
            [("Hmmmmm...", "As long as you take your breaks, this should be okay.")],
            [("Seven hours!", "What an odd choice!")],
            [("Dear lord!", "Don't hurt yourself, sonny!")],
        ]
        let pops = Coach(name: name, icon: icon, difficulty: difficulty, tapStatements: tapStatements, introStatements: introStatements, setSessionStatements: setSessionStatements)
        return pops
    }
    
}
