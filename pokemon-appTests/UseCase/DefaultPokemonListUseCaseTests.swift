//
//  DefaultPokemonListUseCaseTests.swift
//  pokemon-appTests
//
//  Created by Randy Efan Jayaputra on 04/10/22.
//

import XCTest
import RxSwift

@testable import pokemon_app

final class DefaultPokemonListUseCaseTests: XCTestCase {
    
    func test_whenFailedGetData_shouldReturnError() {
        let error = PokemonListError.unknown(message: "Found Error")
        let sut = makeSUT(result: .just(.failure(error)))
        
        var capturedError: PokemonListError?
        
        sut.execute(query: "", page: 0)
            .subscribe(onNext: { result in
                switch result {
                case .success(_):
                    XCTFail("Expected a failure, get a success instead")
                case .failure(let error):
                    capturedError = error
                }
            }).disposed(by: DisposeBag())
        
        XCTAssertNotNil(capturedError)
    }
    
    func test_whenSuccessGetData_shouldReturnAPokemon() {
        let pokemonPage = PokemonPage(page: 0, count: 1, pokemons: [
            Pokemon(id: "1", name: "Digipet", flavorText: "Lorem Ipsum", superType: "Basic", types: [], subtypes: [], images: nil, hp: "90")
        ])
        
        let sut = makeSUT(result: .just(.success(pokemonPage)))
        
        let capturedValues = loadData(on: sut)
        
        XCTAssertEqual(capturedValues, pokemonPage.pokemons)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(result: Observable<Result<PokemonPage, PokemonListError>>) -> DefaultPokemonListUseCase {
        let repository = PokemonListRepositoryStub(result: result)
        let sut = DefaultPokemonListUseCase(repository: repository)
        
        return sut
    }
    
    private func loadData(on sut: DefaultPokemonListUseCase) -> [Pokemon]? {
        var capturedValues: [Pokemon]?
        
        sut.execute(query: "", page: 0)
            .subscribe(onNext: { result in
                switch result {
                case .success(let pokemonData):
                    capturedValues = pokemonData.pokemons
                case .failure(_):
                    XCTFail("Expected a success, get a failure instead")
                }
            }).disposed(by: DisposeBag())
        
        return capturedValues
    }

}
