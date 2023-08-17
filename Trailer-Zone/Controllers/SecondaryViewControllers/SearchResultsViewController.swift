//
//  SearchResultsViewController.swift
//  Trailer-Zone
//
//  Created by ROHIT MISHRA on 03/08/23.
//

import UIKit

protocol SearchResultDelegate: AnyObject {
    func searchResultDidTapItem(_ viewModel: ShowPreviewModel)
}

class SearchResultsViewController: UIViewController {
    public var movies:[MovieDetails] = [MovieDetails]() {
        didSet {
                DispatchQueue.main.async { [weak self] in
                    self?.searchResultCollectionView.reloadData()
                }
        }
    }
    public weak var delegate: SearchResultDelegate?
    
    private let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieTileCollectionViewCell.self, forCellWithReuseIdentifier: MovieTileCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    
}

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTileCollectionViewCell.identifier, for: indexPath) as? MovieTileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie.posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let titleName = movie.originalName ?? movie.originalTitle else {
            return
        }
        RequestHandler.shared.getMovie(with: titleName) { result in
            switch result {
            case .success(let videoElement):
                self.delegate?.searchResultDidTapItem(ShowPreviewModel(title: titleName, utube: videoElement, showOverview: movie.overview ?? "unknown"))

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

