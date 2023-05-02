import Foundation
import Moya

enum NetworkPorvider {
    case genres
    case movies(genreId: Int, page: Int)
}

extension NetworkPorvider: TargetType {
    var baseURL: URL {
        switch self {
        case .genres, .movies:
            return URL(string: "https://api.themoviedb.org/3")!
        }
    }

    var path: String {
        switch self {
        case .genres:
            return "/genre/movie/list"
        case .movies:
            return "/discover/movie"
        }
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
        case .genres:
            return .requestParameters(
                parameters: ["api_key": "3bb3e67969473d0cb4a48a0dd61af747", "language": "en-US"],
                encoding: URLEncoding.default
            )
        case let .movies(genreId, page):
            return .requestParameters(
                parameters: [
                    "api_key": "3bb3e67969473d0cb4a48a0dd61af747",
                    "sort_by": "popularity.desc",
                    "include_adult": false,
                    "include_video": true,
                    "page": page,
                    "with_genres": genreId
                ],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        nil
    }
}
