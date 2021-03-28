
import UIKit
import Network
/// The ApplicationComponentsFactory takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
   
    fileprivate lazy var useCase: TileUseCaseType = TileUseCase(networkService: servicesProvider.network)
    
    private let servicesProvider: ServicesProvider
    
    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {
    
    func rootViewController() -> UINavigationController {
      
        let rootViewController = UINavigationController()
        
        rootViewController.navigationBar.tintColor = UIColor.black
        
        return rootViewController
    
    }
}

extension ApplicationComponentsFactory: TileListFlowCoordinatorDependencyProvider {
    
    func TileListController(navigator: TileListNavigator) -> UIViewController {
    
        let viewModel = TileListViewModel(useCase: useCase, navigator: navigator)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "TilesListViewController") as! TilesListViewController
        
        controller.initialize(viewModel: viewModel)
        
        return controller
    
    }
}
