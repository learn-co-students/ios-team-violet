
import Foundation
import UIKit

struct CoachProfile {
    let name: String
    let icon: UIImage?
    let difficulty: String
    let bio: String
    let isUnlocked: Bool
}

extension DataStore {
    func generateChadDetailView() -> CoachProfile {
        let chad = CoachProfile(name: "Chad", icon: nil, difficulty: "hard", bio: "strong man", isUnlocked: true)
        return chad
    }
}
