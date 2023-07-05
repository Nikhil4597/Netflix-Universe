//
//  HomeViewController.swift
//  Netflix-Universe
//
//  Created by ROHIT MISHRA on 03/07/23.
//

import UIKit

class HomeViewController: UIViewController {
    let  sectionTitles: [String] = ["Tranding Movies", "Trandong Tv", "Popular", "Upcoming Movies", "Top Rated"]
    private let homeFeedTable:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        homeFeedTable.tableHeaderView = HeroHeadUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        getTrandingMovies()
        getTrandingTV()
        getUpcomingMovies()
        getPopularMovies()
        getTopRatedMovies()
    }
    
    private func configureNavBar() {
            var img = UIImage(named: "netflixLogo")
        img = img?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func getTrandingMovies() {
        APICaller.shared.getTradingMovies(completion: { results in
            switch results {
            case .success(let trandingMovies):
                print(trandingMovies.count)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    private func getTrandingTV() {
        APICaller.shared.getTradingTV(completion: { results in
            switch results {
            case .success(let trandingTV):
                print(trandingTV.count)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    private func getUpcomingMovies() {
        APICaller.shared.getUpcomingMovies(completion: { results in
            switch results {
            case .success(let upcomingMovies):
                print(upcomingMovies.count)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    private func getPopularMovies() {
        APICaller.shared.getPopularMovies(completion: { results in
            switch results {
            case .success(let popularMovies):
                print(popularMovies.count)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    private func getTopRatedMovies() {
        APICaller.shared.getTopRatedMovies(completion: { results in
            switch results {
            case .success(let topRatedMovies):
                print(topRatedMovies.count)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

// MARK: - UITableViewDelegate , UITableViewDataSource

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier,for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y , width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    // safe scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}
