
import Foundation
import UIKit

struct Coach {
    let name: String
    let icon: UIImage?
    let difficulty: DifficultySetting
    let tapStatements: [(header: String, body:String)]
    let introStatements: [(header: String, body: String)]
    let setSessionStatements: [[(header: String, body: String)]]
}
