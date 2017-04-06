
import Foundation

final class SessionEndedViewModel {
    
    static let singleton = SessionEndedViewModel()
    let dataStore = DataStore.singleton
    let user: User!
    
    private init(){
        self.user = dataStore.user
    }
    
}
