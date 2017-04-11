
import Foundation
import UIKit

final class SetSessionViewModel {
        
    let dataStore = DataStore.singleton
    
    let timesForCollectionView = [Time("1 hour"), Time("2 hours"), Time("3 hours"), Time("4 hours"), Time("5 hours"), Time("6 hours"), Time("7 hours"), Time("8 hours")]

    init(){}
    
    func startSessionOfLength(_ hours: Int) {
        let currentSession = Session(sessionHours: hours, sessionDifficulty: dataStore.user.currentCoach.difficulty)
        dataStore.user.currentSession = currentSession
    }
 
}



