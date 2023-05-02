import UIKit

protocol MainPresentationLogic {
    func presentSegmentedCollectionView(response: MainModels.GenreTypes)
    func presentPageCollectionView(response: MainModels.Movies)
}

class MainPresenter: MainPresentationLogic {
    // MARK: - Properties

    weak var viewController: MainDisplayLogic?

    // MARK: - Use Case

    func presentSegmentedCollectionView(response: MainModels.GenreTypes) {
        viewController?.displaySegmentedCollectionView(genres: response.genres)
    }

    func presentPageCollectionView(response: MainModels.Movies) {
        viewController?.displayPageCollectionView(results: response.results)
    }
}
