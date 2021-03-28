
import UIKit

/// The application flow coordinator. Takes responsibility about coordinating view controllers and driving the flow
class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider & TileListFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let navController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        
        let tileListFlowCoordinator = TileListFlowCoordinator(rootController: navController, dependencyProvider: self.dependencyProvider)
        tileListFlowCoordinator.start()

        self.childCoordinators = [tileListFlowCoordinator]
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

}
