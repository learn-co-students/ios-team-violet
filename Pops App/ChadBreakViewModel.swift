
import Foundation

final class ChadBreakViewModel {
    
    lazy var dataStore = DataStore.singleton

    static let singleton = ChadBreakViewModel()
    private init(){}
    
    let manager = ChadBreakManager()
}
