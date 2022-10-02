//
//  PokemonCardCollectionCell.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import UIKit
import SnapKit
import SkeletonView
import SDWebImage

class PokemonCardCollectionCell: UICollectionViewCell {
    
    // MARK: - Component View
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Public Func
    
    func bind(_ viewModel: PokemonCardViewModel) {
        if viewModel.isSkeleton {
            isSkeletonable = true
            showSkeleton()
            startSkeletonAnimation()
        } else {
            hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            imageView.sd_setImage(with: viewModel.image)
        }
    }
    
    // MARK: -  Private Func
    
    private func setupView() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.bottom.leading.trailing.top.equalToSuperview()
        }
    }
}
