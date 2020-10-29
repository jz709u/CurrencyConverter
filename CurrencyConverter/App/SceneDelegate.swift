import UIKit
import SwiftUI

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        _presentRootViewIn(scene: scene)
    }
    
    // MARK: - Private Methods
    
    private func _presentRootViewIn(scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: NavigationView(content: {CurrencyConversionSView()}))
        self.window = window
        window.makeKeyAndVisible()
    }
}

