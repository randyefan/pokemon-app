//
//  Pokemon.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation

struct PokemonPage {
    let page: Int
    let count: Int
    let pokemons: [Pokemon]
    
    init(page: Int, count: Int, pokemons: [Pokemon]) {
        self.page = page
        self.count = count
        self.pokemons = pokemons
    }
}

struct Pokemon {
    let id: String?
    let name: String?
    let flavorText: String?
    let superType: String?
    let types: [String]?
    let subtypes: [String]?
    let images: URL?
    
    init(id: String?, name: String?, flavorText: String?, superType: String?, types: [String]?, subtypes: [String]?, images: URL?) {
        self.id = id
        self.name = name
        self.flavorText = flavorText
        self.superType = superType
        self.types = types
        self.subtypes = subtypes
        self.images = images
    }
}
