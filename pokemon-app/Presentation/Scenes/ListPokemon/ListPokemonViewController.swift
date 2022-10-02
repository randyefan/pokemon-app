//
//  ListPokemonViewController.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import UIKit
import RxCocoa
import RxDataSources

class ListPokemonViewController: MVVMViewController<ListPokemonViewModel> {
    
    // MARK: - Component View
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.backgroundColor = .white
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(PokemonCardCollectionCell.self, forCellWithReuseIdentifier: PokemonCardCollectionCell.reuseId)
        return collection
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    // MARK: - Variable
    
    let trigger: PublishRelay<Void> = .init()
    

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavbar()
        setupView()
        
        bindViewModel()
        
        // Trigger Fetch
        trigger.accept(())
    }
    
    // MARK: - Private Func
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
    }
    
    private func setupNavbar() {
        navigationItem.titleView = searchBar
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(errorLabel)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(8)
            make.trailing.equalTo(view).offset(-8)
            make.bottom.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(8)
            make.trailing.equalTo(view).offset(-8)
            make.centerY.equalTo(view)
        }
    }
    
    private func navigateToDetailPokemon(pokemon: Pokemon) {
        let pokemonService = PokemonServiceImpl()
        let pokemonListRepository = PokemonListRepositoryImpl(service: pokemonService)
        let pokemonDetailVM = DetailPokemonViewModel(useCase: DefaultPokemonListUseCase(repository: pokemonListRepository), pokemon: pokemon)
        let pokemonVC = DetailPokemonViewController(viewModel: pokemonDetailVM)
        
        self.navigationController?.pushViewController(pokemonVC, animated: true)
    }
}

// MARK: - Extension CollectionFlowLayout (For Sizing Cell)

extension ListPokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 36) / 2, height: 240)
    }
}

// MARK: -  Extension Bind ViewModel

extension ListPokemonViewController {
    private func bindViewModel() {
        let input = ListPokemonViewModel.Input(trigger: trigger.asDriverOnErrorJustComplete(),
                                               search: searchBar.rx.text.orEmpty.asDriver(),
                                               tap: collectionView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        Driver.zip(output.pokemon.startWith([]), output.fetching.filter { $0 }.startWith(true)) { (data, isFetching) -> [PokemonCardViewModel] in
            var newData = data.map { PokemonCardViewModel(image: $0.images) }
            
            if isFetching {
                newData.append(PokemonCardViewModel(image: nil, isSkeleton: true))
                newData.append(PokemonCardViewModel(image: nil, isSkeleton: true))
                newData.append(PokemonCardViewModel(image: nil, isSkeleton: true))
                newData.append(PokemonCardViewModel(image: nil, isSkeleton: true))
            }
            
            return newData
        }
        .drive(collectionView.rx.items(cellIdentifier: PokemonCardCollectionCell.reuseId, cellType: PokemonCardCollectionCell.self)) { row, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        output.navigateToDetail.drive(onNext: { [unowned self] pokemon in
            self.navigateToDetailPokemon(pokemon: pokemon)
        }).disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] errorMessage in
                if errorMessage.isEmpty {
                    self?.collectionView.isHidden = false
                } else {
                    self?.collectionView.isHidden = true
                    self?.errorLabel.text = errorMessage
                }
            })
            .disposed(by: disposeBag)
        
        output.pokemon
            .filter { $0.count == 0 }
            .withLatestFrom(output.error)
            .filter { $0.isEmpty }
            .drive { [weak self] _ in
                self?.collectionView.isHidden = true
                self?.errorLabel.text = "Search Not Found."
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension Collection View Delegate

extension ListPokemonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = collectionView.numberOfItems(inSection: 0)
        
        // To Handle Pagination
        if indexPath.row == count - 1 {
            trigger.accept(())
        }
    }
}
