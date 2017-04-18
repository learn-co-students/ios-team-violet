
import Foundation
import YouTubeiOSPlayerHelper
import CloudKit

final class PopsBreakManager {
    let defaults = UserDefaults.standard
    let database = CKContainer.default().publicCloudDatabase
    
    let baseURL = "https://www.googleapis.com/youtube/v3/playlistItems?"
    let key = "key=AIzaSyB3MeDmXLwcZK6JQKoA3ffM7e16E3_9I2k"
    let part = "part=snippet"
    let playlistID = "playlistId=PLDYmkot25JsSZLwL2RqA9eWYkhZDdU0_8"
    let maxResults = "maxResults=50"
    
    var popsVideos: [Video] = []
    var dislikedVideoIDs: [String]
    
    init() {
        dislikedVideoIDs = defaults.value(forKey: "dislikedVideoIDs") as? [String] ?? []
    }

    func getRandomYouTubeVideo(completion: @escaping (String) -> ()) {
        let url = URL(string: baseURL + key + "&" + part + "&" + playlistID + "&" + maxResults)
        guard let verifiedURL = url else { completion("9bZkp7q19f0") ; return }
        let urlRequest = URLRequest(url: verifiedURL)
        let session = URLSession.shared

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let receivedData = data else { return }
            guard let receivedDict = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? [String: Any] ?? [:] else { return }
            let receivedVideos = receivedDict["items"] as? [[String: Any]] ?? [[:]]
            
            receivedVideos.forEach({ (video) in
                let snippet = video["snippet"] as? [String: Any] ?? [:]
                let resourceId = snippet["resourceId"] as? [String: Any] ?? [:]
                let id = resourceId["videoId"] as? String ?? "No Video ID"
                if self.dislikedVideoIDs.contains(id) { print("fuck \(id)"); return }
                
                let title = snippet["title"] as? String ?? "No Title"
                let capitalizedTitle = title.capitalized
                let description = snippet["description"] as? String ?? "No Description"
                let newVideo = Video(id: id, title: capitalizedTitle, description: description)
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.popsVideos.count)))
                self.popsVideos.insert(newVideo, at: randomIndex)
            })
            completion(self.popsVideos[0].id)
        }
        task.resume()
    }
    
    func verifyiCloudUser(completion: @escaping (Bool) -> ()) {
        var verified = false
        CKContainer.default().accountStatus { (accountStat, error) in
            if (accountStat == .available) {
                print("iCloud is available")
                verified = true
            }
            else {
                print("iCloud is not available")
            }
            completion(verified)
        }
    }
    
    func postLikeToCloudKit(for videoID: String, likedVids: [String]) {
        let videoRecordID = CKRecordID(recordName: videoID)
        database.fetch(withRecordID: videoRecordID) { (record, error) in
            if error != nil {
                print(error.debugDescription)
            }
            
            if let record = record {
                var currentLikes = record.value(forKey: "numLikes") as! Int
                currentLikes += 1
                record.setValue(currentLikes, forKey: "numLikes")
                self.database.save(record) { (record, error) in
                    if let error = error {
                        print(error)
                    }
                }
            }
            else {
                let video = CKRecord(recordType: "Video", recordID: videoRecordID)
                video.setValue(videoID, forKey: "videoID")
                video.setValue(1, forKey: "numLikes")
                video.setValue(0, forKey: "numDislikes")
                self.database.save(video) { (record, error) in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func postDislikeToCloudKit(for videoID: String, dislikedVids: [String]) {
        let videoRecordID = CKRecordID(recordName: videoID)
        database.fetch(withRecordID: videoRecordID) { (record, error) in
            if error != nil {
                print(error.debugDescription)
            }
            
            if let record = record {
                var currentDislikes = record.value(forKey: "numDislikes") as! Int
                currentDislikes += 1
                record.setValue(currentDislikes, forKey: "numDislikes")
                self.database.save(record) { (record, error) in
                    if let error = error {
                        print(error)
                    }
                }
            }
            else {
                let video = CKRecord(recordType: "Video", recordID: videoRecordID)
                video.setValue(videoID, forKey: "videoID")
                video.setValue(1, forKey: "numDislikes")
                video.setValue(0, forKey: "numLikes")
                self.database.save(video) { (record, error) in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
    }
}

struct Video {
    let id: String
    let title: String
    let description: String
}
