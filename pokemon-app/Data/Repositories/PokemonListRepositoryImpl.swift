//
//  PokemonListRepositoryImpl.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation
import RxSwift

class PokemonListRepositoryImpl: PokemonListRepository {
    
    private var service: PokemonService
    
    init(service: PokemonService) {
        self.service = service
    }
    
    func fetchPokemonList(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>> {
        service.fetchPokemonLists(query: query, page: page)
    }

}
