//
//  DetailPokemonViewModel.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import RxCocoa
import RxSwift

final class DetailPokemonViewModel: ViewModelType {
    
    // MARK: - Variable
    private let useCase: PokemonListUseCase
    
    let pokemon: Pokemon
    
    init(useCase: PokemonListUseCase, pokemon: Pokemon) {
        self.useCase = useCase
        self.pokemon = pokemon
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        var page = 0
        var needFetch = true
        
        let trigger = input.triggered
            .filter { _ in needFetch && !activityIndicator.isFetching() }
            .flatMapLatest { _ -> Driver<Result<PokemonPage, PokemonListError>> in
                if page == 0 {
                    page = 1
                } else {
                    page += 1
                }
                
                return self.useCase.execute(query: "", page: page)
                    .observe(on: MainScheduler.instance)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let pokemon = trigger.flatMapLatest { result -> Driver<[Pokemon]> in
            switch result {
            case let .success(pokemonPage):
                return .just(pokemonPage.pokemons)
            case .failure(_):
                return .just([])
            }
        }.scan([Pokemon](), accumulator: { current, newItem in
            if newItem.count == 0 {
                needFetch = false
            }
            
            var newData = current
            newData.append(contentsOf: newItem)
            return newData
        })
        
        let fetching = activityIndicator.asDriver()
        let error = errorTracker.asDriver()
        
        return Output(data: pokemon,
                      fetching: fetching,
                      error: error)
    }
}

extension DetailPokemonViewModel {
    struct Input {
        let triggered: Driver<Void>
    }
    
    struct Output {
        let data: Driver<[Pokemon]>
        let fetching: Driver<Bool>
        let error: Driver<Error>
    }
}
