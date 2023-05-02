import UIKit
import AVKit

protocol MainDisplayLogic: AnyObject, ButtonHandler, SelectionHandler {
    func displaySegmentedCollectionView(genres: [MainModels.Genre])
    func displayPageCollectionView(results: [MainModels.MoviesResult])
}

class MainViewController: UIViewController {
    // MARK: - Properties

    private var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    private var interactor: MainBusinessLogic?
    
    @IBOutlet private var pageCollectionView: UICollectionView!
    @IBOutlet private var segmentedCollectionView: UICollectionView!
    private var player: AVPlayer?

    private var genresDataSources: SegmentedCollectionViewDataSource!
    private var pageDataSources: PageCollectionViewDataSource!

    private var selectedIndex: Int = 0

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        genresDataSources = SegmentedCollectionViewDataSource(components: [], handler: self)
        pageDataSources = PageCollectionViewDataSource(components: [], genres: [], handler: self)
    }

    static func instantiate() -> Self {
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? Self {
            return vc
        }
        return storyboard.instantiateInitialViewController() as! Self
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        interactor?.getGenres()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        pageCollectionView.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .left
        pageCollectionView.addGestureRecognizer(swipeLeft)

        pageCollectionView.isScrollEnabled = false
    }
    
    // MARK: - SwipeGesture
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                if genresDataSources.components.count - 1 > selectedIndex {
                    selectedIndex += 1
                }
            case .right:
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            default:
                break
            }

            let genreId = genresDataSources.components[selectedIndex].id
            interactor?.getMovies(genreId: genreId, page: 1)

            DispatchQueue.main.async {
                self.pageCollectionView.scrollToItem(
                    at: IndexPath(row: self.selectedIndex, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
                self.segmentedCollectionView.selectItem(
                    at: IndexPath(row: self.selectedIndex, section: 0),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
            }
        }
    }
    
    // MARK: - Setup UICollectionViews
    
    private func setupCollectionView() {
        segmentedCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: "genreCell")
        let segmentedLayout = UICollectionViewFlowLayout()
        segmentedLayout.itemSize = CGSize(width: view.frame.width / 3, height: 35)
        segmentedLayout.scrollDirection = .horizontal
        segmentedCollectionView?.collectionViewLayout = segmentedLayout

        pageCollectionView.register(PageCell.self, forCellWithReuseIdentifier: "pageCell")
        pageCollectionView?.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
        layout.scrollDirection = .horizontal
        pageCollectionView?.collectionViewLayout = layout

        segmentedCollectionView.dataSource = genresDataSources
        segmentedCollectionView.delegate = genresDataSources
        pageCollectionView.dataSource = pageDataSources
        pageCollectionView.delegate = pageDataSources
    }
    
    // MARK: - AVKit
    
    func playVideo() {
        guard let videoURL = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8") else {
            print("Invalid URL")
            return
        }
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            self.player?.play()
        }
    }
}

extension MainViewController: MainDisplayLogic {
    
    // MARK: - MainDisplayLogic
    
    func displaySegmentedCollectionView(genres: [MainModels.Genre]) {
        genresDataSources.components = genres
        segmentedCollectionView.reloadData()

        guard let firstGenre = genres.first else { return }
        let indexPath = IndexPath(item: 0, section: 0)
        segmentedCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        interactor?.getMovies(genreId: firstGenre.id, page: 1)
    }

    func displayPageCollectionView(results: [MainModels.MoviesResult]) {
        pageDataSources.components = results
        pageDataSources.genres = genresDataSources.components
        pageCollectionView.reloadData()
    }
    
    // MARK: - SelectionHandler
    
    func itemDidSelect() {
        playVideo()
    }
    
    // MARK: - ButtonHandler
    
    func handle(index: Int) {
        selectedIndex = index
        let genreId = genresDataSources.components[selectedIndex].id
        interactor?.getMovies(genreId: genreId, page: 1)
        DispatchQueue.main.async {
            self.pageCollectionView.scrollToItem(
                at: IndexPath(row: self.selectedIndex, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            self.segmentedCollectionView.selectItem(
                at: IndexPath(row: self.selectedIndex, section: 0),
                animated: true,
                scrollPosition: .centeredHorizontally
            )
        }
    }
}
