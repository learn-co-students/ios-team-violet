
import Foundation
import UIKit

struct CoachProfile {
    let name: String
    let icon: UIImage?
    let difficulty: String
    let bio: String
    let isUnlocked: Bool
}

extension DataStore {
    func generateChadDetailView() -> CoachProfile {
        let icon = UIImage(named: "IC_CHAD")
        let chad = CoachProfile(name: "Chad", icon: icon , difficulty: "Hard mode", bio: "With Chad you only get a 5 minute break for every 55 minutes of productivity!  During breaks, Chad coaches you on your health and fitness. Do you have what it takes to keep up with Chad?", isUnlocked: true)
        return chad
    }
    
    func generatePopsDetailView() -> CoachProfile {
        let icon = UIImage(named: "IC_POPS")
        let pops = CoachProfile(name: "Pops", icon: icon, difficulty: "Standard mode", bio: "With Pops you get a 5 minute break for every 25 minutes of productivity.  During breaks, Pops brings you the best YouTube videos you’ve forgotten about.", isUnlocked: true)
        return pops
    }
    
    func generateBabaDetailView() -> CoachProfile {
        let icon = UIImage(named: "IC_BABA")
        let baba = CoachProfile(name: "Baba", icon: icon, difficulty: "Easy mode", bio: "Baba takes it easy on you with a 10 minute break for every 20 minutes of productivity.  During break time, Baba shows you cool places in your neighborhood.", isUnlocked: true)
        return baba
    }
}
