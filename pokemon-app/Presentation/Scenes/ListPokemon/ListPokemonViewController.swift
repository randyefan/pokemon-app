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
        collection.showsVerticalScrollIndicator = true
        collection.showsHorizontalScrollIndicator = false
        collection.register(PokemonCardCollectionCell.self, forCellWithReuseIdentifier: PokemonCardCollectionCell.reuseId)
        return collection
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
        layout.sectionInset = .zero
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
    }
    
    private func setupNavbar() {
        navigationItem.titleView = searchBar
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(8)
            make.trailing.equalTo(view).offset(-8)
            make.bottom.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Extension CollectionFlowLayout

extension ListPokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 36) / 2, height: 240)
    }
}

// MARK: -  Extension Bind ViewModel

extension ListPokemonViewController {
    private func bindViewModel() {
        let input = ListPokemonViewModel.Input(trigger: trigger.asDriverOnErrorJustComplete(),
                                               search: searchBar.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)

        output.pokemon
            .flatMapLatest { (pokemon) -> Driver<[PokemonCardViewModel]> in
                let newPokemon = pokemon.map { PokemonCardViewModel(image: $0.images, isSkeleton: false) }
                return Driver.just(newPokemon)
            }
            .drive(collectionView.rx.items(cellIdentifier: PokemonCardCollectionCell.reuseId, cellType: PokemonCardCollectionCell.self)) { row, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
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
