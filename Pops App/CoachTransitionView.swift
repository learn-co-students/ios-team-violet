
import UIKit

class CoachTransitionView: UIView {
   
    lazy var viewWidth: CGFloat = self.frame.width
    lazy var viewHeight: CGFloat = self.frame.height
    let coachWindow = UIView()
    
    init() {
       super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.white
        //setupCoachWindow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCoachWindow() {
        self.addSubview(coachWindow)
        coachWindow.translatesAutoresizingMaskIntoConstraints = false
        coachWindow.backgroundColor = Palette.salmon.color
        coachWindow.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        coachWindow.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -viewHeight/5).isActive = true
        coachWindow.heightAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindow.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindow.layer.cornerRadius = 50.0
        coachWindow.layer.masksToBounds = true
    }

}
