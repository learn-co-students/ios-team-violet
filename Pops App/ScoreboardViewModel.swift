
import Foundation

final class ScoreboardViewModel {
    
    static let singleton = ScoreboardViewModel()
    let dataStore = CoachesDataStore.singleton
    let sessionCoach: Coach!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }
}
