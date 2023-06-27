//
//  ViewController.swift
//  TestAppUIKit+Combine
//
//  Created by Mykhailo Tseitlin on 27.06.2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let viewModel: ViewModelProtocol
    private var dataSource: DataSource!
    private var collectionView: UICollectionView!
    private var cancellable: Set<AnyCancellable> = []
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupLayout()
        setupDataSource()
        applySnapshot()
        bind()
        viewModel.loadData()
    }

}

private typealias PrivateHelper = ViewController
private extension PrivateHelper {
    
    func bind() {
        viewModel.subject
            .sink { [weak self] dataModel in
                self?.updateUI(with: dataModel)
            }
            .store(in: &cancellable)
    }
    
    func updateUI(with dataModel: DataModel) {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(dataModel.stories.map { .stories($0) }, toSection: .stories)
        snapshot.appendItems(dataModel.posts.map { .posts($0) }, toSection: .posts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .stories(model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StoryCollectionViewCell.self), for: indexPath) as? StoryCollectionViewCell else { return UICollectionViewCell() }
                let content = StoryCollectionViewCell.Content(model)
                cell.configure(content)
                return cell
            case let .posts(model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PostCollectionViewCell.self), for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
                let content = PostCollectionViewCell.Content(model)
                cell.configure(content)
                return cell
            }
        })
    }
    
    func applySnapshot() {
        let snapshot = Snapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func compositionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch Section(rawValue: sectionIndex) {
            case .stories:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalWidth(1/5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                return section
            case .posts:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            default:
                return nil
            }
        }
        
        return layout
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: StoryCollectionViewCell.self))
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PostCollectionViewCell.self))
    }
    
    func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension ViewController {
    
    enum Section: Int, Hashable, CaseIterable {
        
        case stories
        case posts
        
    }

    enum Item: Hashable {

        case stories(UserModel)
        case posts(PostModel)
                   
    }
    
}
