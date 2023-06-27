//
//  PostCollectionViewCell.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import UIKit

final class PostCollectionViewCell: UICollectionViewCell {
    
    struct Content {
        
        let name: String
        let color: UIColor?
        
        init(_ postModel: PostModel) {
            self.name = postModel.name
            self.color = UIColor(hexString: postModel.color)
        }
        
    }
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameLabel = UILabel()
    private let postImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ content: Content) {
        postImageView.backgroundColor = content.color
        nameLabel.text = content.name
    }
    
}

private typealias SetupHelper = PostCollectionViewCell
private extension SetupHelper {
    
    func setupLayout() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(postImageView)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

