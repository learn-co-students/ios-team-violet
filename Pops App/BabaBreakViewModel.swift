
import Foundation

final class BabaBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    
    init(){}
    
    let manager = BabaBreakManager()
    
}

//API handling extension
extension BabaBreakViewModel {

    func useDownloadedLocations(locations: [Location]) -> [Location] {
        return locations
    }
    
    
    func createObjects(json: [String:Any], completion: ([Location])->()) {
        var locations = [Location]()
        
        let arrayOfLocations = json["businesses"] as? [[String:Any]] ?? [[:]]
        for loc in arrayOfLocations {
            let newLocation = Location(businessDictionary: loc)
            locations.append(newLocation)
            if locations.count == arrayOfLocations.count {
                completion(locations)
            }
        }
    }
    
    //search function
    func search(searchTerm: String, latitude: Double, longitude: Double, completion: @escaping ([String: Any]) -> Void ) {
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
    
}


struct Location {
    let distance: Double
    let name: String
    let imageURL: String
    let address: String
    
    init(businessDictionary: [String : Any]) {
        let distanceFromSubject = businessDictionary["distance"] as? Double ?? 0.0
        let nameFromObj = businessDictionary["name"] as? String ?? "no name found"
        let imageURL = businessDictionary["image_url"] as? String ?? "no url found"
        let businessLocation = businessDictionary["location"] as? [String: Any] ?? [:]
        let addressArr = businessLocation["display_address"] as? [String] ?? []
        let addressFinal = addressArr.first ?? "none"
        self.distance = distanceFromSubject
        self.name = nameFromObj
        self.imageURL = imageURL
        self.address = addressFinal
    }
    
    
}






















