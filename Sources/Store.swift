//
//  Store.swift
//  CoordinatorService
//
//  Created by Douglas Alexandre Barros Taquary on 09/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import Foundation
import CoordinatorServiceInterface

final class Store: StoreInterface {
    var dependencies = [String: Any]()

    func get<T>(_ arg: T.Type) -> T? {
        let name = String(describing: arg)
        return dependencies[name] as? T
    }

    func register<T>(_ arg: Dependency, forMetaType metaType: T.Type) {
        let name = String(describing: metaType)
        dependencies[name] = arg
    }
}
