

import Foundation

final class SettingsViewModel {
    
    static let singleton = SettingsViewModel()
    let dataStore = DataStore.singleton
    
    private init(){
    }
}
