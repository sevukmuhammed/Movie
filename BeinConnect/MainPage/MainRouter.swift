import UIKit

protocol MainRoutingLogic {}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    // MARK: - Properties

    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
}
