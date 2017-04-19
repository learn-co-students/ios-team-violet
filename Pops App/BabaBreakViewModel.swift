
import Foundation

final class BabaBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    
    init(){}
    
    let manager = BabaBreakManager()
    
    
    
}

//API handling extension
extension BabaBreakViewModel {
    //establish the url
    
    //url: https://api.yelp.com/v3/businesses/search?term=food&latitude=40.786882&longitude=-74.399972
    //url components: term, latitude, longitude
    //searchTerm... let's do cakes, parks, and food.
    func search(completion: @escaping ([String: Any]) -> Void ) {
        let urlString = "https://api.yelp.com/v3/businesses/search?term=food&latitude=40.786882&longitude=-74.399972"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { return }
        var request = URLRequest(url: unwrappedURL)
        request.addValue("Bearer FY7uBD8m9o5b94wkg9iDli0-6e7Ongpqxusqh0sa1Klfa0Oi66SPHKQev0ZV6LAa14poUykZe4xvzVccpWLZZS2MEmHLrQIfS8toPEzWXJEjcVqdjJSHHX1cSiX1WHYx", forHTTPHeaderField: "Authorization")
        
        //create session
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let unwrappedData = data else { return }
        }
//        session.dataTask(with: unwrappedURL) { (data, response, error) in
//            guard let unwrappedData = data else { return }
//            do {
//                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String:Any] ?? [:]
//                completion(json)
//            } catch {
//                print("JSON serialization Error!")
//            }
//        }.resume()
    }
    //add the header to the urlrequest
    
    
    //create url session
    //create dataTask
    //get JSON
    //pass JSON into Completion Handler

    
}


struct Location {
    let distance: Double
    let name: String
    
    init?(businessDictionary: [String : Any]) {
        let distanceFromSubject = businessDictionary["distance"] as? Double ?? 0.0
        let nameFromObj = businessDictionary["name"] as? String ?? "no name found"
        guard distanceFromSubject <= 3000.0 else { return nil }
        self.distance = distanceFromSubject
        self.name = nameFromObj
    }
    
    
}






















