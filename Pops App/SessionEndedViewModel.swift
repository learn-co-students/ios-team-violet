
import Foundation

final class SessionEndedViewModel {
    
    static let singleton = SessionEndedViewModel()
    let dataStore = DataStore.singleton
    
    private init(){
    }
    
}
