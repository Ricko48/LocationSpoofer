//
//  SecondViewController.swift
//  LocationSpoofer
//
//  Created by Richard Ondrejka on 07.12.2021.
//  Copyright © 2021 Richard Ondrejka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, UISearchBarDelegate {
    
    var locationFileManager : LocationFileManager?
    
    var callback : (() -> Void)?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func addPinToMap(coordinates : CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.subtitle = "Picked location"
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let coordinates = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        addPinToMap(coordinates: coordinates)
        updateLocationInDict(coordinate: coordinates)
    }
    
    func updateLocationInDict(coordinate : CLLocationCoordinate2D){
        locationFileManager?.locationDict.updateValue(coordinate.latitude, forKey: "latitude")
        locationFileManager?.locationDict.updateValue(coordinate.longitude, forKey: "longitude")
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request : searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if (response == nil) {
                let alert = UIAlertController(title: "Error", message: "No results for searched input.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.subtitle = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta : 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                self.updateLocationInDict(coordinate: coordinate)
            }
        }
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        callback?()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinates = CLLocationCoordinate2DMake((locationFileManager?.locationDict["latitude"])! as CLLocationDegrees, (locationFileManager?.locationDict["longitude"])! as CLLocationDegrees)
        addPinToMap(coordinates: coordinates)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
    }


}

