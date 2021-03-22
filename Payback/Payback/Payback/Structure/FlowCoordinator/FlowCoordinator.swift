//
//  FlowCoordinator.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit

/// A `FlowCoordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol FlowCoordinator: class {

    /// Stars the flow
    func start()
}

