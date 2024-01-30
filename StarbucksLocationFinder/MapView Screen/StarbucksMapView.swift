//
//  StarbucksMapView.swift
//  StarbucksLocationFinder
//
//  Created by Manu on 29/01/24.
//

import SwiftUI
import MapKit

struct StarbucksMapView: View {
    @State var region: MKCoordinateRegion
    var locations: [Location]
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: locations) { location in
            MapMarker(coordinate: location.location.coordinate, tint: .red)
        }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
    }
}


#Preview {
    let coordinates1 = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    let location1 = CLLocation(latitude: coordinates1.latitude, longitude: coordinates1.longitude)
    let region = MKCoordinateRegion(
        center: coordinates1,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    return StarbucksMapView(region: region, locations: [])
}
