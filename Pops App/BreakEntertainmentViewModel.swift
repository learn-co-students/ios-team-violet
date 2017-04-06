
import Foundation

final class BreakEntertainmentViewModel {
    
    static let singleton = BreakEntertainmentViewModel()
    let dataStore = CoachesDataStore.singleton
    let sessionCoach: Coach!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }

}
