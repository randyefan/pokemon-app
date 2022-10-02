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
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        var data = [Pokemon]()
        var page = 0
        var needFetch = true
        
        let triggerSearch = input.search.do(onNext: { _ in
            page = 0
            needFetch = true
            data = []
        })
        
        let trigger = Driver.combineLatest(input.trigger, triggerSearch)
            .filter { _ in needFetch && !activityIndicator.isFetching() }
            .flatMapLatest { [unowned self] (_, searchText) -> Driver<Result<PokemonPage, PokemonListError>> in
                if page == 0 {
                    page = 1
                } else {
                    page += 1
                }
                
                return useCase.execute(query: searchText, page: page)
                    .observe(on: MainScheduler.instance)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let pokemon = trigger.flatMapLatest { result -> Driver<[Pokemon]> in
            switch result {
            case let .success(pokemonPage):
                var newData = data
                newData.append(contentsOf: pokemonPage.pokemons)
                return .just(newData)
            case .failure(_):
                return .just([])
            }
        }.scan(data, accumulator: { current, newItem in
            if newItem.count < 1 {
                needFetch = false
            }
            
            var new = current
            new.append(contentsOf: newItem)
            return new
        })
        
        let fetching = activityIndicator.asDriver()
        let error = errorTracker.asDriver()
        
        return Output(pokemon: pokemon,
                      fetching: fetching,
                      error: error)
    }
}

extension ListPokemonViewModel {
    struct Input {
        let trigger: Driver<Void>
        let search: Driver<String>
    }
    
    struct Output {
        let pokemon: Driver<[Pokemon]>
        let fetching: Driver<Bool>
        let error: Driver<Error>
    }
}
