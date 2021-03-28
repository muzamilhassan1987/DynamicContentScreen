
import UIKit

/// The `TileListFlowCoordinator` takes control over the flows on the Tile list screen
class TileListFlowCoordinator: FlowCoordinator {
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: TileListFlowCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: TileListFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchController = self.dependencyProvider.TileListController(navigator: self)
        self.rootController.setViewControllers([searchController], animated: false)
        
    }

}

extension TileListFlowCoordinator: TileListNavigator {

    func showDetails() {
     //   let controller = self.dependencyProvider.TileMapController()
       // self.rootController.pushViewController(controller, animated: true)
    }

}
