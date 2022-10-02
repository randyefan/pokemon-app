//
//  DetailPokemonPreviewImageView.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import UIKit

final class DetailPokemonPreviewImageView: UIImageView {
    
    // MARK: - Component View
    
    lazy var imageTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGestureRecognizer(imageTapGesture)
    }
    
    // MARK: - Private Func
    
    private func setupView() {
        backgroundColor = .black.withAlphaComponent(0.5)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        
        addGestureRecognizer(imageTapGesture)
    }
}
