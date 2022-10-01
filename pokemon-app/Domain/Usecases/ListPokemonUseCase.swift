//
//  ListPokemonUseCase.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation
import RxSwift

protocol ListPokemonUseCase {
    func execute(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>>
}

class DefaultListPokemonUseCase: ListPokemonUseCase {
    
    private let repository: PokemonListRepository
    
    init(repository: PokemonListRepository) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>> {
        return repository.fetchPokemonList(query: query, page: page)
    }
}
