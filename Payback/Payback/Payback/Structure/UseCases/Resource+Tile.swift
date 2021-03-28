
import Foundation
import Network
extension Resource {
    
    static func tiles() -> Resource<TilesResponseModel> {
       
        let url = ApiConstants.baseUrl
        
        let parameters: [String : CustomStringConvertible] = [
            "alt": "media",
            "token": "0f3f9a33-39df-4ad2-b9df-add07796a0fa"
            ]
        
        return Resource<TilesResponseModel>(url: url, parameters: parameters)
    }
}
