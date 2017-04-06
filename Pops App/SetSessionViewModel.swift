
import Foundation

final class SetSessionViewModel {
    
    static let singleton = SetSessionViewModel()
    let dataStore = CoachesDataStore.singleton
    let defaults = UserDefaults.standard
    
    let totalTimesForPicker = ["one hour", "two hours", "three hours", "four hours", "five hours", "six hours", "seven hours", "eight hours"]
    
    var user: User!
    
    private init(){
        let userName = defaults.value(forKey: "userName") as? String ?? nil
        let totalProps = defaults.value(forKey: "totalProps") as? Int ?? 0
        let unlockedCoaches = defaults.value(forKey: "unlockedCoaches") as? [String] ?? ["Pops", "Baba"]
        let currentCoach = dataStore.getCurrentCoach()
        self.user = User(userName: userName, totalProps: totalProps, unlockedCoachNames: unlockedCoaches, currentCoach: currentCoach, currentSession: nil)
    }
    
    func startSessionOfLength(_ hours: Int) {
        let currentSession = Session(sessionHours: hours, sessionDifficulty: user.currentCoach.difficulty)
        user.currentSession = currentSession
    }
 
}
