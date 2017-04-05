
import Foundation
import UIKit

enum Palette {
    case pink, blue, red, aqua, grey, lightGrey, white, darkHeader
    
    var color: UIColor {
        switch self {
        case .pink: return UIColor(hex: 0xFFDCE5)
        case .blue: return UIColor(hex: 0x040404)
        case .red: return UIColor(hex: 0xEB5757)
        case .aqua: return UIColor(hex: 0x4FD8D1)
        case .grey: return UIColor(hex: 0xA5A5A5)
        case .white: return UIColor(hex: 0xffffff)
        case .lightGrey: return UIColor(hex: 0xF4F4F4)
        case .darkHeader: return UIColor(hex: 0x0A0A0A)
        }
    }
}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    class func forGradient(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
}
