
import Foundation

final class ChadBreakViewModel {
    
    static let singleton = ChadBreakViewModel()
    private init(){}
    
    let manager = ChadBreakManager()
}