
import Foundation

final class PopsBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    let manager = PopsBreakManager()

    static let singleton = PopsBreakViewModel()
    private init(){}
    
    
    func letPopsGetYouAVideo(completion: @escaping (String)-> ()) {
        manager.getRandomYouTubeVideo { (videoID) in
            completion(videoID)
        }
    }
    
    
}
