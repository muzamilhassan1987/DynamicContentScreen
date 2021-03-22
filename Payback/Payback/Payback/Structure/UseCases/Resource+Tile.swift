//
//  Resource+Vehicle.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

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
        //return Resource<TilesResponseModel>(url: url)
    }
}
//https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891
