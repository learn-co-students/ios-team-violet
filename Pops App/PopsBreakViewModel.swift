
import Foundation

final class PopsBreakViewModel {
    
    let dataStore = DataStore.singleton
    
    static let singleton = PopsBreakViewModel()
    private init(){}
    
    let manager = PopsBreakManager()
}
