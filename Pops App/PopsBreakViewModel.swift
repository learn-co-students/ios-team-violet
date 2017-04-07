
import Foundation

final class PopsBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    let manager = PopsBreakManager()

    init(){}
    
    
    func letPopsGetYouAVideo(completion: @escaping (String)-> ()) {
        manager.getRandomYouTubeVideo { (videoID) in
            completion(videoID)
        }
    }
    
    
}
