
import Foundation

final class PopsBreakViewModel {
    
    static let singleton = PopsBreakViewModel()
    private init(){}
    
    let manager = PopsBreakManager()
}
