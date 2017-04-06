
import Foundation

final class ChadBreakViewModel {
    
    let dataStore = DataStore.singleton
    
    static let singleton = ChadBreakViewModel()
    private init(){}
    
    let manager = ChadBreakManager()
}
