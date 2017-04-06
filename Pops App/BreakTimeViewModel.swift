
import Foundation
import UIKit

final class BreakTimeViewModel {
    
    static let singleton = BreakTimeViewModel()
    let dataStore = DataStore.singleton
    let user: User!
    
    private init(){
        self.user = dataStore.user
    }
    
}
