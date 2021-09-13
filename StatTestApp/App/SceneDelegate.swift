//  Created by Anton Klimenko

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let view = MatchScreenViewController()
        let networkService = NetworkService()
        let presenter = MatchScreenPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

