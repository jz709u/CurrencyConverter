import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppManager.config.database.migrate()
        _presentRootViewControllerIfNotiOS13()
        return true
    }

    // MARK: - UISceneSession Lifecycle

    @available(iOS 13, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Private Methods
    
    func _presentRootViewControllerIfNotiOS13() {
        if #available(iOS 13, *) { return }
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: CurrencyConversionViewController())
        window?.makeKeyAndVisible()
    }
}

