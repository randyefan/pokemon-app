//
//  DetailPokemonContentView.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import UIKit

// MARK: - Detail Pokemon Content View

class DetailPokemonContentView: UIView {
    
    // MARK: - Component Variable
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var backgroundImageView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var topInfo: DetailPokemonContentLabelView = {
        let view = DetailPokemonContentLabelView()
        return view
    }()
    
    lazy var bottomInfo: DetailPokemonContentLabelView = {
        let view = DetailPokemonContentLabelView()
        return view
    }()
    
    lazy var titleOtherCards: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.backgroundColor = .black
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(PokemonCardCollectionCell.self, forCellWithReuseIdentifier: PokemonCardCollectionCell.reuseId)
        return collection
    }()
    
    // MARK: - Variable
    
    private var isNeedShowFlavor: Bool = false
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    // MARK: - Public Func
    
    func setupView(viewModel: DetailPokemonContentViewModel) {
        // Image
        imageView.sd_setImage(with: viewModel.image)
        
        topInfo.setupView(title: viewModel.pokemon.name ?? "",
                          subtitle: viewModel.pokemon.types?.joined(separator: ", ") ?? "",
                          subtitleTwo: viewModel.pokemon.superType)
        
        if let flavor = viewModel.pokemon.flavorText {
            isNeedShowFlavor = true
            
            bottomInfo.setupView(title: "Flavor",
                                 subtitle: flavor)
        }
        
        titleOtherCards.text = "Other Cards"
        
    
    }
    
    // MARK: - Private Func
    
    private func layout() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(backgroundImageView)
        stackView.addArrangedSubview(topInfo)
        
        if isNeedShowFlavor {
            stackView.addArrangedSubview(bottomInfo)
        }
        
        stackView.addArrangedSubview(titleOtherCards)
        stackView.addArrangedSubview(collectionView)
        
        backgroundImageView.addSubview(imageView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.height.equalTo(360)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(240)
        }
    }
}

// MARK: - Detail Pokemon Content Label

class DetailPokemonContentLabelView: UIView {
    
    // MARK: - Component Variable
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var subtitleTwoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    // MARK: - Variable
    
    private var isShowSubtitleTwo: Bool = false
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    // MARK: - Public Func
    
    func setupView(title: String, subtitle: String, subtitleTwo: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        if let subtitleTwo = subtitleTwo {
            isShowSubtitleTwo = true
            subtitleTwoLabel.text = subtitleTwo
        }
    }
    
    // MARK: - Private Func
    
    private func layout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        if isShowSubtitleTwo {
            stackView.addArrangedSubview(subtitleTwoLabel)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}