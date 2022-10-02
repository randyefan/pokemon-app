//
//  DetailPokemonViewController.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import UIKit
import RxCocoa

class DetailPokemonViewController: MVVMViewController<DetailPokemonViewModel> {
    
    // MARK: - Component View
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var componentView: DetailPokemonContentView = {
        let view = DetailPokemonContentView()
        return view
    }()
    
    // MARK: - Variable
    
    let trigger: PublishRelay<Void> = .init()

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.pokemon.name ?? ""
        
        setupView()
        setupCollectionView()
        bindViewModel()
        
        trigger.accept(())
    }
    
    // MARK: - Private Func
    
    private func setupView() {
        view.backgroundColor = .white
        
        componentView.setupView(viewModel: DetailPokemonContentViewModel(image: viewModel.pokemon.images, pokemon: viewModel.pokemon))
        
        view.addSubview(scrollView)
        scrollView.addSubview(componentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        componentView.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        componentView.collectionView.collectionViewLayout = layout
    }
    
}

extension DetailPokemonViewController {
    private func bindViewModel() {
        let input = DetailPokemonViewModel.Input(triggered: trigger.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.data
            .flatMapLatest { (pokemon) -> Driver<[PokemonCardViewModel]> in
                    .just(pokemon.map { PokemonCardViewModel(image: $0.images, isSkeleton: false) })
            }
            .drive(componentView.collectionView.rx.items(cellIdentifier: PokemonCardCollectionCell.reuseId, cellType: PokemonCardCollectionCell.self)) { row, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        componentView.collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension CollectionFlowLayout (For Sizing Cell)

extension DetailPokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 169, height: 240)
    }
}

// MARK: - Extension Collection View Delegate

extension DetailPokemonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = collectionView.numberOfItems(inSection: 0)
        
        // To Handle Pagination
        if indexPath.row == count - 1 {
            trigger.accept(())
        }
    }
}
