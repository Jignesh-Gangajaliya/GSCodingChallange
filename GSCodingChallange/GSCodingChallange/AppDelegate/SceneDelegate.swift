//
//  SceneDelegate.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let service = NASAServiceImpl(apiService: NetworkClientImpl())
        let removeFavouriteService = RemoveFavouriteServiceImpl()
        let viewModel = POTDViewModelImpl(service: service, removeFavouriteService: removeFavouriteService)
        let viewControllee = POTDViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewControllee)
        viewModel.delegate = viewControllee
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        PersistentStorage.shared.saveContext()
    }
}

