import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var navigationController = UINavigationController()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard window != nil else { return false }
        let viewController = MainViewController.instantiate()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}
