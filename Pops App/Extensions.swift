
import Foundation
import UIKit


extension String {
    
    func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        
        let nonBoldFontAttribute = [NSFontAttributeName: font!]
        let boldFontAttribute = [NSFontAttributeName: boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        
        return boldString
    }
    
}
