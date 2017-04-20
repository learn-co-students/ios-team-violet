
import Foundation
import UIKit

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

    
}


class Location {
    let distance: String
    let name: String
    let imageURL: String
    var image: UIImage?
    let address: String
    
    init?(businessDictionary: [String : Any]) {
        print("LOCATION INIT GETS CALLED")
        let distanceFromSubject = businessDictionary["distance"] as? Double ?? 0.0
        guard let nameFromObj = businessDictionary["name"] as? String else { return nil }
        print("NAME FROM LOCATION: \(nameFromObj)")
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

extension Location {
    
    func loadLocationImage(completion: @escaping (Bool) -> Void) {
        
        if let imageURL = URL(string: imageURL) {
            
            BabaBreakManager.downloadLocationImage(with: imageURL, completion: { (locationImage) in
                self.image = locationImage
                if self.image != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            })
            
        }
    }

}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.name == rhs.name
    }
}























