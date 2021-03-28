
import UIKit
import SafariServices
import AVKit
import AVFoundation
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
    
    func showWebController(url: String) {
        
        if let url = URL(string: url) {
            
            let config = SFSafariViewController.Configuration()
            
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            
            self.rootController.present(vc, animated: true)
            
        }
        
    }
    
    func playVideo(url: String) {
        
        let player = AVPlayer(url: URL(string: url)!)
        
        let vc = AVPlayerViewController()
        
        vc.player = player
        
        self.rootController.present(vc, animated: true) {
            
            vc.player?.play()
            
        }
    }
    
}
