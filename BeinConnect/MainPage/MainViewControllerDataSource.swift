import UIKit

protocol ButtonHandler: AnyObject {
    func handle(index: Int)
}

class SegmentedCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    weak var handler: ButtonHandler?
    var components: [MainModels.Genre]

    init(components: [MainModels.Genre], handler: ButtonHandler?) {
        self.components = components
        self.handler = handler
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handler?.handle(index: indexPath.row)
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        components.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCell
        cell.myLabel.text = components[indexPath.row].name
        return cell
    }
}

class PageCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    weak var handler: SelectionHandler?
    var components: [MainModels.MoviesResult]
    var genres: [MainModels.Genre]

    init(components: [MainModels.MoviesResult], genres: [MainModels.Genre], handler: SelectionHandler?) {
        self.components = components
        self.genres = genres
        self.handler = handler
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        genres.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as! PageCell
        cell.results = components
        cell.handler = handler
        return cell
    }
}
