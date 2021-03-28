
import Foundation
import Combine

public final class Scheduler {

    public static var backgroundWorkScheduler: OperationQueue = {
       
        let operationQueue = OperationQueue()
        
        operationQueue.maxConcurrentOperationCount = 5
        
        operationQueue.qualityOfService = QualityOfService.userInitiated
        
        return operationQueue
    }()

    public static let mainScheduler = RunLoop.main

}
