//
//  DetailPokemonViewController.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import UIKit

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

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.pokemon.name ?? ""
        
        setupView()
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
    
    

}
