
import Foundation

final class ScoreboardViewModel {
    
    static let singleton = ScoreboardViewModel()
    let dataStore = DataStore.singleton
    let user: User!
    
    private init(){
        self.user = dataStore.user
    }
}
