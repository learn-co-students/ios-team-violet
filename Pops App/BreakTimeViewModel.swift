
import Foundation
import UIKit

final class BreakTimeViewModel {
    
    static let singleton = BreakTimeViewModel()
    
    let dataStore = CoachesDataStore.singleton
    
    let sessionCoach: Coach!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }
    
}
