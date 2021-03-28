
import Foundation

public class ServicesProvider {
    
    public let network: NetworkServiceType

    public static func defaultProvider() -> ServicesProvider {
    
        let network = NetworkService()
        
        return ServicesProvider(network: network)
    }

    public init(network: NetworkServiceType) {
        
        self.network = network
    
    }
}
