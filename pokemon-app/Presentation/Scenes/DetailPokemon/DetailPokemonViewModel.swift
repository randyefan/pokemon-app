//
//  DetailPokemonViewModel.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import Foundation

final class DetailPokemonViewModel: ViewModelType {
    
    // MARK: - Variable
    private let useCase: PokemonListUseCase
    
    let pokemon: Pokemon
    
    init(useCase: PokemonListUseCase, pokemon: Pokemon) {
        self.useCase = useCase
        self.pokemon = pokemon
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}

extension DetailPokemonViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
}
