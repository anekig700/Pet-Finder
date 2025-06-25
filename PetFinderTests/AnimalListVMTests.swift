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
    
    func testAnimalCellDidTap_AtCorrectIndex_CallsRouter() {
        // given
        networkServiceMock.result = Animals(animals: [
            Animal(id: 1, name: "Breeze", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Terrier"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i"),
            Animal(id: 2, name: "Perry", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Domestic Short Hair"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i")
        ])
        let index = 0
        
        sut.viewDidLoad()
        
        // when
        sut.animalCellDidTap(at: index)
        
        // then
        XCTAssertEqual(routerSpy.calls, [.openAnimalDetails])
    }
    
    func testAnimalCellDidTap_AtIncorrectIndex_DoesNotCallRouter() {
        // TODO: Implement
    }
    
}
