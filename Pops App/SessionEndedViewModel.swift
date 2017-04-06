
import Foundation

final class SessionEndedViewModel {
    
    static let singleton = SessionEndedViewModel()
    let dataStore = CoachesDataStore.singleton
    let sessionCoach: Coach!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }
    
}
