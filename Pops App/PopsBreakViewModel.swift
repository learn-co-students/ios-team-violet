
import Foundation

final class PopsBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    let manager = PopsBreakManager()
    let defaults = UserDefaults.standard
    
    var currentVideoIndex = 0
    
    var likedVideoIDs: [String]
    var dislikedVideoIDs: [String]
    
    var userLiked = false
    var userDisliked = false
    
    init(){
        likedVideoIDs = defaults.value(forKey: "likedVideoIDs") as? [String] ?? []
        dislikedVideoIDs = defaults.value(forKey: "dislikedVideoIDs") as? [String] ?? []
    }
    
    func letPopsGetYouAVideo(completion: @escaping (String)-> ()) {
        manager.getRandomYouTubeVideo { (videoID) in
            completion(videoID)
        }
    }
    
    func letPopsGetYouADifferentVideo() -> Int {
        if userLiked == true {
            likedVideoIDs.append(manager.popsVideos[currentVideoIndex].id)
            defaults.set(likedVideoIDs, forKey: "likedVideoIDs")
        }
        
        if userDisliked == true {
            dislikedVideoIDs.append(manager.popsVideos[currentVideoIndex].id)
            manager.popsVideos.remove(at: currentVideoIndex)
            defaults.set(dislikedVideoIDs, forKey: "dislikedVideoIDs")
        }
        
        currentVideoIndex += 1
        
        if currentVideoIndex == manager.popsVideos.count {
            currentVideoIndex = 0
        }
        
        return currentVideoIndex
    }
    
    func userLikedVideo(completion: @escaping (Bool) -> ()) {
        if userLiked == true {
            return
        }
        
        var verified = false
        manager.verifyiCloudUser(completion: { (isVerified) in
            if isVerified {
                self.userDisliked = false
                self.userLiked = true
                self.manager.postLikeToCloudKit()
                verified = true
            }
            completion(verified)
        })
    }
    
    func userDislikedVideo(completion: @escaping (Bool) -> ()) {
        if userDisliked == true {
            return
        }
        
        var verified = false
        manager.verifyiCloudUser(completion: { (isVerified) in
            if isVerified {
                self.userLiked = false
                self.userDisliked = true
                self.manager.postDislikeToCloudKit()
                verified = true
            }
            completion(verified)
        })
    }
}
