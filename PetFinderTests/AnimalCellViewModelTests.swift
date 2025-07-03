//
//  AnimalCellViewModelTests.swift
//  PetFinder
//
//  Created by Kotya on 30/06/2025.
//

@testable import PetFinder
import XCTest

final class AnimalCellViewModelTests: XCTestCase {
    
    func testInitWithAnimal_WithEmptyPhotos() {
        let animal: Animal = .init(id: 1, name: "Breeze", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Terrier"), photos: [], description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i")
        
        let sut = AnimalCellViewModel(animal: animal)
        
        XCTAssertEqual(sut.name, animal.name)
        XCTAssertEqual(sut.age, animal.age)
        XCTAssertEqual(sut.size, animal.size)
        XCTAssertEqual(sut.gender, animal.gender)
        XCTAssertEqual(sut.breeds, animal.breeds.primary)
        XCTAssertEqual(sut.photo, "")
    }
    
    func testInitWithAnimal_WithPhotos() {
        let photos: [Photo] = [
            .init(medium: "first_photo"),
            .init(medium: "second_photo"),
        ]
        let animal: Animal = .init(id: 1, name: "Breeze", age: "20", size: "small", gender: "xl", breeds: .init(primary: "Terrier"), photos: photos, description: nil, contact: .init(email: nil, phone: nil, address: .init(city: nil, state: nil, postcode: nil)), organization_id: "i")
        
        let sut = AnimalCellViewModel(animal: animal)
        
        XCTAssertEqual(sut.name, animal.name)
        XCTAssertEqual(sut.age, animal.age)
        XCTAssertEqual(sut.size, animal.size)
        XCTAssertEqual(sut.gender, animal.gender)
        XCTAssertEqual(sut.breeds, animal.breeds.primary)
        XCTAssertEqual(sut.photo, "first_photo")
    }
    
}
