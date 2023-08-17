import UIKit

enum Sections:Int {
    case TrandingMovies = 0
    case TrandingTV
    case Popular
    case Upcoming
    case TopRated
}

class HomeViewController: UIViewController {
    private var isUserGuest: Bool = true
    private var headerView: TopHeaderView?
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionView.self, forCellReuseIdentifier: CollectionView.identifier)
        return tableView
    }()
    
    let sectionTiles: [String] = ["Tranding Movies", "Tranding TV", "Popular", "Upcoming", "Top Rated"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        configureNavigationBar()
        configureHeaderview()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            homeFeedTable.frame = view.bounds
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTiles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        // Used secondary text to update header text
        var configuration = headerView.defaultContentConfiguration()
        configuration.secondaryText = sectionTiles[section]
        configuration.secondaryTextProperties.font = .preferredFont(forTextStyle: .headline)
        configuration.secondaryTextProperties.color = .white
        
        headerView.contentConfiguration = configuration
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionView.identifier, for: indexPath) as? CollectionView else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrandingMovies.rawValue:
            RequestHandler.shared.getTrandingMovies{ result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
            
        case Sections.TrandingTV.rawValue:
            RequestHandler.shared.getTrandingTvShows{ result in
                switch result {
                case .success(let tvShows):
                    cell.configure(with: tvShows)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
            
        case Sections.Popular.rawValue:
            RequestHandler.shared.getPopularShows{ result in
                switch result {
                case .success(let popularShow):
                    cell.configure(with: popularShow)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
            
        case Sections.Upcoming.rawValue:
            RequestHandler.shared.getUpcomingShows{ result in
                switch result {
                case .success(let upcomingShow):
                    cell.configure(with: upcomingShow)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        case Sections.TopRated.rawValue:
            RequestHandler.shared.getTopRatedShow{ result in
                switch result {
                case .success(let topRatedShow):
                    cell.configure(with: topRatedShow)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTiles.count
    }
}

// MARK: - collectionViewCellDelegate
extension HomeViewController: collectionViewCellDelegate {
    func collectionViewCellTap(_ cell: CollectionView, viewModel: ShowPreviewModel) {
        
        print("Title: \(viewModel.title) ,id: \(viewModel.utube.id) ")
        DispatchQueue.main.async {[weak self] in
            let previewController = MoviePreviewController()
            previewController.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(previewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y + defaultOffSet
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offSet))
    }
}

// MARK: - Private methods
extension HomeViewController {
    private func fetchTradingMovie() {
        RequestHandler.shared.getTrandingMovies(completion: { result in
            switch result {
            case .success(let movies):
                print("Movies: \(movies)")
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }
    
    private func configureNavigationBar() {
        var image = UIImage(systemName: "swift")
        image = image?.withTintColor(.systemOrange)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
                    UIBarButtonItem(image: UIImage(systemName: "sparkles.tv"), style: .done, target: self, action: nil),
                ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeaderview() {
        headerView = TopHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        
        RequestHandler.shared.getTrandingMovies {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let movies):
                let randomMovie = movies.randomElement()
                strongSelf.headerView?.configure(with: MovieViewModel(titleName: randomMovie?.originalName ?? randomMovie?.originalTitle ?? "unkonwn", posterURL: randomMovie?.posterPath ?? "default"))
                
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
