import Moya
import UIKit

class MainWorker {
    let provider = MoyaProvider<NetworkPorvider>()
    func requestGenres(completion: @escaping ((Result<MainModels.GenreTypes, Error>) -> Void)) {
        provider.request(.genres) { result in
            switch result {
            case let .success(response):
                do {
                    let genres = try response.map(MainModels.GenreTypes.self)
                    completion(.success(genres))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func requestMovies(genreId: Int, page: Int, completion: @escaping (Result<MainModels.Movies, Error>) -> Void) {
        provider.request(.movies(genreId: genreId, page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let movies = try JSONDecoder().decode(MainModels.Movies.self, from: response.data)
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
