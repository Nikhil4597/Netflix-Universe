import UIKit
import WebKit

class MoviePreviewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let webView: WKWebView = {
            let webView = WKWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false
            return webView
    }()
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Unknown"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "Looks like you are facing some kind of network issue."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let watchLaterButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .white
        button.setTitle("Watch Later", for: .normal)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let watchInBrowserButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .white
        button.setTitle("Watch in Browser", for: .normal)
        button.setImage(UIImage(systemName: "arrow.up.right"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.numberOfLines = 0
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpButtonActions()
        view.addSubview(scrollView)

        let subViews = [webView, headerTitle, overviewLabel, watchLaterButton, watchInBrowserButton]
        for subView in subViews {
            scrollView.addSubview(subView)
        }
        
        scrollView.addSubview(containerView)
//        setUpButtonActions()
        activateContraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = view.bounds.size
    }

    // MARK: Constraints
    
    private func activateContraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Container view constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        // WebView constraints
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 330),
        ])
        
        // HeaderTitle Constraints
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            headerTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            headerTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            headerTitle.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        // OverviewLabel Constraints
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            overviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            overviewLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Watch Later Button Constraints
        NSLayoutConstraint.activate([
            watchLaterButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 40),
            watchLaterButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            watchLaterButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        // Watch in browser constraints
        NSLayoutConstraint.activate([
            watchInBrowserButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 40),
            watchInBrowserButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -10),
            watchInBrowserButton.heightAnchor.constraint(equalToConstant: 43)
        ])
        
    }
    
}


// MARK: - Scrollview Delegate
extension MoviePreviewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
    }
}

// MARK: - Private Methods
extension MoviePreviewController {
    private func setUpButtonActions() {
        watchInBrowserButton.addTarget(self, action: #selector(watchInBrowserTapped), for: .touchUpInside)
    }
    
    @objc private func watchLaterButtonTapped() {
        
    }
    
    @objc private func watchInBrowserTapped() {
        print("Button tapped")
    }
}


// MARK: - Public Methods
extension MoviePreviewController {
    public func configure(with model: ShowPreviewModel) {
        headerTitle.text = model.title
        
        overviewLabel.text = model.showOverview
        if let url = URL(string: "https://www.youtube.com/embed/\(model.utube.id.videoID)") {
            webView.load(URLRequest(url: url))
        }
    }
}
