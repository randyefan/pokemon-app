//
//  PokemonCardViewModel.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation

final class PokemonCardViewModel {
    let image: URL?
    let isSkeleton: Bool
    
    init(image: URL? = nil, isSkeleton: Bool = false) {
        self.image = image
        self.isSkeleton = isSkeleton
    }
}
