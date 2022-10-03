//
//  PokemonListUseCaseStub.swift
//  pokemon-appTests
//
//  Created by Randy Efan Jayaputra on 03/10/22.
//

import RxSwift
@testable import pokemon_app

final class PokemonListUseCaseStub: PokemonListUseCase {
    
    private let result: Observable<Result<PokemonPage, PokemonListError>>
    
    init(result: Observable<Result<PokemonPage, PokemonListError>>) {
        self.result = result
    }
    
    func execute(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>> {
        return result
    }
    
}
