import UIKit

protocol MainBusinessLogic {
    func getGenres()
    func getMovies(genreId: Int, page: Int)
}

protocol MainDataStore {}

class MainInteractor: MainBusinessLogic, MainDataStore {
    // MARK: - Properties

    lazy var worker = MainWorker()
    var presenter: MainPresentationLogic?

    func getGenres() {
        worker.requestGenres { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                print("Success Genres", response)

                self.presenter?.presentSegmentedCollectionView(response: response)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func getMovies(genreId: Int, page: Int) {
        worker.requestMovies(genreId: genreId, page: page) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                print("Success Movies", response)
                self.presenter?.presentPageCollectionView(response: response)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
