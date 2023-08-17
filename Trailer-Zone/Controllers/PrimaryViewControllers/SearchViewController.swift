import UIKit

class SearchViewController: UIViewController {
    private var movies: [MovieDetails] = [MovieDetails]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search for moive or Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()

        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        let model = MovieViewModel(titleName: movie.originalName ?? movie.originalTitle ?? "unknown", posterURL: movie.posterPath ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let titleName = movie.originalName ?? movie.originalTitle else {
            return
        }
         
        RequestHandler.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let viewController = MoviePreviewController()
                    viewController.configure(with: ShowPreviewModel(title: movie.originalName ?? movie.originalTitle ?? "unknown", utube: videoElement, showOverview: movie.overview ?? ""))
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: -
extension SearchViewController: UISearchResultsUpdating, SearchResultDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultController.delegate = self
        
        RequestHandler.shared.search(with: query) { result in
            switch result {
            case .success(let movies):
                resultController.movies = movies
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func searchResultDidTapItem(_ viewModel: ShowPreviewModel) {
        DispatchQueue.main.async{ [weak self] in
            let viewController = MoviePreviewController()
            viewController.configure(with: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
}

// MARK: -  Private methods
extension SearchViewController {
    private func fetchDiscoverMovies() {
        RequestHandler.shared.getDiscoverMovies{ [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
