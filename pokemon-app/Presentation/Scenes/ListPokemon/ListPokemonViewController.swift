//
//  ListPokemonViewController.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import UIKit

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

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupView()
    }
    
    // MARK: - Private Func
    
    private func setupNavbar() {
        navigationItem.titleView = searchBar
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
