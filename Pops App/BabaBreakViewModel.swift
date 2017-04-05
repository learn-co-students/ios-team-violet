
import Foundation

final class BabaBreakViewModel {
    
    static let singleton = BabaBreakViewModel()
    private init(){}
    
    let manager = BabaBreakManager()
}
