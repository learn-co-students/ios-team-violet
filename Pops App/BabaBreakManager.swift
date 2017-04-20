
import Foundation
import UIKit

final class BabaBreakManager {
    
    class func search(searchTerm: String, latitude: Double, longitude: Double, completion: @escaping ([String: Any]) -> Void ) {
        var urlString = "https://api.yelp.com/v3/businesses/search?"
        //add parameters, term, longitude, latitude, max numes
        urlString += ("term=" + searchTerm)
        urlString += ("&latitude=" + "\(latitude)")
        urlString += ("&longitude=" + "\(longitude)")
        urlString += ("&limit=5")
        //print("this is the url", urlString)
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { return }
        var request = URLRequest(url: unwrappedURL)
        request.addValue("Bearer FY7uBD8m9o5b94wkg9iDli0-6e7Ongpqxusqh0sa1Klfa0Oi66SPHKQev0ZV6LAa14poUykZe4xvzVccpWLZZS2MEmHLrQIfS8toPEzWXJEjcVqdjJSHHX1cSiX1WHYx", forHTTPHeaderField: "Authorization")
        //create session
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String:Any] ?? [:]
                completion(json)
            } catch {
                print("jsonSerialization failed")
            }
            }.resume()
    }
    
    class func downloadLocationImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard let unwrappedData = data else { completion(nil); return }
            
            let downloadedImage = UIImage(data: unwrappedData)
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
            
        }
        
        dataTask.resume()
    }
}
