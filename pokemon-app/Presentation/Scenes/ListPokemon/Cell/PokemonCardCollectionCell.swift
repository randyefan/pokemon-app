//
//  PokemonCardCollectionCell.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 01/10/22.
//

import UIKit
import SnapKit
import SkeletonView

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
    
    // MARK: -  Private Func
    
    private func setupView() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.bottom.leading.trailing.top.equalToSuperview()
        }
    }
}
