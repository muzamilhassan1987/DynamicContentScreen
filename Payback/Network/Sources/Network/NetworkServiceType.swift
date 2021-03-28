

import Foundation
import Combine

public protocol NetworkServiceType: AnyObject {
    
    @discardableResult
    func load<T: Decodable>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never>
}

/// Defines the Network service errors.
public enum NetworkError: Error {
    
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
    
}

