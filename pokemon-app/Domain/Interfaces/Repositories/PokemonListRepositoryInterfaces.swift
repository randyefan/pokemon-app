//
//  PokemonListRepositoryInterfaces.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation
import RxSwift

/// Error State
enum PokemonListError: Error, Equatable {
    case notFound
    case unknown(message: String)
}

protocol PokemonListRepository {
    func fetchPokemonList(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>>
}
