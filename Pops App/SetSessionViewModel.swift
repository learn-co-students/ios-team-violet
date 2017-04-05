
import Foundation

final class SetSessionViewModel {
    
    static let singleton = SetSessionViewModel()
    let dataStore = CoachesDataStore.singleton
    let totalTimesForPicker = ["one hour", "two hours", "three hours", "four hours", "five hours", "six hours", "seven hours", "eight hours"]
    let sessionCoach: Coach!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }
 
}
