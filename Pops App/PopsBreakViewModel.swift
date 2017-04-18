
import Foundation
import CloudKit

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
                self.likedVideoIDs.append(self.manager.popsVideos[self.currentVideoIndex].id)
                self.defaults.set(self.likedVideoIDs, forKey: "likedVideoIDs")
                
                self.userDisliked = false
                self.userLiked = true
                self.manager.postLikeToCloudKit(for: self.manager.popsVideos[self.currentVideoIndex].id, likedVids: self.likedVideoIDs)
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
                self.dislikedVideoIDs.append(self.manager.popsVideos[self.currentVideoIndex].id)
                self.manager.popsVideos.remove(at: self.currentVideoIndex)
                self.defaults.set(self.dislikedVideoIDs, forKey: "dislikedVideoIDs")
                
                self.userLiked = false
                self.userDisliked = true
                self.manager.postDislikeToCloudKit(for: self.manager.popsVideos[self.currentVideoIndex].id, dislikedVids: self.dislikedVideoIDs)
                verified = true
            }
            completion(verified)
        })
    }
}
