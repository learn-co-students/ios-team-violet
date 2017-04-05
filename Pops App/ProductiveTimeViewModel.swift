
import Foundation

final class ProductiveTimeViewModel {
    
    static let singleton = ProductiveTimeViewModel()
    private init(){}
    
    let viewController = ProductiveTimeViewController()
    
    var timer = Timer()
    var backgroundTimer = Timer()
    
    func startTimers() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        backgroundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.backgroundTimerAction), userInfo: nil, repeats: true)
        
    }
    
    @objc func timerAction() {
        print("timer action 1 count")
    }
    
    @objc func backgroundTimerAction() {
        print("background timer action 1 count")
    }
    
    
}
