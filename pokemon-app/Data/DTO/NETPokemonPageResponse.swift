//
//  NETPokemonPageResponse.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation

struct NETPokemonResponse: Decodable {
    let page: Int?
    let count: Int?
    let totalCount: Int?
    let data: [NETPokemonDataResponse]?
    
    func asDomain() -> PokemonPage {
        let pokemons = data.map { $0.map { $0.asDomain() } } ?? []
        
        return PokemonPage(page: page ?? 0, count: count ?? 0, pokemons: pokemons)
    }
}

struct NETPokemonDataResponse: Decodable {
    let id: String?
    let name: String?
    let supertype: String?
    let flavorText: String?
    let subtypes: [String]?
    let types: [String]?
    let images: NETPokemonDataImagesResponse?
    
    func asDomain() -> Pokemon {
        let typesString = types ?? []
        let subtypesString = subtypes ?? []
        let urlImage = URL(string: "\(images?.large ?? "")")
        
        return Pokemon(id: id, name: name, flavorText: flavorText, superType: supertype, types: typesString, subtypes: subtypesString, images: urlImage)
    }
}

struct NETPokemonDataImagesResponse: Decodable {
    let large: String?
}

// Error API

struct ApiErrorMessage: Decodable, Error {
    let error: ApiErrorDataMessage?
}

struct ApiErrorDataMessage: Decodable {
    let message: String?
    let code: Int?
}
