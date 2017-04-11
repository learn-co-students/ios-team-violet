
import Foundation
import UIKit

protocol BreakTimeViewModelDelegate: class {
    func moveToProductivity()
    func moveToSessionEnded()
}

final class BreakTimeViewModel {
    
    let dataStore = DataStore.singleton
    weak var delegate: BreakTimeViewModelDelegate!
    
    var breakTimer: Timer
    var breakTimerCounter: Int = 0
    var breakIsOn: Bool = false
        
    init(vc: BreakTimeViewModelDelegate){
        self.delegate = vc
        self.breakTimer = dataStore.user.currentSession?.productivityTimer ?? Timer()
            }
    
    func startTimer() {
        self.breakTimerCounter = dataStore.user.currentCoach.difficulty.baseBreakLength

        breakIsOn = true
        breakTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.breakTimerAction()
        })
    }
    
    func breakTimerAction() {
        print("break timer: \(breakTimerCounter)")
        breakTimerCounter -= 1
      
        if breakTimerCounter <= 0 {
            breakIsOn = false
            breakTimer.invalidate()
            delegate.moveToProductivity()
        }
        
        if dataStore.user.currentSession?.sessionTimerCounter == 0 {
            breakTimer.invalidate()
            dataStore.user.currentSession = nil
            delegate.moveToSessionEnded()
        }
    }
}
