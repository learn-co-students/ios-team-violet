
import Foundation

final class ProductiveTimeViewModel {
    
    static let singleton = ProductiveTimeViewModel()
    let dataStore = CoachesDataStore.singleton
    let sessionCoach: Coach!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }
}
