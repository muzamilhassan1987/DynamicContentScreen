//
//  Realm.swift
//  Payback
//
//  Created by Systems Limited on 20/03/2021.
//

//import Foundation
//import com
//extension Publisher {
//    func writeObject<T: Object>(type: T.Type, receiveOn callbackQueue: DispatchQueue)
//        -> AnyPublisher<T, Error> where Output == Any, Failure == Error { // 1
//            let publisher = self
//                .flatMap { value in
//                    RealmSwift.Publishers.AddObject(type: type, value: value) // 2
//                }
//                .subscribe(on: realmQueue) // 3
//                .threadSafeReference() // 4
//                .receive(on: callbackQueue) // 5
//            return publisher.eraseToAnyPublisher() // 6
//    }
//}
