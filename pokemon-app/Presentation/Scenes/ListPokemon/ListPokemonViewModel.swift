//
//  ListPokemonViewModel.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import Foundation
import RxSwift
import RxCocoa

final class ListPokemonViewModel: ViewModelType {
    
    // MARK: - Variable
    private let useCase: PokemonListUseCase
    
    init(useCase: PokemonListUseCase) {
        self.useCase = useCase
    }
    
    // MARK: -  TransForm
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension ListPokemonViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
}
