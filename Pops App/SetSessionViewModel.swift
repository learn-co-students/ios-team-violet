
import Foundation
import UIKit

final class SetSessionViewModel {
        
    let dataStore = DataStore.singleton
    let defaults = UserDefaults.standard
    
    let timesForCollectionView = ["1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours", "7 hours", "8 hours"]

    init(){}
    
    func startSessionOfLength(_ hours: Int) {
        let currentSession = Session(sessionHours: hours, sessionDifficulty: dataStore.user.currentCoach.difficulty)
        dataStore.user.currentSession = currentSession
    }
 
}

final class Time {
    let text: String
    let hours: Int
    var isSelected = false
    
    init(_ text: String, _ hours: Int) {
        self.text = text
        self.hours = hours
    }
}

class HourCollectionViewCell: UICollectionViewCell {
    
    let hourLabel = UILabel()
    
    var timeTwo: String! {
        didSet {
            hourLabel.text = timeTwo
            //contentView.backgroundColor = Palette.lightBlue.color
        }
    }
    
//    var time: Time! {
//        didSet {
//            hourLabel.text = time.text
//            //timeIsSelected = time.isSelected
//            contentView.backgroundColor = time.isSelected ?  Palette.darkHeader.color : Palette.lightBlue.color
//        }
//    }
//    
//    var timeIsSelected = false {
//        didSet {
//            time.isSelected = timeIsSelected
//            contentView.backgroundColor = time.isSelected ?  Palette.darkHeader.color : Palette.lightBlue.color
//        }
//    }
//    
//    func resetBackground() {
//        contentView.backgroundColor = Palette.lightBlue.color
//    }
//    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabel() {
        hourLabel.textColor = UIColor.white
        hourLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        
        contentView.addSubview(hourLabel)
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        hourLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hourLabel.text = nil
    }

}
