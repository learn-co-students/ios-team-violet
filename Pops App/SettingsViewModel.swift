

import Foundation

final class SettingsViewModel {
    
    static let singleton = SettingsViewModel()
    let dataStore = DataStore.singleton
    let user: User!
    
    private init(){
        self.user = dataStore.user
    }
}
