//
//  StarbucksListViewModel.swift
//  StarbucksLocationFinder
//
//  Created by Manu on 30/01/24.
//

import Foundation
import MapKit
import Combine

extension StarbucksListView{
    class StarbucksLocationsViewModel:  NSObject, ObservableObject, CLLocationManagerDelegate{
        
        //MARK: - Properties
        private var locationManager: CLLocationManager
        var workItem: DispatchWorkItem?
        var networkManager:NetworkManagerProtocol
        private var cancellables = Set<AnyCancellable>()
        @Published var locations = [Location]()
        @Published var userLocationCoordinates: CLLocationCoordinate2D?
        @Published var locationPermissionDenied = false
        @Published var isLoading = false
        @Published var showErrorAlert = false
        
        @Published var errorMessage: String = ""{
            didSet{
                if !errorMessage.isEmpty{
                    showErrorAlert = true
                }
            }
        }
        
        init(locationManager: CLLocationManager = CLLocationManager(), networkManager: NetworkManager = NetworkManager.shared) {
            self.networkManager = networkManager
            self.locationManager = locationManager
            super.init()
            self.requestLocation()
        }
        
       
        //MARK: - Function
        private func requestLocation() {
            print("location requested")
            locationManager.delegate = self
            checkLocationAuthorization(with: CLLocationManager.authorizationStatus())
        }
        
        
        func fetchStarbucksLocations() {
            isLoading = true
            guard let userLocation = self.userLocationCoordinates else {
                print("no user Location found")
                return
            }
            
            let dispatchWorkItem = DispatchWorkItem {
                let apiUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userLocation.latitude),\(userLocation.longitude)&radius=5000&keyword=starbucks&key=\(NetworkManager.apiKey)"

                    guard let url = URL(string: apiUrl) else {
                        self.errorMessage = "Invalid API URL"
                        self.isLoading = false
                        return
                    }
                
                self.networkManager.fetchData(from: url)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.errorMessage = "Error: \(error.localizedDescription)"
                            self.isLoading = false
                        }
                    } receiveValue: { (response: GooglePlacesResponse) in
                        self.locations = response.results.map { result in
                            Location(
                                title: result.name,
                                subtitle: result.vicinity,
                                latitude: result.geometry.location.lat,
                                longitude: result.geometry.location.lng
                            )
                        }.sorted(by: { $0.getDistanceInKm(from: self.userLocationCoordinates) < $1.getDistanceInKm(from: self.userLocationCoordinates)})
                        self.isLoading = false
                    }
                    .store(in: &self.cancellables)
            }
            
            if let workItem{
                workItem.cancel()
            }
            self.workItem = dispatchWorkItem
            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: self.workItem!)
        }
        
        
        
        func checkLocationAuthorization(with status: CLAuthorizationStatus) {
                switch status {
                case .authorizedWhenInUse, .authorizedAlways:
                    locationPermissionDenied = false
                    locationManager.startUpdatingLocation()
                case .notDetermined:
                    locationPermissionDenied = true
                    locationManager.requestWhenInUseAuthorization()
                case .denied, .restricted:
                    locationPermissionDenied = true
                    errorMessage = "No Location Enabled."
                default:
                    break
                }
            }
        
        
        //MARK: - CLLocationManagerDelegate
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first?.coordinate {
                userLocationCoordinates = location
                fetchStarbucksLocations()
                manager.stopUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            errorMessage = ("Location error: \(error.localizedDescription)")
            
        }
        
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization(with: CLLocationManager.authorizationStatus())
        }
    }
    
}




