
import Foundation

final class BreakEntertainmentViewModel {
    
    static let singleton = BreakEntertainmentViewModel()
    let dataStore = DataStore.singleton
    let user: User!
    
    private init(){
        self.user = dataStore.user
    }

}
