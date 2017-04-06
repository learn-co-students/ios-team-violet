
import Foundation

final class SetSessionViewModel {
    
    static let singleton = SetSessionViewModel()
    let dataStore = CoachesDataStore.singleton
    let defaults = UserDefaults.standard
    
    let totalTimesForPicker = ["one hour", "two hours", "three hours", "four hours", "five hours", "six hours", "seven hours", "eight hours"]
    
    let sessionCoach: Coach!
    let user: User!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
        let userName = defaults.value(forKey: "userName") as? String ?? nil
        let totalProps = defaults.value(forKey: "totalProps") as? Int ?? 0
        let unlockedCoaches = defaults.value(forKey: "unlockedCoaches") as? [String] ?? ["Pops", "Baba"]
        self.user = User(userName: userName, totalProps: totalProps, unlockedCoachNames: unlockedCoaches)
    }
 
}
