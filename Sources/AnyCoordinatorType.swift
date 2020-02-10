//
//  AnyCoordinatorType.swift
//  CoordinatorService
//
//  Created by Douglas Alexandre Barros Taquary on 09/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import Foundation
import CoordinatorServiceInterface

/// A type-erased container of the metatype of a `Coordinator`.
public final class AnyCoordinatorType {
    public let metatype: Any
    public let decode: (JSONDecoder, Data) throws -> Coordinator

    public init<T: Coordinator>(_ coordinatorType: T.Type) {
        self.metatype = coordinatorType
        decode = { decoder, data in
            try decoder.decode(T.self, from: data)
        }
    }
}
