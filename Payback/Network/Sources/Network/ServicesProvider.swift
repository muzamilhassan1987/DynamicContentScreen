//
//  ServicesProvider.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 05/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

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
