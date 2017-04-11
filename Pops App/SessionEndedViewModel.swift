
import Foundation

final class SessionEndedViewModel {
    
    let dataStore = DataStore.singleton
    
    init(){}
    
    func startSessionOfLength(_ hours: Int) {
        let currentSession = Session(sessionHours: hours, sessionDifficulty: dataStore.user.currentCoach.difficulty)
        dataStore.user.currentSession = currentSession
    }
}
