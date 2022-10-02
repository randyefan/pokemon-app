//
//  DetailPokemonContentLabelView.swift
//  pokemon-app
//
//  Created by Randy Efan Jayaputra on 02/10/22.
//

import UIKit

final class DetailPokemonContentLabelView: UIView {
    
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
