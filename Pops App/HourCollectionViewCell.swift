
import Foundation
import UIKit

class HourCollectionViewCell: UICollectionViewCell {
    
    let hourLabel = UILabel()
    
    //Gets set 1st
    var time: Time! {
        didSet {
            hourLabel.text = time.text
            timeIsSelected = time.isSelected
            contentView.backgroundColor = timeIsSelected ?  Palette.darkHeader.color : Palette.lightBlue.color
        }
    }
    
    var timeIsSelected = false {
        didSet {
            time.isSelected = timeIsSelected
            contentView.backgroundColor = timeIsSelected ?  Palette.darkHeader.color : Palette.lightBlue.color
        }
    }
    
    func deselectCell() {
        timeIsSelected = false
    }
    
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
