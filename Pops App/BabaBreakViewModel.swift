
import Foundation

final class BabaBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    
    init(){}
    
    let manager = BabaBreakManager()
    
    var locations = [Location]()
    
}

//API handling extension
extension BabaBreakViewModel {

    func useDownloadedLocations(locations: [Location]) -> [Location] {
        return locations
    }
    
    
    func createObjects(json: [String:Any], completion: ([Location])->()) {
        
        
        let arrayOfLocations = json["businesses"] as? [[String:Any]] ?? [[:]]
        
        for loc in arrayOfLocations {
            
            let newLocation = Location(businessDictionary: loc)
                        
            if let newLocation = newLocation {
                if !locations.contains(newLocation) {
                    print(newLocation, "is getting appended")
                    locations.append(newLocation)
                }
            }
            
            print("number: \(locations.count)")
        
        }
        
        if !locations.isEmpty {
            completion(locations)
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


class Location {
    let distance: String
    let name: String
    let imageURL: String
    let address: String
    
    init?(businessDictionary: [String : Any]) {
        print("LOCATION INIT GETS CALLED")
        let distanceFromSubject = businessDictionary["distance"] as? Double ?? 0.0
        let nameFromObj = businessDictionary["name"] as? String ?? "no name found"
        print("NAME FROM LOCATION: \(nameFromObj)")
        guard nameFromObj != "no name found" else { return nil }
        let imageURL = businessDictionary["image_url"] as? String ?? "no url found"
        let businessLocation = businessDictionary["location"] as? [String: Any] ?? [:]
        let addressArr = businessLocation["display_address"] as? [String] ?? []
        let addressFinal = addressArr.first ?? "none"
        
        let miles = distanceFromSubject * 0.000189394
        let milesString = String(format: "%.1f", miles)
        
        
        self.distance = "\(milesString) miles"
        self.name = nameFromObj
        self.imageURL = imageURL
        self.address = addressFinal
    }
    
    func convertFeetToMiles(feet: Double) -> String {
        let miles = feet * 0.000189394
        let milesString = String(format: "%.1f", miles)
        return milesString
    }

}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.name == rhs.name
    }
}























