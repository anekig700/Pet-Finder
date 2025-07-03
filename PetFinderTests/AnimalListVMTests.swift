//
//  AnimalListVMTests.swift
//  PetFinderTests
//
//  Created by Kotya on 25/06/2025.
//

@testable import PetFinder
import XCTest

final class AnimalListVMTests: XCTestCase {
    
    private var sut: AnimalListVM!
    private var networkServiceMock: NetworkServiceMock!
    private var routerSpy: AnimalListRouterSpy!
    
    override func setUpWithError() throws {
        networkServiceMock = NetworkServiceMock()
        routerSpy = AnimalListRouterSpy()
        sut = AnimalListVM(service: networkServiceMock, query: nil, router: routerSpy)
    }
    
    func testViewDidLoad_LoadsData() {
        // given
        var viewModelDidChangeCalled = false
        sut.viewModelDidChange = {
            viewModelDidChangeCalled = true
        }
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(networkServiceMock.calls, [.retrieveAnimals(path: "/v2/animals")])
        XCTAssertTrue(viewModelDidChangeCalled)
    }
    
    func testViewDidLoad_LoadsData_WithQuery() {
        // given
        let networkServiceMock = NetworkServiceMock()
        routerSpy = AnimalListRouterSpy()
        sut = AnimalListVM(service: networkServiceMock, query: "?test=1", router: routerSpy)
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(networkServiceMock.calls, [.retrieveAnimals(path: "/v2/animals?test=1")])
    }
    
    func testNumberOfAnimals_WhenDataIsLoaded() {
        // given
        let animals = [
            Animal(id: 1, name: "Breeze", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Terrier"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i"),
            Animal(id: 2, name: "Perry", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Domestic Short Hair"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i")
        ]
        networkServiceMock.result = Animals(animals: animals)
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.numberOfAnimals(), animals.count)
    }
    
    func testNumberOfAnimals_WhenDataIsNotLoaded() {
        // given
        networkServiceMock.result = ""
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.numberOfAnimals(), 0)
    }
    
    func testAnimalCellDidTap_AtCorrectIndex_CallsRouter() {
        // given
        networkServiceMock.result = Animals(animals: [
            Animal(id: 1, name: "Breeze", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Terrier"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i"),
            Animal(id: 2, name: "Perry", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Domestic Short Hair"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i")
        ])
        let correctIndex = 0
        
        sut.viewDidLoad()
        
        // when
        sut.animalCellDidTap(at: correctIndex)
        
        // then
        XCTAssertEqual(routerSpy.calls, [.openAnimalDetails])
    }
    
    func testAnimalCellDidTap_AtIncorrectIndex_DoesNotCallRouter() {
        // given
        networkServiceMock.result = Animals(animals: [
            Animal(id: 1, name: "Breeze", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Terrier"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i"),
            Animal(id: 2, name: "Perry", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Domestic Short Hair"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i")
        ])
        let outOfBoundsIndex = 2
        
        sut.viewDidLoad()
        
        // when
        sut.animalCellDidTap(at: outOfBoundsIndex)
        
        // then
        XCTAssertEqual(routerSpy.calls, [])
    }
    
}
