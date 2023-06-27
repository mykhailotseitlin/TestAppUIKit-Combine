//
//  StoryCollectionViewCell.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import UIKit
import Combine

final class StoryCollectionViewCell: UICollectionViewCell {
    
    struct Content {
        
        let fullName: String
        let avatar: String
        
        init(_ userModel: UserModel) {
            self.fullName = userModel.firstName + " " + userModel.lastName
            self.avatar = userModel.avatar
        }
        
    }
    
    private var cancellable: Set<AnyCancellable> = []
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func configure(_ content: Content) {
        titleLabel.text = content.fullName
        loadImageIfNeeded(content.avatar)
    }
    
}

private typealias PrivateHelper = StoryCollectionViewCell
private extension PrivateHelper {
    
    func setupLayout() {
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func loadImageIfNeeded(_ url: String) {
        guard let imageURL = URL(string: url), avatarImageView.image == nil else { return }
        
        URLSession.shared.dataTaskPublisher(for: imageURL)
            .compactMap { $0.data }
            .compactMap { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(#line, #function, completion)
            } receiveValue: { [weak self] image in
                self?.avatarImageView.image = image
            }
            .store(in: &cancellable)
    }
    
}

