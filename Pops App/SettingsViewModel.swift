

import Foundation

final class SettingsViewModel {
    
    static let singleton = SettingsViewModel()
    let dataStore = CoachesDataStore.singleton
    let sessionCoach: Coach!
    
    private init(){
        self.sessionCoach = dataStore.getCurrentCoach()
    }
}
