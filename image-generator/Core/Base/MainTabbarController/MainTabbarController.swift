//
//  MainTabbarController.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import UIKit
import SwiftUI

final class MainTabbarController: UITabBarController {

    // MARK: Dependencies

    private let imageGenerationCoordinator = ImageGenerationCoordinator()
    private let favoriteImagesCoordinator = FavoriteImagesCoordinator()

    private lazy var imageGenerationViewController: UIViewController = imageGenerationCoordinator.startFlow()
    private lazy var favoriteImagesViewController: UIViewController = favoriteImagesCoordinator.startFlow()

    // MARK: Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setupTabbar()
        setupItems()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI methods

private extension MainTabbarController {

    func setupTabbar() {
        delegate = self
        let tabBar = CustomTabBar()
        tabBar.delegate = self
        setValue(tabBar, forKey: Constants.tabBarKeyValue)
        tabBar.tintColor = UIColor.buttonBackgroundColor
    }

    func setupItems() {
        imageGenerationViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "home"),
            selectedImage: nil
        )

        favoriteImagesViewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(named: "star@32"),
            selectedImage: nil
        )

        viewControllers = [
            imageGenerationViewController,
            favoriteImagesViewController
        ]
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabbarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        if fromView != toView {
            UIView.transition(
                from: fromView,
                to: toView, duration: 0.3,
                options: [.transitionCrossDissolve],
                completion: nil
            )
        }
        return true
    }
}

// MARK: - Constants

private extension MainTabbarController {

    enum Constants {
        static let tabBarKeyValue = "tabBar"
    }
}
