
import Foundation
import YouTubeiOSPlayerHelper

final class PopsBreakManager {
    let defaults = UserDefaults.standard
    
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
}

struct Video {
    let id: String
    let title: String
    let description: String
}
