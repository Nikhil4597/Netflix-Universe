import UIKit

class UpComingViewController: UIViewController {
    private var movies: [MovieDetails] = [MovieDetails]()
    private let numberOfItemsInRow: CGFloat = 2
    private let spacing: CGFloat = 20
    private let sectionInsets = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
    
    private let tiles: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieTileCollectionViewCell.self, forCellWithReuseIdentifier: MovieTileCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tiles)
        tiles.delegate = self
        tiles.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tiles.frame = view.bounds
    }
}

extension UpComingViewController: UICollectionViewDelegate {
}

extension UpComingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTileCollectionViewCell.identifier, for: indexPath) as? MovieTileCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        if let imagePath = movie.posterPath {
            cell.configure(with: imagePath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        
        guard let titleName = movie.originalName ?? movie.originalTitle else {
            return
        }
        
        RequestHandler.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let moviePreviewController = MoviePreviewController()
                    moviePreviewController.configure(with: ShowPreviewModel(title: titleName, utube: videoElement, showOverview: movie.overview ?? "unknown"))
                    self?.navigationController?.pushViewController(moviePreviewController, animated: true)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension UpComingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - sectionInsets.left - sectionInsets.right - (numberOfItemsInRow - 1) * spacing
        let cellWidth = availableWidth/numberOfItemsInRow
        return CGSize(width: cellWidth, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}


// MARK: -  Private Methods
extension UpComingViewController {
    private func fetchUpcoming() {
        RequestHandler.shared.getUpcomingShows { [weak self] result in
            switch result {
            case .success(let shows):
                DispatchQueue.global().async {
                    self?.movies = shows
                    DispatchQueue.main.async {
                        self?.tiles.reloadData()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
