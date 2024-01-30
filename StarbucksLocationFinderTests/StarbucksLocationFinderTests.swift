//
//  StarbucksLocationFinderTests.swift
//  StarbucksLocationFinderTests
//
//  Created by Manu on 29/01/24.
//

import XCTest
import Combine

@testable import StarbucksLocationFinder
import CoreLocation

final class StarbucksLocationFinderTests: XCTestCase {

    var viewModel: StarbucksListView.StarbucksLocationsViewModel!
    var cancellables: Set<AnyCancellable>!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        viewModel = StarbucksListView.StarbucksLocationsViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func test_location_authorization_denied_returnLocationPermissionDeniedTrue() {
        viewModel.checkLocationAuthorization(with: .denied)
        
        XCTAssertTrue(viewModel.locationPermissionDenied)
        }
    
    func test_location_authorization_authorized_when_in_use_returnLocationPermissionDeniedFalse() {
        viewModel.checkLocationAuthorization(with: .authorizedWhenInUse)
        
        XCTAssertFalse(viewModel.locationPermissionDenied)
        }
    
    func test_location_authorization_authorized_always_returnLocationPermissionDeniedFalse() {
        viewModel.checkLocationAuthorization(with: .authorizedAlways)
        
        XCTAssertFalse(viewModel.locationPermissionDenied)
        }
    
    func test_location_authorization_authorized_not_determined_returnLocationPermissionDeniedTrue() {
        viewModel.checkLocationAuthorization(with: .notDetermined)
        
        XCTAssertTrue(viewModel.locationPermissionDenied)
        }
    
    func test_location_authorization_authorized_restricted_returnLocationPermissionDeniedTrue() {
        viewModel.checkLocationAuthorization(with: .restricted)
        
        XCTAssertTrue(viewModel.locationPermissionDenied)
        }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}









