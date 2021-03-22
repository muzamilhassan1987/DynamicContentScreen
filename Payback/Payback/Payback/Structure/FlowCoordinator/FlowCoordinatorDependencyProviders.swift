//
//  FlowCoordinatorDependencyProviders.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: class {
    /// Creates UIViewController
    func rootViewController() -> UINavigationController
}

protocol TileListFlowCoordinatorDependencyProvider: class {
    /// Creates UIViewController to search for a Tile
    func TileListController(navigator: TileListNavigator) -> UIViewController

   // func TileMapController() -> UIViewController
}
