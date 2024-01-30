//
//  ContentView.swift
//  StarbucksLocationFinder
//
//  Created by Manu on 29/01/24.
//

import SwiftUI
import CoreLocation
import Combine
import MapKit


struct StarbucksListView: View {
    @StateObject private var viewModel: StarbucksLocationsViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: StarbucksLocationsViewModel())
    }
    
    var body: some View {
        NavigationView {
            
            if viewModel.locationPermissionDenied {
                
                // Show message indicating no location permission
                Text("Location permission is required. Please enable it in Settings.")
                    .foregroundColor(.red)
                    .padding()
                
            }else if viewModel.isLoading{
                
                ProgressView()
                
            }else{
                
                List(viewModel.locations) { location in
                    
                    NavigationLink(destination: StarbucksMapView(region: location.region, locations: [location])) {
                        
                        VStack(alignment: .leading) {
                            
                            Text(location.subtitle)
                                .font(.headline)
                            
                            Text(location.getDistanceInKm(from: viewModel.userLocationCoordinates))
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .navigationTitle("Near by Starbucks")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    StarbucksListView()
}






