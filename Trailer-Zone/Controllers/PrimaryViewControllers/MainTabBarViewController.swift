import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    /*
     * Set up tab bar items.
     */
    private func setUpTabBar() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let upComingViewController = UINavigationController(rootViewController: UpComingViewController())
        let searchviewController = UINavigationController(rootViewController: SearchViewController())
        let watchLaterViewController = UINavigationController(rootViewController: WatchLaterViewController())
        
        homeViewController.tabBarItem.image = UIImage(systemName: "house")
        upComingViewController.tabBarItem.image = UIImage(systemName: "play.rectangle.on.rectangle")
        searchviewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        watchLaterViewController.tabBarItem.image = UIImage(systemName: "eye")
        
        homeViewController.title = "Home"
        upComingViewController.title = "New & Hot"
        searchviewController.title = "Search"
        watchLaterViewController.title = "Watch Later"
        
        tabBar.tintColor = .label

        setViewControllers([
            homeViewController,
            upComingViewController,
            searchviewController,
            watchLaterViewController,
        ], animated: true)
    }
}
