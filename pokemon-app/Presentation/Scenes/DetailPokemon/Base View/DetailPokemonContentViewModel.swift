//
//  PokemonViewModel.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import Foundation

final class DetailPokemonContentViewModel {
    let image: URL?
    let pokemon: Pokemon
    
    init(image: URL? = nil, pokemon: Pokemon) {
        self.image = image
        self.pokemon = pokemon
    }
}
