//
//  DetailPokemonViewModelTests.swift
//  pokemon-appTests
//
//  Created by Randy Efan Jayaputra on 04/10/22.
//

import XCTest
import RxSwift
import RxTest

@testable import pokemon_app

final class DetailPokemonViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var scheduler: MainScheduler!
    var testScheduler: TestScheduler!
    
    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = MainScheduler()
        testScheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        testScheduler = nil
    }
    
    func test_output_get_error() {
        let trigger = testScheduler.createHotObservable([.next(10, ())])
        
        let errorString = testScheduler.createObserver(String.self)
        
        let result: Result<PokemonPage, PokemonListError> = .failure(.unknown(message: ""))
        
        let sut = makeSUT(result: .just(result), pokemon: DetailPokemonViewModelTests.pokemon)
        let output = sut.transform(input: DetailPokemonViewModel.Input(triggered: trigger.asDriverOnErrorJustComplete()))
        
        testScheduler.start()
        
        output.error.drive(errorString)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(errorString.events,
                       [.next(10, ""),
                        .completed(10)])
    }
    
    func test_output_get_one_pokemon_value() {
        let trigger = testScheduler.createHotObservable([.next(0, ())])
        
        let pokemonData = testScheduler.createObserver([Pokemon].self)
        
        let result: Result<PokemonPage, PokemonListError> = .success(ListPokemonViewModelTests.pokemonPageData)
        let sut = makeSUT(result: .just(result), pokemon: DetailPokemonViewModelTests.pokemon)
        
        let output = sut.transform(input: DetailPokemonViewModel.Input(triggered: trigger.asDriverOnErrorJustComplete()))
        
        testScheduler.start()
        
        output.data.drive(pokemonData)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(pokemonData.events,
                       [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(result: Observable<Result<PokemonPage, PokemonListError>>, pokemon: Pokemon) -> DetailPokemonViewModel {
        let useCase = PokemonListUseCaseStub(result: result)
        let sut = DetailPokemonViewModel(useCase: useCase, pokemon: pokemon)
        return sut
    }

}

extension DetailPokemonViewModelTests {
    internal static var pokemon: Pokemon = Pokemon(id: "1", name: "Digipet", flavorText: "Lorem ipsum", superType: "Basic", types: ["Human"], subtypes: ["Digimon"], images: nil, hp: "70")
}
