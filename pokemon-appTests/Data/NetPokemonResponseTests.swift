//
//  NetPokemonResponseTests.swift
//  pokemon-appTests
//
//  Created by Randy Efan Jayaputra on 04/10/22.
//

import XCTest
import Foundation

@testable import pokemon_app

enum ErrorTest: Error {
    case error(String)
}

final class NetPokemonResponseTests: XCTestCase {
    
    func test_check_response_not_nil() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut)
    }
    
    func test_pokemon_page_convert_to_domain_object() {
        let sut = makeSUT()
        
        guard let pokemon = sut?.asDomain() else {
            XCTFail("Expected a value from Pokemon Page, found nil instead")
            return
        }
        
        XCTAssertEqual(pokemon.count, sut?.count)
    }
    
    func test_pokemon_convert_to_domain_object() {
        let sut = makeSUT()
        
        guard let pokemon = sut?.asDomain() else {
            XCTFail("Expected a value from Pokemon Page, found nil instead")
            return
        }
        
        XCTAssertEqual(pokemon.pokemons.count, sut?.data?.count)
    }
    
    // MARK: - Helper
    
    func makeSUT() -> NETPokemonResponse? {
        let bundle = Bundle(for: NetPokemonResponseTests.self)
        guard let data = try? JsonFileLoader.load(fileName: "Data", for: bundle) else { return nil }
        
        guard let netPokemonResponse = try? JSONDecoder().decode(NETPokemonResponse.self, from: data) else { return nil }
        return netPokemonResponse
    }
}
