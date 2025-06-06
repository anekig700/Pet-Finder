//
//  PetFinderTests.swift
//  PetFinderTests
//
//  Created by Kotya on 05/06/2025.
//

import XCTest
@testable import PetFinder
import Combine

final class PetFinderTests: XCTestCase {
    
    var sut: AnimalListViewModel!
    var mockService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        sut = AnimalListViewModel(service: mockService)
        cancellables = []
    }

    override func tearDown() {
        mockService = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchAnimalsSuccess() {
        mockService.result = [
            Animal(id: 1, name: "Breeze", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Terrier"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i"),
            Animal(id: 2, name: "Perry", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Domestic Short Hair"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i")
        ]

        let expectation = XCTestExpectation(description: "Animal list loaded")

        sut.$animals
            .dropFirst()
            .sink { animals in
                XCTAssertEqual(animals.count, 2)
                XCTAssertEqual(animals[0].name, "Breeze")
                XCTAssertEqual(animals[1].name, "Perry")
                expectation.fulfill()
            }
        .store(in: &cancellables)

        sut.retrieveAnimals()

        wait(for: [expectation], timeout: 1.0)
    }
    
//    func testLoadArticlesDecodingFailure() {
//        mockService.result = ""
//        
//        let expectation = XCTestExpectation(description: "Handled decoding failure")
//        
//        sut.$animals
//            .dropFirst()
//            .sink { animals in
//                XCTAssertEqual(animals.count, 0)
//                expectation.fulfill()
//            }
//        .store(in: &cancellables)
//
//        sut.retrieveAnimals()
//
//        wait(for: [expectation], timeout: 1.0)
//    }

}
