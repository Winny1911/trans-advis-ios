//
//  SearchViewController.swift
//  TA
//
//  Created by Applify on 24/02/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class SearchViewController: BaseViewController, UISearchBarDelegate  {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var btnTapAction3 : (()->())?
    
    var lat: Double = 0.0
    var lng: Double = 0.0
    var addressLine1 = ""
    var addressLine2 = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var street = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.delegate = self
        searchController?.navigationController?.navigationBar.isHidden = true
        searchController?.navigationItem.title = "Enter address"
        
        let subView = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.size.width - 20, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        definesPresentationContext = true
        DispatchQueue.main.async {
            self.searchController?.searchBar.becomeFirstResponder()
        }
        
    }
    
    
    // MARK: - UISearchBarDelegate

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       // do your thing
   }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       // do your thing
    self.dismiss(animated: true, completion: nil)
   }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       // do your thing
    searchController?.searchBar.resignFirstResponder()
   }

   // MARK: - UISearchResultsUpdating

   func updateSearchResultsForSearchController(searchController: UISearchController) {
       //let searchController = searchController.searchBar.text!.lowercaseString

       // do your thing..

//       tableView.reloadData()
   }

}

//TODO:-
extension SearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        self.addressLine1 = place.formattedAddress ?? ""
        let address = place.addressComponents
        for component in address! {
            if component.type == "locality" {
                self.city = component.name
            } else if component.type == "administrative_area_level_1" {
                self.state = component.name
            } else if component.type == "postal_code" {
                self.zipcode = component.name
            }
        }
//        self.addressLine2 = place.formattedAddress ?? ""
//        lat = place.coordinate.latitude
//        long = place.coordinate.longitude
//        print(place.coordinate.latitude, place.coordinate.longitude)
//
//        searchController?.searchBar.text = place.formattedAddress
        self.getAddressFromLatLon(pdblLatitude: "\(place.coordinate.latitude)", withLongitude: "\(place.coordinate.longitude)")
//        self.getAddressFromLatLong(latitude: lat, longitude: lng)
        self.btnTapAction3?()
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        self.lat = Double("\(pdblLatitude)")!
        self.lng = Double("\(pdblLongitude)")!
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//                                    {(placemarks, error) in
//            if (error != nil) {
//                print("reverse geodcode fail: \(error!.localizedDescription)")
//            }
//            let pm = placemarks! as [CLPlacemark]
//            if pm.count > 0 {
//                let pm = placemarks![0]
//                let a = pm.self
//                self.street = "\(a)"
//
//                let addrList = pm.addressDictionary?["FormattedAddressLines"] as? [String]
//
//                self.addressLine1 = addrList?.joined(separator: ", ") ?? ""
//
//                self.city = (pm.locality ?? "")
//                self.zipcode = pm.postalCode ?? ""
//                self.state = pm.administrativeArea ?? ""
//                self.lat = lat
//                self.long = lon
//
//                self.btnTapAction3?()
//            }
//        })
        
//        self.getAddressFromLatLong(latitude: lat, longitude: lng)
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyC40COvhcLuscjwn4QsEbbteT4Vtno_LDo"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                if let responseJson = response.value as? NSDictionary {
                    if let results = responseJson.object(forKey: "results") as? [NSDictionary] {
                        if results.count > 0 {
                            if let addressComponents = results[0]["address_components"] as? [NSDictionary] {
                                self.addressLine1 = results[0]["formatted_address"] as? String ?? ""
                                for component in addressComponents {
                                    if let temp = component.object(forKey: "types") as? [String] {
                                        if (temp[0] == "postal_code") {
                                            self.zipcode = component["long_name"] as? String ?? ""
                                        }
                                        if (temp[0] == "locality") {
                                            self.city = component["long_name"] as? String ?? ""
                                        }
                                        if (temp[0] == "administrative_area_level_1") {
                                            self.state = component["long_name"] as? String ?? ""
                                        }
                                        if (temp[0] == "country") {
//                                            country = component["long_name"] as? String
                                        }
                                    }
                                }
                            }
                            self.btnTapAction3?()
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      //  Progress.instance.show()
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      //  Progress.instance.hide()
    }
}
