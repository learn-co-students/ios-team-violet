
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
    }
    
    func searchYelpRegion() {
        for term in terms {
            print("searching \(term)")
            viewModel.search(searchTerm: term, latitude: myCoordinates.coordinate.latitude, longitude: myCoordinates.coordinate.longitude) { (json) in
                
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

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babaCell", for: indexPath) as! BabaEntertainmentCell
        cell.location = babaLocations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108.0
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
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        tableView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 50).isActive = true
    }
    
}
