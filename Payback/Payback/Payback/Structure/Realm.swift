//
//  Realm.swift
//  Payback
//
//  Created by Systems Limited on 28/03/2021.
//

import Foundation
import RealmSwift
extension Realm {
    func list<T: Object>(_ type: T.Type) -> List<T> {
        let objects = self.objects(type)
        let list = objects.reduce(List<T>()) { list, element -> List<T> in
            list.append(element)
            return list
        }
        
        return list
    }
}
