
import Foundation

final class BabaBreakViewModel {
    
    let dataStore = DataStore.singleton
    
    static let singleton = BabaBreakViewModel()
    private init(){}
    
    let manager = BabaBreakManager()
}
