
import Foundation

final class BabaBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    
    static let singleton = BabaBreakViewModel()
    private init(){}
    
    let manager = BabaBreakManager()
}
