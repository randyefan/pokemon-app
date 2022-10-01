//
//  PokemonService.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation
import RxSwift
import RxAlamofire

protocol PokemonService {
    func fetchPokemonLists(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>>
}

class PokemonServiceImpl: PokemonService {
    private let baseURLString = "https://api.pokemontcg.io/v2/cards"
    private let scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1))
    
    func fetchPokemonLists(query: String, page: Int) -> Observable<Result<PokemonPage, PokemonListError>> {
        return RxAlamofire.request(.get, baseURLString, parameters: makeParameters(query: query, page: page))
            .responseData()
            .observe(on: scheduler)
            .expectingObject(ofType: NETPokemonResponse.self)
            .flatMapLatest { result -> Observable<Result<PokemonPage, PokemonListError>> in
                let newResult = result.map { response in
                    response.asDomain()
                }.mapError { error in
                    PokemonListError.unknown(message: error.error?.message ?? "")
                }
                
                return Observable.just(newResult)
            }
    }
    
    // MARK: - Private Func
    private func makeParameters(query: String, page: Int) -> [String: Any] {
        let newQuery = query.isEmpty ? "" : "name:\(query)"
        let parameters: [String: Any] = [
            "q": newQuery,
            "page": page,
            "pageSize": 10,
            "select": "id,name,flavorText,types,supertype,subtypes,images"
        ]
        
        return parameters
    }
}
