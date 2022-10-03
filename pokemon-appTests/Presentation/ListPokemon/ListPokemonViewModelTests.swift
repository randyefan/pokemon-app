//
//  ListPokemonViewModelTests.swift
//  pokemon-appTests
//
//  Created by Randy Efan Jayaputra on 03/10/22.
//

import XCTest
import RxSwift
import RxTest

@testable import pokemon_app

final class ListPokemonViewModelTests: XCTestCase {
    
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
        let trigger = testScheduler.createHotObservable([.next(0, ())])
        let triggerSearch = testScheduler.createHotObservable([.next(0, "")])
        let tap = testScheduler.createHotObservable([.next(0, IndexPath(row: 0, section: 0))])
        
        let errorString = testScheduler.createObserver(String.self)
        
        let result: Result<PokemonPage, PokemonListError> = .failure(.unknown(message: "Found Error"))
        
        let sut = makeSUT(result: .just(result))
        let output = sut.transform(input: ListPokemonViewModel.Input(trigger: trigger.asDriverOnErrorJustComplete(),
                                                                     search: triggerSearch.asDriverOnErrorJustComplete(),
                                                                     tap: tap.asDriverOnErrorJustComplete()))
        
        testScheduler.start()
        
        output.error.drive(errorString)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(errorString.events,
                       [.next(0, "Found Error")])
    }
    
    func test_output_get_one_pokemon_value() {
        let trigger = testScheduler.createHotObservable([.next(0, ())])
        let triggerSearch = testScheduler.createHotObservable([.next(0, "")])
        let tap = testScheduler.createHotObservable([.next(0, IndexPath(row: 0, section: 0))])
        
        let pokemonData = testScheduler.createObserver([Pokemon].self)
        
        let result: Result<PokemonPage, PokemonListError> = .success(ListPokemonViewModelTests.pokemonPageData)
        let sut = makeSUT(result: .just(result))
        
        let output = sut.transform(input: ListPokemonViewModel.Input(trigger: trigger.asDriverOnErrorJustComplete(),
                                                                     search: triggerSearch.asDriverOnErrorJustComplete(),
                                                                     tap: tap.asDriverOnErrorJustComplete()))
        
        testScheduler.start()
        
        output.pokemon.drive(pokemonData)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(pokemonData.events,
                       [.next(0, [ListPokemonViewModelTests.pokemon])])
    }

    // MARK: - Helpers
    
    private func makeSUT(result: Observable<Result<PokemonPage, PokemonListError>>) -> ListPokemonViewModel {
        let useCase = PokemonListUseCaseStub(result: result)
        let sut = ListPokemonViewModel(useCase: useCase)
        return sut
    }

}

extension ListPokemonViewModelTests {
    internal static var pokemonPageData: PokemonPage = PokemonPage(page: 0, count: 1, pokemons: [ListPokemonViewModelTests.pokemon])
    internal static var pokemon: Pokemon = Pokemon(id: "1", name: "Digipet", flavorText: "Lorem ipsum", superType: "Basic", types: ["Human"], subtypes: ["Digimon"], images: nil, hp: "70")
}
