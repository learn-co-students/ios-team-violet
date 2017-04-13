

import Foundation
import UIKit

protocol SettingsViewModelDelegate: class {
    var settingsTotalTimerLabel: UILabel {get set}
}

final class SettingsViewModel {
    
    let dataStore = DataStore.singleton
    
    weak var delegate: SettingsViewModelDelegate!
    
    init(vc: SettingsViewController){
        self.delegate = vc
        
    }
    
    init() {}
    
    
}

extension SettingsViewModel {
    
    //helper method
    func formatTime(time: Int) -> String {
        if time >= 3600 {
            let hours = time / 3600
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
        } else if time >= 60 {
            
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i", minutes, seconds)
            
        } else {
            let seconds = time % 60
            return String(format:"%02i", seconds)
        }
    }
}

