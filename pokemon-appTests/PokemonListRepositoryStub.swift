//
//  PokemonListRepositoryStub.swift
//  pokemon-appTests
//
//  Created by Randy Efan Jayaputra on 04/10/22.
//

import XCTest
import RxSwift

@testable import pokemon_app

final class PokemonListRepositoryStub: PokemonListRepository {
    
    private let result: Observable<Result<PokemonPage, PokemonListError>>
    
    init(result: Observable<Result<PokemonPage, PokemonListError>>) {
        self.result = result
    }
    
    func fetchPokemonList(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>> {
        result
    }

}
