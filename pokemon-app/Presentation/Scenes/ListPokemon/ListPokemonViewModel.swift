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
        let errorTracker: PublishRelay<String> = .init()
        
        var data = [Pokemon]()
        var page = 0
        var needFetch = true
        
        let triggerSearch = input.search
            .throttle(RxTimeInterval.seconds(1))
            .do(onNext: { _ in
                page = 0
                needFetch = true
                data = []
                errorTracker.accept("")
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
                    .asDriverOnErrorJustComplete()
            }
        
        let pokemon = trigger.flatMapLatest { result -> Driver<[Pokemon]> in
            switch result {
            
            case let .success(pokemonPage):
                // Stop request new page if count == 0
                if pokemonPage.pokemons.count == 0 {
                    needFetch = false
                }
                
                var newData = data
                newData.append(contentsOf: pokemonPage.pokemons)
                return .just(newData)
                
            case let .failure(error):
                switch error {
                case .unknown(message: let message):
                    errorTracker.accept(message)
                default:
                    errorTracker.accept("System Error.")
                }
                
                return .just([])
            }
        }.do { pokemon in
            data = pokemon
        }
        
        let tapTriggered = input.tap.withLatestFrom(pokemon) { (indexPath, pokemon) -> Pokemon in
            return pokemon[indexPath.row]
        }
        
        let fetching = activityIndicator.asDriver()
        let error = errorTracker.asDriver(onErrorJustReturn: "")
        
        return Output(pokemon: pokemon,
                      fetching: fetching,
                      error: error,
                      navigateToDetail: tapTriggered)
    }
}

extension ListPokemonViewModel {
    struct Input {
        let trigger: Driver<Void>
        let search: Driver<String>
        let tap: Driver<IndexPath>
    }
    
    struct Output {
        let pokemon: Driver<[Pokemon]>
        let fetching: Driver<Bool>
        let error: Driver<String>
        let navigateToDetail: Driver<Pokemon>
    }
}
