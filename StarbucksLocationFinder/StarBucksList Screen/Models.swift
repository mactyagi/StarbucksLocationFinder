//
//  Models.swift
//  StarbucksLocationFinder
//
//  Created by Manu on 30/01/24.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let latitude: Double
    let longitude: Double
    
    var location: CLLocation{
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    var region: MKCoordinateRegion{
        MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }

    
    func getDistanceInKm(from coordinate: CLLocationCoordinate2D?) -> String{
        guard let coordinate else {return ""}
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return Double(self.location.distance(from: location) / 1000).formatDistance() + " Km"
    }
}

struct GooglePlacesResponse: Codable {
    let results: [PlaceResult]
}

struct PlaceResult: Codable {
    let name: String
    let vicinity: String
    let geometry: LocationGeometry
}

struct LocationGeometry: Codable {
    let location: LocationCoordinate
}

struct LocationCoordinate: Codable {
    let lat: Double
    let lng: Double
}
