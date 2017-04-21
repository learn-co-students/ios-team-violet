
import Foundation
import UIKit
import CoreLocation
import MapKit

class BabaBreakViewNew: UIView, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate  {
    
    lazy var viewWidth: CGFloat = UIScreen.main.bounds.width //375
    lazy var viewHeight: CGFloat = UIScreen.main.bounds.height  //667
    
    let tableView = UITableView()
    let coachWindowView = UIView()
    let mainLabel = UILabel()
    
    let coachIcon = UIImageView()
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    let viewModel = BabaBreakViewModel()
    var babaLocations: [Location] = []
    var myCoordinates = CLLocation()
    var terms = ["dessert", "coffee", "food", "parks"]
    
    let location = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    
    init(){
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        searchYelpRegion()
        setupCoachWindow()
        setupCoachIcon()
        setupMainLabel()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewIsBeingDismissed), name: NSNotification.Name(rawValue: "coachBreakViewIsBeingDismissed"), object: nil)
    }
    
    
    func searchYelpRegion() {
        
        for term in terms {

            BabaBreakManager.search(searchTerm: term, latitude: myCoordinates.coordinate.latitude, longitude: myCoordinates.coordinate.longitude) { (json) in
                
                self.viewModel.createObjects(json: json, completion: { locations in
                   
                    for location in locations {
                        if !self.babaLocations.contains(location) {
                            self.babaLocations.append(location)
                        }
                    }
                    
                    print("baba Loc: \(self.babaLocations.count)")
                    print("name: \(self.babaLocations[0].name)")
                })
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myCoord = locations[locations.count - 1]
        self.myCoordinates = myCoord
        searchYelpRegion()//this searches the local region on yelp
        locationManager.stopUpdatingLocation()
    }
    
    func viewIsBeingDismissed() {
        babaLocations = babaLocations.shuffled()
        tableView.reloadData()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babaCell", for: indexPath) as! BabaEntertainmentCell
        cell.selectionStyle = .none
        cell.location = babaLocations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! BabaEntertainmentCell
            
        let yelpyURL = selectedCell.location.yelpUrl
        //these two lines of code randomizes the array after the user selects a place.
        babaLocations = babaLocations.shuffled()
        
        let appURL = URL(string: yelpyURL)
        let webURL = URL(string: yelpyURL)
        
        let app = UIApplication.shared
        
        if app.canOpenURL(appURL!) {
            app.open(appURL!)
        } else {
            app.open(webURL!)
        }
        
    }
    
}

extension BabaBreakViewNew {
    
    func setupCoachWindow() {
        self.addSubview(coachWindowView)
        coachWindowView.translatesAutoresizingMaskIntoConstraints = false
        coachWindowView.backgroundColor = Palette.salmon.color
        coachWindowView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        coachWindowView.topAnchor.constraint(equalTo: self.topAnchor, constant: viewHeight * (90/667)).isActive = true
        coachWindowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coachWindowView.layer.cornerRadius = 50.0
        coachWindowView.layer.masksToBounds = true
    }
    
    func setupCoachIcon() {
        coachIcon.image = #imageLiteral(resourceName: "IC_BABA")
        coachIcon.contentMode = .scaleAspectFill
        
        coachWindowView.addSubview(coachIcon)
        coachIcon.translatesAutoresizingMaskIntoConstraints = false
        
        coachBottomAnchorConstraint = coachIcon.bottomAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 10)
        coachBottomAnchorConstraint.isActive = true
        coachIcon.centerXAnchor.constraint(equalTo: coachWindowView.centerXAnchor).isActive = true
    }
    
    func setupMainLabel() {
        self.addSubview(mainLabel)
        mainLabel.font = UIFont(name: "Avenir-Black", size: 14)
        mainLabel.textColor = UIColor.black
        mainLabel.text = "Baba's Local Guide"
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainLabel.topAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 15).isActive = true
    }

    func setupTableView() {
        tableView.register(BabaEntertainmentCell.self, forCellReuseIdentifier: "babaCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: viewWidth * (18/375)).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -viewWidth * (18/375)).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewWidth * (80/375)).isActive = true
        tableView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: viewWidth * (50/375)).isActive = true
    }
    
}

//array extension to shuffle the collection of locations.
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
