//
//  ViewController.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import UIKit
import ConstraintKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private var videos: [Video] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let videoCellRegistration = UICollectionView.CellRegistration<VideoCollectionViewCell, Video> { cell, indexPath, video in
        cell.configure(with: video)
    }
    
    private let emptyView: UIView = {
        let view = UIView()
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.numberOfLines = 0
        
        label.text = String(localized: "Please type in a word or phrase in the search bar to start learning")
        
        view.addSubview(label)
        label.pinAllEdges()
        
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel()
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        title = String(localized: "Smart Sign Dictionary")
        view.backgroundColor = .systemGroupedBackground
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(collectionView)
        
        collectionView.pin(edges: .top(spacing: 0), .bottom(spacing: 0))
        collectionView.pin(edges: .leading(spacing: 0), .trailing(spacing: 0), to: view.readableContentGuide)
        
        configureEmptyView()
        
    }
    
    // MARK: CollectionViewSetup
    
    private func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureEmptyView() {
        if videos.isEmpty {
            view.addSubview(emptyView)
            emptyView.pin(edges: .leading(spacing: 0), .trailing(spacing: 0), to: view.readableContentGuide)
            emptyView.center()
        }
        else {
            emptyView.removeFromSuperview()
        }
    }

}

// MARK: - UISearchBarDelegate Conformance
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        title = searchText
        
        Task {
            do {
                videos = try await viewModel.getVideoData(for: searchText)
                configureEmptyView()
                collectionView.reloadData()
            } catch {
                showAlert(for: error)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let video = videos[indexPath.item]
        return collectionView.dequeueConfiguredReusableCell(using: videoCellRegistration, for: indexPath, item: video)
    }
}
